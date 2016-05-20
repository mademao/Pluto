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

#pragma mark - 唯一表示
NSString *PltIDFV;
NSString *PltIDFA;

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
BOOL PltLogEnable = pltDefaultLogEnable;
void pltLog(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"💻%@\n", [obj description]] UTF8String]);
}
void pltRight(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"✅%@\n", [obj description]] UTF8String]);
}
void pltWarning(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"⚠️%@\n", [obj description]] UTF8String]);
}
void pltError(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    printf("%s\n", [[NSString stringWithFormat:@"🙅%@\n", [obj description]] UTF8String]);
}
void pltTime(id obj)
{
    if (!PltLogEnable) {
        return;
    }
    NSDate *date = [NSDate date];
    printf("%s\n", [[NSString stringWithFormat:@"⏰%@⏰\t%@\n", [date descriptionWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh"]], [obj description]] UTF8String]);
}

static double pltThen, pltEnd;
void pltGetCodeExecutionTime(void(^CodeNeedExecution)())
{
    pltThen = CFAbsoluteTimeGetCurrent();
    CodeNeedExecution();
    pltEnd = CFAbsoluteTimeGetCurrent();
    pltLog([NSString stringWithFormat:@"代码运行所需时间为:%f", pltEnd - pltThen]);
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
    
    PltIDFV = [[UIDevice currentDevice].identifierForVendor UUIDString];
    PltIDFA = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    
    PltSystemVersion                = [UIDevice currentDevice].systemVersion;
    PltSystemVersionNumber          = PltSystemVersion.floatValue;
    
    PltiPhone6P = PltScreenWidth    == 414.;
    PltiPhone6  = PltScreenWidth    == 375.;
    PltiPhone5  = PltScreenHeight   == 568.;
    PltiPhone4s = PltScreenHeight   == 480.;
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


#pragma mark - NSString
@implementation NSString (Pluto)
- (NSURL *)url
{
    return [NSURL URLWithString:self];
}
@end

CGFloat PltGetSize(NSString *string, CGFloat width, CGFloat fontSize)
{
    CGFloat height = [string boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize == 0 ? 17 : fontSize]} context:nil].size.height;
    return height;
}

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

UIColor *PltColorRandom()
{
    float red = arc4random() % 256;
    float green = arc4random() % 256;
    float blue = arc4random() % 256;
    return PltColorWithRGB(red, green, blue);
}

#pragma mark - UIFont
UIFont *PltSystemFontOfSize(CGFloat size)
{
    return [UIFont systemFontOfSize:size];
}


#pragma mark - UIView
@implementation UIView (Pluto)
- (CGFloat)plt_x
{
    return self.frame.origin.x;
}
- (void)setPlt_x:(CGFloat)plt_x
{
    CGRect frame = CGRectMake(plt_x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}
- (CGFloat)plt_y
{
    return self.frame.origin.y;
}
- (void)setPlt_y:(CGFloat)plt_y
{
    CGRect frame = CGRectMake(self.frame.origin.x, plt_y, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}
- (CGFloat)plt_width
{
    return self.frame.size.width;
}
- (void)setPlt_width:(CGFloat)plt_width
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, plt_width, self.frame.size.height);
    self.frame = frame;
}
-(CGFloat)plt_height
{
    return self.frame.size.height;
}
- (void)setPlt_height:(CGFloat)plt_height
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, plt_height);
    self.frame = frame;
}
- (CGPoint)plt_origin
{
    return self.frame.origin;
}
- (void)setPlt_origin:(CGPoint)plt_origin
{
    CGRect frame = CGRectMake(plt_origin.x, plt_origin.y, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}
- (CGSize)plt_size
{
    return self.frame.size;
}
- (void)setPlt_size:(CGSize)plt_size
{
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, plt_size.width, plt_size.height);
    self.frame = frame;
}
- (instancetype)plt_addToSuperview:(UIView *)superview
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    if (superview) {
        [superview addSubview:self];
    } else {
        pltWarning(@"父视图不允许为空");
    }
    return self;
}
- (instancetype)plt_addSubViews:(NSArray<UIView *> *)subViews
{
    if (subViews) {
        for (UIView *view in subViews) {
            [self addSubview:view];
        }
    } else {
        pltWarning(@"子视图组不允许为空");
    }
    return self;
}
- (void)plt_cornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}
- (void)plt_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = true;
    self.layer.borderWidth = borderWidth;
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
}
@end

#pragma mark - UILabel
@implementation UILabel (Pluto)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod(self, @selector(drawTextInRect:));
        Method method2 = class_getInstanceMethod(self, @selector(plt_drawTextInRect:));
        method_exchangeImplementations(method1, method2);
    });
}

