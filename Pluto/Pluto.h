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
#import <AdSupport/ASIdentifierManager.h>
#import <sys/utsname.h>
#import "PlutoLog.h"


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


#pragma mark - 唯一表示
/** Vindor标示符 */
extern NSString *PltIDFV;
/** 广告标示符 */
extern NSString *PltIDFA;


#pragma mark - 系统信息
/** 系统机型  */
extern NSString *PltModel;
/** 系统信息  */
extern NSString *PltSystemVersion;
/** 系统版本号 */
extern float PltSystemVersionNumber;


#pragma mark - 系统屏幕类型
/** 是否是6P/ 6sP */
extern BOOL PltiPhone6P;
/** 是否是6/6s */
extern BOOL PltiPhone6;
/** 是否是 5/5s */
extern BOOL PltiPhone5;
/** 是否是 4/4s */
extern BOOL PltiPhone4s;

/**
 *  测试一段代码执行需要的时间
 */
void pltGetCodeExecutionTime(void(^CodeNeedExecution)());


#pragma mark - GCD
/**
 *  启动一个线程来执行代码块
 */
void PltAsync(void(^block)());
/**
 *  延迟执行代码块，默认主线程执行
 *
 *  @param second 延迟时间
 *  @param queue  代码块执行所在线程
 *  @param ^block 代码块
 */
void PltAfter(double second, dispatch_queue_t queue, void(^block)());
/**
 *  多线程执行完之后，需要在主线程中执行代码块
 */
void PltLast(void(^block)());
/**
 *  启动一个线程来执行代码块，执行结束后在主线程执行代码块
 */
void PltAsyncFinish(void(^block)(), void(^finish)());


#pragma mark - Pluto
@interface Pluto : NSObject

@end


#pragma mark - NSString
@interface NSString (Pluto)
/** 字符串对应的URL */
@property (nonatomic, readonly) NSURL *plt_url;
@end
/** 获取文字在指定宽度内的高度 */
CGFloat PltGetSize(NSString *string, CGFloat width, CGFloat fontSize);

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

/**
 *  创建随机色
 */
UIColor *PltColorRandom();

#pragma mark - UIFont
/**
 *  创建系统字体的便利构造器

 */
UIFont *PltSystemFontOfSize(CGFloat size);


#pragma mark - UIView
@interface UIView (Pluto)
/**
 *  视图origin.x
 */
@property (nonatomic, assign) CGFloat   plt_x;
/**
 *  视图origin.y
 */
@property (nonatomic, assign) CGFloat   plt_y;
/**
 *  视图midX
 */
@property (nonatomic, assign, readonly) CGFloat   plt_midX;
/**
 *  视图maxX
 */
@property (nonatomic, assign, readonly) CGFloat   plt_maxX;
/**
 *  视图midY
 */
@property (nonatomic, assign, readonly) CGFloat   plt_midY;
/**
 *  视图maxY
 */
@property (nonatomic, assign, readonly) CGFloat   plt_maxY;
/**
 *  视图size.width
 */
@property (nonatomic, assign) CGFloat   plt_width;
/**
 *  视图size.height
 */
@property (nonatomic, assign) CGFloat   plt_height;
/**
 *  视图origin
 */
@property (nonatomic, assign) CGPoint   plt_origin;
/**
 *  视图size
 */
@property (nonatomic, assign) CGSize    plt_size;
/**
 *  设置父视图
 */
- (instancetype)plt_addToSuperview:(UIView *)superview;
/**
 *  添加子视图组
 */
- (instancetype)plt_addSubViews:(NSArray<UIView *> *)subViews;
/**
 *  设定圆角半径
 */
- (instancetype)plt_cornerRadius:(CGFloat)radius;
/**
 *  同时设定 圆角半径 描边宽度 描边颜色
 */
- (instancetype)plt_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end


#pragma mark - UILabel
@interface UILabel (Pluto)
/** 文字偏移量 */
@property (nonatomic, assign) CGFloat plt_textOffsetX;
@end


