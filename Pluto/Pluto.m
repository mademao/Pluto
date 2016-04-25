//
//  Pluto.m
//  PlutoExample
//
//  Created by 马德茂 on 16/4/25.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "Pluto.h"

#pragma mark - 固定尺寸
CGRect  PltScreenBounds;
CGFloat PltScreenWidth;
CGFloat PltScreenHeight;
CGFloat PltNavigationBarHeight;
CGFloat PltTabBarHeight;
CGFloat PltStatusBarHeight;

#pragma mark - 沙盒路径
NSString *PltHomePath;
NSString *PltDocumentPath;
NSString *PltLibraryPath;
NSString *PltCachePath;
NSString *PltTempPath;

#pragma mark - Bundle
NSString *PltMainBundlePath;
NSString *PltResourcePath;
NSString *PltExecutablePath;

#pragma mark - 应用信息
NSString *PltAppBundleID;
NSString *PltAppVersion;
NSString *PltAppBuildVersion;

#pragma mark - 系统信息
NSString *PltSystemVersion;
float PltSystemVersionNumber;

#pragma mark - 系统机型
BOOL PltiPhone6P;
BOOL PltiPhone6;
BOOL PltiPhone5;
BOOL PltiPhone4s;

@implementation Pluto

+ (void)initializePluto
{
    PltScreenBounds = [UIScreen mainScreen].bounds;
    PltScreenWidth = PltScreenBounds.size.width;
    PltScreenHeight = PltScreenBounds.size.height;
    PltNavigationBarHeight = 64.f;
    PltTabBarHeight = 49.f;
    PltStatusBarHeight = 20.f;
    
    PltHomePath = NSHomeDirectory();
    PltDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    PltLibraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    PltCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    PltTempPath = NSTemporaryDirectory();
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    PltMainBundlePath = [mainBundle bundlePath];
    PltResourcePath = [mainBundle resourcePath];
    PltExecutablePath = [mainBundle executablePath];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    PltAppBundleID                  = infoDictionary[@"CFBundleIdentifier"];
    PltAppVersion                   = infoDictionary[@"CFBundleShortVersionString"];
    PltAppBuildVersion              = infoDictionary[@"CFBundleVersion"];
    
    PltSystemVersion                = [UIDevice currentDevice].systemVersion;
    PltSystemVersionNumber          = PltSystemVersion.floatValue;
    
}


@end


@implementation NSObject (Pluto)

+ (void)load
{
    //启动Pluto
    [Pluto initializePluto];
}

@end


#pragma mark - UIColor

/**
 *  将十六进制颜色数值进行拆分，返回对应RGB的值
 */
void SKScanHexColor(NSString *hexString, float *red, float *green, float *blue, float *alpha) {
    
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)], [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)], [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)], [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    if (red) {*red = ((baseValue >> 24) & 0xFF) / 255.0f;}
    if (green) {*green = ((baseValue >> 16) & 0xFF) / 255.0f;}
    if (blue) {*blue = ((baseValue >> 8) & 0xFF) / 255.0f;}
    if (alpha) {*alpha = ((baseValue >> 0) & 0xFF) / 255.0f;}
}

UIColor *PltColorWithHEX(NSString *hexString)
{
    float red, green, blue, alpha;
    SKScanHexColor(hexString, &red, &green, &blue, &alpha);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

UIColor *PltColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

UIColor *PltColorWithRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return PltColorWithRGBA(red, green, blue, 1.0f);
}