static char pltTextOffsetXKey;
- (void)setPlt_textOffsetX:(CGFloat)plt_textOffsetX
{
    objc_setAssociatedObject(self, &pltTextOffsetXKey, [NSNumber numberWithFloat:plt_textOffsetX], OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)plt_textOffsetX
{
    return [objc_getAssociatedObject(self, &pltTextOffsetXKey) floatValue];
}

- (void)plt_drawTextInRect:(CGRect)rect
{
    CGRect rectTemp = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, self.plt_textOffsetX, 0, 0));
    [self plt_drawTextInRect:rectTemp];
}
@end


#pragma mark - UIButton
@implementation UIButton (Pluto)
- (NSString *)plt_normalTitle
{
    return [self titleForState:UIControlStateNormal];
}
- (void)setPlt_normalTitle:(NSString *)plt_normalTitle
{
    if (plt_normalTitle) {
        [self setTitle:plt_normalTitle forState:UIControlStateNormal];
    } else {
        pltWarning(@"文字不允许为空");
    }
}
- (UIColor *)plt_normalTitleColor
{
    return [self titleColorForState:UIControlStateNormal];
}
- (void)setPlt_normalTitleColor:(UIColor *)plt_normalTitleColor
{
    if (plt_normalTitleColor) {
        [self setTitleColor:plt_normalTitleColor forState:UIControlStateNormal];
    } else {
        pltWarning(@"文字颜色不允许为空");
    }
}
- (UIFont *)plt_titleFont
{
    return self.titleLabel.font;
}
- (void)setPlt_titleFont:(UIFont *)plt_titleFont
{
    if (plt_titleFont) {
        self.titleLabel.font = plt_titleFont;
    } else {
        pltWarning(@"文字字体不允许为空");
    }
}
- (instancetype)plt_addTouchUpInSideTarget:(id)target action:(SEL)action
{
    if (target || [target respondsToSelector:action]) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    } else {
        pltWarning(@"target-action 不允许为空");
    }
    return self;
}
@end
UIButton *plt_customButton(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, width, height);
    return button;
}

#pragma mark - UIImageView
@implementation UIImageView (Pluto)
- (void)plt_cornerRadiusForImageView:(CGFloat)radius
{
    if (self.image) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath);
        CGContextClip(UIGraphicsGetCurrentContext());
        [self drawRect:self.bounds];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}
@end

#pragma mark - UIScrollView
@implementation UIScrollView (Pluto)
- (CGFloat)plt_insetTop
{
    return self.contentInset.top;
}
- (void)setPlt_insetTop:(CGFloat)plt_insetTop
{
    UIEdgeInsets insets = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(plt_insetTop, insets.left, insets.bottom, insets.right);
}
- (CGFloat)plt_insetBottom
{
    return self.contentInset.bottom;
}
- (void)setPlt_insetBottom:(CGFloat)plt_insetBottom
{
    UIEdgeInsets insets = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(insets.top, insets.left, plt_insetBottom, insets.right);
}
- (CGFloat)plt_indicatorTop
{
    return self.scrollIndicatorInsets.top;
}
- (void)setPlt_indicatorTop:(CGFloat)plt_indicatorTop
{
    UIEdgeInsets inset = self.scrollIndicatorInsets;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(plt_indicatorTop, inset.left, inset.bottom, inset.right);
}
- (CGFloat)plt_indicatorBottom
{
    return self.scrollIndicatorInsets.bottom;
}
- (void)setPlt_indicatorBottom:(CGFloat)plt_indicatorBottom
{
    UIEdgeInsets inset = self.scrollIndicatorInsets;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(inset.top, inset.left, plt_indicatorBottom, inset.right);
}
- (CGFloat)plt_offsetX
{
    return self.contentOffset.x;
}
- (void)setPlt_offsetX:(CGFloat)plt_offsetX
{
    CGPoint offset = self.contentOffset;
    self.contentOffset = CGPointMake(plt_offsetX, offset.y);
}
- (CGFloat)plt_offsetY
{
    return self.contentOffset.y;
}
- (void)setPlt_offsetY:(CGFloat)plt_offsetY
{
    CGPoint offset = self.contentOffset;
    self.contentOffset = CGPointMake(offset.x, plt_offsetY);
}
@end


#pragma mark - UITableView
@implementation UITableView (Pluto)
- (void)plt_registerCellWithClass:(Class)cellClass
{
    if (cellClass) {
        [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    } else {
        pltWarning(@"类型不允许为空");
    }
}
- (void)plt_registerCellWithNibName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    if (nib) {
        [self registerNib:nib forCellReuseIdentifier:nibName];
    } else {
        pltWarning(@"nib不存在");
    }
}
@end


