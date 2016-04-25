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

#pragma mark - 自定义输出
/** 自定义输出是否启动，默认不启动 */
BOOL PltLogEnable = NO;
void pltLog(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[obj description] UTF8String]);
}
void pltRight(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"✅%@", [obj description]] UTF8String]);
}
void pltWarning(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"⚠️%@", [obj description]] UTF8String]);
}
void pltError(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"🙅%@", [obj description]] UTF8String]);
}

@implementation Pluto

+ (void)initializePluto
{
    PltScreenBounds        = [UIScreen mainScreen].bounds;
    PltScreenWidth         = PltScreenBounds.size.width;
    PltScreenHeight        = PltScreenBounds.size.height;
    PltNavigationBarHeight = 64.f;
    PltTabBarHeight        = 49.f;
    PltStatusBarHeight     = 20.f;
    
    PltHomePath     = NSHomeDirectory();
    PltDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    PltLibraryPath  = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    PltCachePath    = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    PltTempPath     = NSTemporaryDirectory();
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    PltMainBundlePath = [mainBundle bundlePath];
    PltResourcePath   = [mainBundle resourcePath];
    PltExecutablePath = [mainBundle executablePath];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    PltAppBundleID                  = infoDictionary[@"CFBundleIdentifier"];
    PltAppVersion                   = infoDictionary[@"CFBundleShortVersionString"];
    PltAppBuildVersion              = infoDictionary[@"CFBundleVersion"];
    
    PltSystemVersion                = [UIDevice currentDevice].systemVersion;
    PltSystemVersionNumber          = PltSystemVersion.floatValue;
    
}

+ (void)pltLogEnable:(BOOL)enable
{
    PltLogEnable = enable;
}

@end


@implementation NSObject (Pluto)

+ (void)load
{
    //启动Pluto
    [Pluto initializePluto];
}

@end


@implementation NSString (Pluto)

- (NSURL *)url
{
    return [NSURL URLWithString:self];
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


#pragma mark - UITextView
@implementation UITextView (Pluto)

/**
 *  利用runtime给UITextView添加占位TextView
 */
static char *pltPlaceholderTextViewKey;
- (void)setPltPlaceholderTextView:(UITextView *)pltPlaceholderTextView
{
    objc_setAssociatedObject(self, &pltPlaceholderTextViewKey, pltPlaceholderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITextView *)pltPlaceholderTextView
{
    return objc_getAssociatedObject(self, &pltPlaceholderTextViewKey);
}

/**
 *  利用懒加载来创建占位TextView，并设置默认字体和文字颜色，同时添加对于观察者来监测原TextView文字和字体变化
 *
 *  @param placeholder 占位文字
 */
- (void)setPltPlaceholder:(NSString *)placeholder
{
    if (!self.pltPlaceholderTextView) {
        UITextView *placeholderTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (self.font) {
            placeholderTextView.font = self.font;
        }
        placeholderTextView.textColor = [UIColor lightGrayColor];
        placeholderTextView.userInteractionEnabled = NO;
        self.pltPlaceholderTextView = placeholderTextView;
        [self addSubview:self.pltPlaceholderTextView];
        [self sendSubviewToBack:self.pltPlaceholderTextView];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    self.pltPlaceholderTextView.text = placeholder;
}

- (NSString *)pltPlaceholder
{
    if (self.pltPlaceholderTextView) {
        return self.pltPlaceholderTextView.text;
    } else {
        return nil;
    }
}

- (void)setPltPlaceholderColor:(UIColor *)placeholderColor
{
    if (self.pltPlaceholderTextView) {
        self.pltPlaceholderTextView.textColor = placeholderColor;
    }
}

- (UIColor *)pltPlaceholderColor
{
    if (self.pltPlaceholderTextView) {
        return self.pltPlaceholderTextView.textColor;
    } else {
        return nil;
    }
}

/**
 *  设置何时显示placeholder
 */
- (void)textChange
{
    if ([self.text isEqualToString:@""]) {
        self.pltPlaceholderTextView.hidden = NO;
    } else {
        self.pltPlaceholderTextView.hidden = YES;
    }
}

/**
 *  根据原TextView的文字改变来显示/隐藏占位TextView，根据原TextView来设置占位TextView字体
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        if ([self.text isEqualToString:@""]) {
            self.pltPlaceholderTextView.hidden = NO;
        } else {
            self.pltPlaceholderTextView.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"font"]) {
        self.pltPlaceholderTextView.font = change[@"new"];
    }
}

/**
 *  无需移除自身监听，因为此时自身会被释放，移除会引起野指针访问
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