#pragma mark - UIButton
@interface UIButton (Pluto)
/** 正常情况下的文字 */
@property (nonatomic, strong) NSString *plt_normalTitle;
/** 正常情况下文字颜色 */
@property (nonatomic, strong) UIColor *plt_normalTitleColor;
/** 文字字体 */
@property (nonatomic, strong) UIFont *plt_titleFont;
/**
 *  快速设置button在TouchUpInSide的事件
 */
- (instancetype)plt_addTouchUpInSideTarget:(id)target action:(SEL)action;
@end
/**
 *  快速创建一个自定义button
 */
UIButton *PltCustomButton(CGFloat x, CGFloat y, CGFloat width, CGFloat height);


#pragma mark - UIImageView
@interface UIImageView (Pluto)
/**
 *  UIImageView的切圆角方法
 */
- (instancetype)plt_cornerRadiusForImageView:(CGFloat)radius;
@end


#pragma mark - UIScrollView
@interface UIScrollView (Pluto)
/** 顶部内偏量 */
@property (nonatomic, assign) CGFloat plt_insetTop;
/** 底部内偏量 */
@property (nonatomic, assign) CGFloat plt_insetBottom;
/** 指示器顶部内偏量 */
@property (nonatomic, assign) CGFloat plt_indicatorTop;
/** 指示器底部内偏量 */
@property (nonatomic, assign) CGFloat plt_indicatorBottom;
/** 横向偏移量 */
@property (nonatomic, assign) CGFloat plt_offsetX;
/** 纵向偏移量 */
@property (nonatomic, assign) CGFloat plt_offsetY;
@end


#pragma mark - UITableView
@interface UITableView (Pluto)
/**
 *  根据类名注册cell
 */
- (instancetype)plt_registerCellWithClass:(Class)cellClass;
/**
 *  根据nib注册cell
 */
- (instancetype)plt_registerCellWithNibName:(NSString *)nibName;
@end


#pragma mark - UITableViewCell
@interface UITableViewCell (Pluto)
/**
 *  获取cell的重用标志
 */
+ (NSString *)plt_cellReuseIdentifier;
@end
/**
 *  自定义快速搭建Default类型cell
 */
@interface PltTableViewCell : UITableViewCell
@end


#pragma mark - UICollectionViewCell
@interface UICollectionViewCell (Pluto)
/**
 *  获取cell的重用标志
 */
+ (NSString *)plt_cellReuseIdentifier;
@end


#pragma mark - UITextView
@interface UITextView (Pluto)
/** 占位符 */
@property (nonatomic, strong) NSString *plt_placeholder;
/** 占位符文字颜色 */
@property (nonatomic, strong) UIColor *plt_placeholderColor;
@end


#pragma mark - UINavigationController
@interface UINavigationController (Pluto)
/**
 *  设置Bar颜色，渲染色和阴影色
 */
- (instancetype)plt_setBarUseColor:(UIColor *)color tintColor:(UIColor *)tintColor titleFont:(UIFont *)titleFont shadowColor:(UIColor *)shadowColor;
@end


#pragma mark - UIImage
@interface UIImage (Pluto)
/**
 *  生成带渲染色的图片
 */
- (UIImage *)plt_tintedImageWithColor:(UIColor *)color alpha:(CGFloat)alpha;
@end
/*
 *  根据颜色生成图片
 */
UIImage *PltCreateImage(UIColor *color, CGSize size);


#pragma mark - NSData
@interface NSData (Pluto)
typedef enum : NSUInteger {
    PltImageFormatUnknow,
    PltImageFormatPNG,
    PltImageFormatJPEG,
    PltImageFormatGIF
} PltImageFormat;
/**
 * 通过图片data判断图片类型
 */
- (PltImageFormat)plt_getImageFormat;
@end


#pragma mark - NSTimer
/**
 *  创建一个循环执行的CommonModes类型的Timer
 */
NSTimer *PltTimerCommonModes(NSTimeInterval time, id target, SEL selector, id userInfo);


#pragma mark - NSDate
@interface NSDate (Pluto)
/**
 *  由单例来格式化输出时间字符串
 */
- (NSString *)plt_StringWithDate:(NSString *)dateFormatterString;
@end