#pragma mark - UITableViewCell
@implementation UITableViewCell (Pluto)
+ (NSString *)plt_cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}
@end
@implementation PltTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
@end


#pragma mark - UICollectionViewCell
@implementation UICollectionViewCell (Pluto)
+ (NSString *)plt_cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}
@end


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
- (void)setPlt_placeholder:(NSString *)plt_placeholder
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plt_textChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    self.pltPlaceholderTextView.text = plt_placeholder;
}

- (NSString *)plt_placeholder
{
    if (self.pltPlaceholderTextView) {
        return self.pltPlaceholderTextView.text;
    } else {
        return nil;
    }
}

- (void)setPlt_placeholderColor:(UIColor *)plt_placeholderColor
{
    if (self.pltPlaceholderTextView) {
        self.pltPlaceholderTextView.textColor = plt_placeholderColor;
    }
}

- (UIColor *)plt_placeholderColor
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
- (void)plt_textChange
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


#pragma mark - UINavigationController
/** 为改变naviBar颜色做准备 */
@implementation UINavigationBar (Pluto)
static char pltOverlayKey;
- (UIView *)pltOverlayKey
{    return objc_getAssociatedObject(self, &pltOverlayKey);
}

- (void)setPltOverlayKey:(UIView *)overlay{
    objc_setAssociatedObject(self, &pltOverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)plt_setBackgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor
{
    if (!self.pltOverlayKey) {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[[UIImage alloc] init]];
        self.pltOverlayKey = [[UIView alloc] initWithFrame:CGRectMake(0, -PltStatusBarHeight, PltScreenWidth, PltNavigationBarHeight)];
        self.pltOverlayKey.userInteractionEnabled = NO;
        [self insertSubview:self.pltOverlayKey atIndex:0];
    }
    if (shadowColor) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 63, PltScreenWidth, 1)];
        view.backgroundColor = shadowColor;
        view.userInteractionEnabled = NO;
        [self.pltOverlayKey addSubview:view];
    }
    self.pltOverlayKey.backgroundColor = backgroundColor;
}
@end

@implementation UINavigationController (Pluto)
- (void)plt_setBarUseColor:(UIColor *)color tintColor:(UIColor *)tintColor titleFont:(UIFont *)titleFont shadowColor:(UIColor *)shadowColor
{
    if (color) {
        [self.navigationBar plt_setBackgroundColor:color shadowColor:shadowColor];
    } else {
        pltError(@"背景色不允许为空");
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (tintColor) {
        self.navigationBar.tintColor = tintColor;
        [attributes setObject:tintColor forKey:NSForegroundColorAttributeName];
    }
    
    if (titleFont) {
        [attributes setObject:titleFont forKey:NSFontAttributeName];
    }
    
    self.navigationBar.titleTextAttributes = [attributes copy];
}
@end


#pragma mark - UIImage
@implementation UIImage (Pluto)
- (UIImage *)plt_tintedImageWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    if (self) {
        CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);

        UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self drawInRect:imageRect];
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextSetAlpha(context, alpha);
        CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
        CGContextFillRect(context, imageRect);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                                 scale:self.scale
                                           orientation:self.imageOrientation];
        CGImageRelease(imageRef);
        
        UIGraphicsEndImageContext();
        
        return darkImage;
    } else {
        return nil;
    }
}
@end
UIImage *PltCreateImage(UIColor *color, CGSize size)
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - NSTimer
@interface PltTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation PltTimerTarget

- (void)pltTimerTargetAction:(NSTimer *)timer
{
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer afterDelay:0.0];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

NSTimer *PltTimerCommonModes(NSTimeInterval time, id target, SEL selector, id userInfo)
{
    PltTimerTarget *timerTarget = [[PltTimerTarget alloc] init];
    timerTarget.target = target;
    timerTarget.selector = selector;
    NSTimer *timer = [NSTimer timerWithTimeInterval:time target:timerTarget selector:@selector(pltTimerTargetAction:) userInfo:userInfo repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timerTarget.timer = timer;
    return timerTarget.timer;
}


#pragma mark - NSDate
@implementation NSDate (Pluto)
static NSDateFormatter *pltDateFormatter = nil;
- (NSString *)plt_StringWithDate:(NSString *)dateFormatterString
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pltDateFormatter = [[NSDateFormatter alloc] init];
    });
    if (dateFormatterString == nil) {
        [pltDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [pltDateFormatter setDateFormat:dateFormatterString];
    }
    return [pltDateFormatter stringFromDate:self];
}
@end