//
//  PlutoLog.m
//  PlutoExample
//
//  Created by 马德茂 on 16/8/1.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "PlutoLog.h"

#pragma mark -时间转换
static NSDateFormatter *pltLogDateFormatter = nil;
NSString *pltLog_StringWithDate(NSDate *date, BOOL isFileName)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pltLogDateFormatter = [[NSDateFormatter alloc] init];
        [pltLogDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    });
    if (isFileName) {
        [pltLogDateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    } else {
        [pltLogDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [pltLogDateFormatter stringFromDate:date];
}

#pragma mark - 自定义输出
/** 自定义输出是否启动，默认不启动 */
BOOL PltLogEnable = pltDefaultLogEnable;


#pragma mark - 日志写入
static dispatch_queue_t pltLogQueue;
static NSString *logName;
static NSString *currentLogName;
static NSString *crashName;
void pltWriteLog(NSString *string)
{
    dispatch_async(pltLogQueue, ^{
        @autoreleasepool {
            NSFileManager *manager = [NSFileManager defaultManager];
            if (![manager fileExistsAtPath:currentLogName]) {
                [string writeToFile:currentLogName atomically:YES encoding:NSUTF8StringEncoding error:nil];
            } else {
                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:currentLogName];
                [handle seekToEndOfFile];
                [handle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
                [handle closeFile];
            }
        }
    });
}

void plt_UncaughtExceptionHandler(NSException* exception)
{
    NSString *name = [exception name];
    NSString *reason = [exception reason];
    NSArray *symbols = [exception callStackSymbols]; //异常发生时的调用栈
    NSMutableString *strSymbols = [[NSMutableString alloc] init]; //将调用栈拼成输出日志的字符串
    for (NSString *item in symbols)
    {
        [strSymbols appendString:item];
        [strSymbols appendString:@"\r\n"];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSString *dateStr = pltLog_StringWithDate([NSDate date], NO);
    
    NSString *crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n——————————————————\r\n\r\n", dateStr, name, reason, strSymbols];
    //把错误日志写到文件中
    if (![fileManager fileExistsAtPath:crashName]) {
        [crashString writeToFile:crashName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:crashName];
        [handle seekToEndOfFile];
        [handle writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    }
}

#pragma mark - 自定义输出
void pltLog(id obj)
{
    NSDate *date = [NSDate date];
    NSString *dateStr = pltLog_StringWithDate(date, NO);
    NSString *string = [NSString stringWithFormat:@"➡️%@\n%@\n", dateStr, [obj description]];
    pltWriteLog(string);
    
    if (!PltLogEnable) {
        return;
    }
    printf("%s", [string UTF8String]);
}
void pltRight(id obj)
{
    NSString *string = [NSString stringWithFormat:@"✅%@\n", [obj description]];
    pltWriteLog(string);
    
    if (!PltLogEnable) {
        return;
    }
    printf("%s", [string UTF8String]);
}
void pltWarning(id obj)
{
    NSString *string = [NSString stringWithFormat:@"⚠️%@\n", [obj description]];
    pltWriteLog(string);
    
    if (!PltLogEnable) {
        return;
    }
    printf("%s", [string UTF8String]);
}
void pltError(id obj)
{
    NSString *string = [NSString stringWithFormat:@"❌%@\n", [obj description]];
    pltWriteLog(string);
    if (!PltLogEnable) {
        return;
    }
    printf("%s", [string UTF8String]);
}

@implementation PlutoLog
+ (void)pltLogEnable:(BOOL)enable
{
    PltLogEnable = enable;
}

+ (void)pltClearLogBeforeDay:(NSUInteger)day
{
    dispatch_async(pltLogQueue, ^{
        @autoreleasepool {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *paths = [manager contentsOfDirectoryAtPath:logName error:nil];
            NSEnumerator *enumerator = [paths objectEnumerator];
            NSString *fileName;
            while (fileName = [enumerator nextObject]) {
                NSString *dateString = pltLog_StringWithDate([NSDate dateWithTimeIntervalSinceNow:(long)-day * 24 * 60 * 60], YES);
                dateString = [dateString stringByAppendingString:@".log"];
                if ([fileName compare:dateString] == NSOrderedDescending) {
                    [manager removeItemAtPath:[logName stringByAppendingPathComponent:fileName] error:nil];
                }
            }
        }
    });
}

+ (void)pltClearCrashBeforeDay:(NSUInteger)day
{
    dispatch_async(pltLogQueue, ^{
        @autoreleasepool {
            NSFileManager *manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:crashName]) {
                NSString *crashString = [NSString stringWithContentsOfFile:crashName encoding:NSUTF8StringEncoding error:nil];
                NSString *dateString = pltLog_StringWithDate([NSDate dateWithTimeIntervalSinceNow:(long)day * -24 * 60 *60], NO);
                
                //日志不空白
                if ([crashString rangeOfString:@"<- "].location != NSNotFound) {
                    while (1) {
                        NSRange range = NSMakeRange(0, crashString.length);
                        range = [crashString rangeOfString:@"<- "];
                        NSString *theDateString = [crashString substringWithRange:NSMakeRange(range.location + range.length, 19)];
                        if ([dateString compare:theDateString] == NSOrderedDescending) {
                            range = [crashString rangeOfString:@"<- " options:NSCaseInsensitiveSearch range:NSMakeRange(range.location + range.length, crashString.length - range.location - range.length)];
                            if (range.location == NSNotFound) {
                                crashString = @"";
                                [crashString writeToFile:crashName atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                break;
                            } else {
                                crashString = [crashString substringWithRange:NSMakeRange(range.location, crashString.length - range.location)];
                                [crashString writeToFile:crashName atomically:YES encoding:NSUTF8StringEncoding error:nil];
                            }
                        } else {
                            break;
                        }
                    }
                }
            }
        }
    });
}

+ (void)initializePlutoLog
{
    //启动线程
    pltLogQueue = dispatch_queue_create("Pluto.framework.Log", NULL);
    dispatch_async(pltLogQueue, ^{
        @autoreleasepool {
            //log设置
            NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *PlutoLogName = [documentDirectory stringByAppendingPathComponent:@"PlutoLog"];
            logName = [PlutoLogName stringByAppendingPathComponent:@"log"];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager createDirectoryAtPath:PlutoLogName withIntermediateDirectories:NO attributes:nil error:nil];
            [manager createDirectoryAtPath:logName withIntermediateDirectories:NO attributes:nil error:nil];
            NSString *fileName = [NSString stringWithFormat:@"%@.log", pltLog_StringWithDate([NSDate date], YES)];
            currentLogName = [logName stringByAppendingPathComponent:fileName];
            crashName = [PlutoLogName stringByAppendingPathComponent:@"crash.log"];
        }
    });
}
@end

@implementation NSObject (PlutoLog)

+ (void)load
{
    NSSetUncaughtExceptionHandler(&plt_UncaughtExceptionHandler);
    [PlutoLog initializePlutoLog];
}

@end
