//
//  PlutoLog.h
//  PlutoExample
//
//  Created by 马德茂 on 16/8/1.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 默认输出权限
#if DEBUG
#define pltDefaultLogEnable (YES)
#else
#define pltDefaultLogEnable (NO)
#endif


#pragma mark - 自定义输出
/**
 *  自定义输出
 */
void pltLog(id obj);
/**
 *  自定义正确输出
 */
void pltRight(id obj);
/**
 *  自定义警告错误
 */
void pltWarning(id obj);
/**
 *  自定义错误输出
 */
void pltError(id obj);


@interface PlutoLog : NSObject
/**
 *  设置自定义是否启动，默认Debug开启，Release关闭
 */
+ (void)pltLogEnable:(BOOL)enable;
/**
 *  清除日志记录
 */
+ (void)pltClearLogBeforeDay:(NSUInteger)day;
/**
 *  清除crash记录
 */
+ (void)pltClearCrashBeforeDay:(NSUInteger)day;
@end
