//
//  Pluto.h
//  PlutoExample
//
//  Created by 马德茂 on 16/4/25.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma mark - 固定尺寸
/** 屏幕Bounds */
extern CGRect  PltScreenBounds;
/** 屏幕宽度 */
extern CGFloat PltScreenWidth;
/** 屏幕高度 */
extern CGFloat PltScreenHeight;
/** 导航栏高度 */
extern CGFloat PltNavigationBarHeight;
/** tabBar高度 */
extern CGFloat PltTabBarHeight;
/* 状态栏高度 */
extern CGFloat PltStatusBarHeight;


#pragma mark - 沙盒路径
/** 沙盒路径 */
extern NSString *PltHomePath;
/** Document文件夹路径 */
extern NSString *PltDocumentPath;
/** Library文件夹路径 */
extern NSString *PltLibraryPath;
/** Cache文件夹路径 */
extern NSString *PltCachePath;
/** Temp文件夹路径 */
extern NSString *PltTempPath;


#pragma mark - Bundle
/** bundle路径 */
extern NSString *PltMainBundlePath;
/** resource路径 */
extern NSString *PltResourcePath;
/** executable路径 */
extern NSString *PltExecutablePath;


#pragma mark - 应用信息
/** BundleID */
extern NSString *PltAppBundleID;
/** AppVersion */
extern NSString *PltAppVersion;
/** AppBuileVersion */
extern NSString *PltAppBuildVersion;


#pragma mark - 系统信息
/** 系统信息  */
extern NSString *PltSystemVersion;
/** 系统版本号 */
extern float PltSystemVersionNumber;


#pragma mark - 系统机型
/** 是否是6P/ 6sP */
extern BOOL PltiPhone6P;
/** 是否是6/6s */
extern BOOL PltiPhone6;
/** 是否是 5/5s */
extern BOOL PltiPhone5;
/** 是否是 4/4s */
extern BOOL PltiPhone4s;


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


#pragma mark - Pluto
@interface Pluto : NSObject
/**
 *  设置自定义是否启动，默认不启动
 */
+ (void)pltLogEnable:(BOOL)enable;
@end


#pragma mark - NSString
@interface NSString (Pluto)
/** 字符串对应的URL */
@property (nonatomic, readonly) NSURL *url;
@end


#pragma mark - UIColor

/**
 *  use hexValue like @"FFFFFF" (or @"#FFFFFF") to create a UIColor object
 */
UIColor *PltColorWithHEX(NSString *hexString);

/**
 *  带有 alpha 的 RGB
 *  @param a 0~1.0
 */
UIColor *PltColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

/**
 *  使用RGB值来创建颜色
 */
UIColor *PltColorWithRGB(CGFloat red, CGFloat green, CGFloat blue);


#pragma mark - UITextView
@interface UITextView (Pluto)
/** 占位符 */
@property (nonatomic, strong) NSString *pltPlaceholder;
/** 占位符文字颜色 */
@property (nonatomic, strong) UIColor *pltPlaceholderColor;
@end
