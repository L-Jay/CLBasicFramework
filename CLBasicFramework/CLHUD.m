//
//  CLHUD.m
//  CLBasicFramework
//
//  Created by L on 13-12-11.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import "CLHUD.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "CLUIViewUtils.h"
#import "CLBasicFramework.h"

#define CLTopBarHeight (DEVICE_ISIOS7 ? 64 : 44)

#define ActivityFont [UIFont boldSystemFontOfSize:16]

#define InnerMargins 10
#define OuterMargins 40
#define MainViewMinWith 100
#define MainViewMaxWith 320-OuterMargins*2
#define MainViewMaxHeight 394

#define DurationFast   1
#define DurationNormal 2
#define DurationLong   5

#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0 alpha:0.8]
#define HUD_IMAGE_SUCCESS		@"CLBasicFramework.bundle/success-white.png"
#define HUD_IMAGE_ERROR			@"CLBasicFramework.bundle/error-white.png"

static NSString *_succeedImageName = nil;
static NSString *_failImageName = nil;

static UIImage *_backgroundImage = nil;

static UIView  *_activityView = nil;
static UILabel *_registerLabel = nil;

static UIFont  *_font = nil;
static UIColor *_textColor = nil;
static UIColor *_shadowColor = nil;

static CLHUDAnimation _animation = 0;

@interface CLHUD ()

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *mainSuperView;

@property (nonatomic, retain) UIImageView *mainView;
@property (nonatomic, retain) UIView *activityView;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, copy) NSString *oldText;
@property (nonatomic, copy) NSString *oldImageName;

@property (nonatomic) BOOL canTouch;
@property (nonatomic) BOOL showBG;
@property (nonatomic) BOOL onWindow;
@property (nonatomic) BOOL isShow;
@property (nonatomic) BOOL willHide;

@property (nonatomic) UIInterfaceOrientation oldOrientation;

@end

@implementation CLHUD

- (void)dealloc
{
    CLRELEASE(_window);
    CLRELEASE(_mainSuperView);
    
    CLRELEASE(_mainView);
    CLRELEASE(_activityView);
    CLRELEASE(_textLabel);
    CLRELEASE(_imageView);
    
    CLRELEASE(_oldText);
    CLRELEASE(_oldImageName);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelStatusBar + 1;
        window.backgroundColor = [UIColor clearColor];
        window.userInteractionEnabled = NO;
        self.window = window;
        [window release];
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 6.0;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = HUD_BACKGROUND_COLOR;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [imageView addObserver:self forKeyPath:@"size" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [imageView addObserver:self forKeyPath:@"width" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [imageView addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.mainView = imageView;
        [imageView release];
        
        if (_succeedImageName.length == 0) {
            _succeedImageName = [[NSString alloc] initWithString:HUD_IMAGE_SUCCESS];
        }
        
        if (_failImageName.length == 0) {
            _failImageName = [[NSString alloc] initWithString:HUD_IMAGE_ERROR];
        }
        
        if (_backgroundImage) {
            self.mainView.image = _backgroundImage;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
	if (self.showBG) {
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}else
        CGContextClearRect(context, self.bounds);
}

#pragma mark - Register HUD
+ (void)registerSucceedImage:(NSString *)succeedName failImage:(NSString *)failName
{
    if (_succeedImageName)
        CLRELEASE(_succeedImageName);
    
    _succeedImageName = [[NSString alloc] initWithString:succeedName];
    
    if (_failImageName)
        CLRELEASE(_failImageName);
    
    _failImageName = [[NSString alloc] initWithString:succeedName];
}

+ (void)registerBackgroundImage:(UIImage *)image
{
    if (_backgroundImage)
        CLRELEASE(_backgroundImage);
    
    _backgroundImage = image;
}

+ (void)registerActivityView:(UIView *)view
{
    if (_activityView)
        CLRELEASE(_activityView);
    _activityView = [view retain];
}

+ (void)registerLabel:(UILabel *)label
{
    if (_registerLabel)
        CLRELEASE(_registerLabel);
    
    _registerLabel = [label retain];
}

+ (void)registerFont:(UIFont *)font textColor:(UIColor *)textColor shadowColor:(UIColor *)shadowColor
{
    if (_font)
        CLRELEASE(_font);
    _font = font;
    
    if (_textColor)
        CLRELEASE(_textColor);
    _textColor = textColor;
    
    if (_shadowColor)
        CLRELEASE(_shadowColor);
    _shadowColor = shadowColor;
}

+ (void)registerAnimation:(CLHUDAnimation)animation
{
    _animation = animation;
}

#pragma mark - Singleton

+ (CLHUD *)shareHUD
{
    static CLHUD *hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[CLHUD alloc] initWithFrame:CGRectZero];
        hud.onWindow = YES;
        hud.frame = hud.window.bounds;
        hud.mainSuperView = hud.window;
        hud.tag = 0xABAB;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidChangeStatusBarOrientationNotification object:@"need"];
    });
    
    return hud;
}

+ (CLHUD *)newHUD
{
    CLHUD *hud = [[CLHUD alloc] initWithFrame:CGRectZero];
    hud.onWindow = NO;
    hud.tag = 0xCDCD;
    
    return hud;
}

+ (CLHUD *)swtichHUDForView:(UIView *)view
{
    if (!view || [view isKindOfClass:[UIWindow class]])
        return [CLHUD shareHUD];
    
    if ([view.hud isKindOfClass:[CLHUD class]])
        return view.hud;
    else {
        CLHUD *hud = [CLHUD newHUD];
        hud.frame = view.bounds;
        hud.mainSuperView = view;
        view.hud = hud;
        [hud release];
        
        return view.hud;
    }
}

- (void)orientationRotate:(NSNotification *)notification
{
    if (self.onWindow) {
        CGFloat rotate;
		
        if (CLStatusIsPortrait)		rotate = 0.0;
        if (CLStatusIsUpsideDown)	rotate = M_PI;
        if (CLStatusIsLeft)		    rotate = - M_PI_2;
        if (CLStatusIsRight)		rotate = + M_PI_2;
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        if (CLStatusIsVertical)
            self.window.bounds = screenRect;
        else
            self.window.bounds = CGRectMake(0, 0, screenRect.size.height, screenRect.size.width);
        
        if ([notification.object isKindOfClass:[NSString class]] && [notification.object isEqualToString:@"need"])
            self.frame = self.window.bounds;
        
        self.window.transform = CGAffineTransformMakeRotation(rotate);
    }
}

#pragma mark - Create Control
- (CGPoint)viewCenter
{
    CGRect  screenRect  = [UIScreen mainScreen].bounds;
    CGFloat screenCenterX = screenRect.size.width*0.5;
    CGFloat screenCenterY = screenRect.size.height*0.5;
    
    if (self.onWindow || (self.showBG && DEVICE_ISIOS7)) {
        if (CLStatusIsVertical)
            return CGPointMake(screenCenterX, screenCenterY);
        else
            return CGPointMake(screenCenterY, screenCenterX);
    }
    
    if (!CGRectEqualToRect(self.mainSuperView.bounds, self.mainView.controller.view.bounds)) {
        return self.mainSuperView.centerBounds;
    }
    
    UINavigationController *navController = nil;
    if ([self.mainView.controller isKindOfClass:[UINavigationController class]])
        navController = (UINavigationController *)self.controller;
    else if (self.mainView.controller.navigationController)
        navController = self.mainView.controller.navigationController;
    
    BOOL navBarHidden = navController ? navController.navigationBarHidden : YES;
    BOOL navBarTranslucent = navController.navigationBar.translucent;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    CGFloat centerX = self.centerX;
    CGFloat screenY = self.centerY;
    
    if (DEVICE_ISIOS7 && (navBarTranslucent || navBarHidden)) {
        return CGPointMake(centerX, screenY);
    }else {
        if (navBarHidden && !statusBarHidden) {
            return CGPointMake(centerX, screenY - 20);
        }else if (!navBarHidden && statusBarHidden) {
            return CGPointMake(centerX, screenY - CLTopBarHeight);
        }else if (!navBarHidden && !statusBarHidden) {
            return CGPointMake(centerX, screenY - CLTopBarHeight);
        }
    }
    
    return CGPointMake(centerX, screenY);
}

- (void)activityViewWithStyle:(UIActivityIndicatorViewStyle)style
{
    if (self.activityView)
        return;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    view.hidesWhenStopped = YES;
    [view startAnimating];
    self.activityView = view;
    [view release];
}

- (void)setupTextLabel:(UIFont *)font
{
    if (self.textLabel)
        return;
    
    if (_registerLabel) {
        self.textLabel = _registerLabel;
        return;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.textLabel = label;
    [label release];
}

- (void)setupImageView
{
    if (self.imageView)
        return;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    self.imageView = imgView;
    [imgView release];
}

#pragma mark - ActivityView
//=============On Window
+ (void)showActivityView
{
    [self showActivityViewWithText:nil];
}

+ (void)showActivityViewNOTouch
{
    [self showActivityViewNOTouchWithText:nil];
}

+ (void)showActivityViewWithBackView
{
    [self showActivityViewWithBackViewWithText:nil];
}

+ (void)showActivityViewWithText:(NSString *)text
{
    [self showActivityViewInView:nil canTouch:YES showBG:NO withText:text];
}

+ (void)showActivityViewNOTouchWithText:(NSString *)text
{
    [self showActivityViewInView:nil canTouch:NO showBG:NO withText:text];
}

+ (void)showActivityViewWithBackViewWithText:(NSString *)text
{
    [self showActivityViewInView:nil canTouch:NO showBG:YES withText:text];
}

//=============On View
+ (void)showActivityViewInView:(UIView *)view
{
    [self showActivityViewInView:view withText:nil];
}

+ (void)showActivityViewNOTouchInView:(UIView *)view
{
    [self showActivityViewNOTouchInView:view withText:nil];
}

+ (void)showActivityViewWithBackViewInView:(UIView *)view
{
    [self showActivityViewWithBackViewInView:view withText:nil];
}

+ (void)showActivityViewInView:(UIView *)view withText:(NSString *)text
{
    [self showActivityViewInView:view canTouch:YES showBG:NO withText:text];
}

+ (void)showActivityViewNOTouchInView:(UIView *)view withText:(NSString *)text
{
    [self showActivityViewInView:view canTouch:NO showBG:NO withText:text];
}

+ (void)showActivityViewWithBackViewInView:(UIView *)view withText:(NSString *)text
{
    [self showActivityViewInView:view canTouch:NO showBG:YES withText:text];
}

+ (void)showActivityViewInView:(UIView *)view canTouch:(BOOL)touch showBG:(BOOL)show withText:(NSString *)text
{
    CLHUD *hud = [CLHUD swtichHUDForView:view];
    if (hud.isShow)
        return;
    
    if(hud.onWindow){
        if(!hud.window.isKeyWindow)
            [hud.window makeKeyAndVisible];
        hud.window.hidden = NO;
    }
    
    hud.mainSuperView = view ? view : hud.window;
    [hud.mainSuperView addSubview:hud.mainView];
    
    [hud.mainView removeAllSubviews];
    hud.showBG = show;
    if (show)
        hud.window.userInteractionEnabled = YES;
    else
        hud.window.userInteractionEnabled = !touch;
    
    [hud setNeedsDisplay];
    
    //Activity
    [hud activityViewWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [hud.mainView addSubview:hud.activityView];
    
    //Label
    if (text.length > 0) {
        [hud setupTextLabel:ActivityFont];
        hud.textLabel.text = text;
        hud.textLabel.size = [text sizeWithFont:hud.textLabel.font boundingRect:CGSizeMake(MainViewMaxWith-20, MainViewMaxHeight - hud.activityView.height-30)];
    }else {
        hud.textLabel.text = nil;
        hud.textLabel.frame = CGRectZero;
    }
    
    [hud.mainView addSubview:hud.textLabel];
    
    
    CGFloat activityWidth = hud.activityView.width;
    CGFloat labelWidth = hud.textLabel.width;
    
    CGFloat width = (activityWidth > labelWidth ? activityWidth : labelWidth) + InnerMargins*2;
    CGFloat height = hud.activityView.height + hud.textLabel.height + InnerMargins*(text.length > 0 ? 3 : 2);
    if (width > MainViewMinWith || height > MainViewMinWith) {
        hud.mainView.width = width;
        hud.mainView.height = height;
        hud.activityView.minY = InnerMargins;
        hud.textLabel.minY = hud.activityView.maxY + InnerMargins;
        hud.activityView.centerX = width*0.5;
        hud.textLabel.centerX = width*0.5;
    }else {
        hud.mainView.width = MainViewMinWith;
        hud.mainView.height = MainViewMinWith;
        hud.activityView.minY = (MainViewMinWith - hud.activityView.height - hud.textLabel.height - (text.length > 0 ? InnerMargins : 0))*0.5;
        hud.textLabel.minY = hud.activityView.maxY + InnerMargins;
        hud.activityView.centerX = MainViewMinWith*0.5;
        hud.textLabel.centerX = MainViewMinWith*0.5;
    }
    
    //===========
    if (!touch || show) {
        [hud.mainSuperView addSubview:hud];
        hud.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            hud.alpha = 1.0;
        }];
    }
    
    
    //===========
    if (!hud.isShow)
        [hud showWithTime:0];
}

#pragma mark - Text Methods
+ (void)showSucceed
{
    [[CLHUD shareHUD] showText:nil withImage:_succeedImageName imagePosition:HUDImagePositionTop duration:DurationFast];
}

+ (void)showSucceedWithText:(NSString *)text
{
    [[CLHUD shareHUD] showText:text withImage:_succeedImageName imagePosition:HUDImagePositionTop duration:DurationNormal];
}

+ (void)showFailed
{
    [[CLHUD shareHUD] showText:nil withImage:_failImageName imagePosition:HUDImagePositionTop duration:DurationFast];
}

+ (void)showFailedWithText:(NSString *)text
{
    [[CLHUD shareHUD] showText:text withImage:_failImageName imagePosition:HUDImagePositionTop duration:DurationNormal];
}

+ (void)showText:(NSString *)text
{
    [[CLHUD shareHUD] showText:text withImage:nil imagePosition:HUDImagePositionTop duration:DurationNormal];
}

+ (void)showImage:(NSString *)imageName
{
    [[CLHUD shareHUD] showText:nil withImage:imageName imagePosition:HUDImagePositionTop duration:DurationNormal];
}

+ (void)showText:(NSString *)text withImage:(NSString *)imageName imagePosition:(CLHUDImagePosition)position duration:(NSInteger)duration
{
    [[CLHUD shareHUD] showText:text withImage:imageName imagePosition:position duration:duration];
}

//=========== Instance Methods
- (void)showSucceed
{
    [self showText:nil withImage:_succeedImageName imagePosition:HUDImagePositionTop duration:DurationFast];
}

- (void)showSucceedWithText:(NSString *)text
{
    [self showText:text withImage:_succeedImageName imagePosition:HUDImagePositionTop duration:DurationNormal];
}

- (void)showFailed
{
    [self showText:nil withImage:_failImageName imagePosition:HUDImagePositionTop duration:DurationFast];
}

- (void)showFailedWithText:(NSString *)text
{
    [self showText:text withImage:_failImageName imagePosition:HUDImagePositionTop duration:DurationNormal];
}

- (void)showText:(NSString *)text
{
    [self showText:text withImage:nil imagePosition:HUDImagePositionTop duration:DurationNormal];
}

- (void)showImage:(NSString *)imageName
{
    [self showText:nil withImage:imageName imagePosition:HUDImagePositionTop duration:DurationNormal];
}

- (void)showText:(NSString *)text withImage:(NSString *)imageName imagePosition:(CLHUDImagePosition)position duration:(NSInteger)duration
{
    if (([self.oldText isEqualToString:text] || self.oldText == text) &&
        ([self.oldImageName isEqualToString:imageName] || self.oldImageName == imageName)) {
        return;
    }
    else {
        self.oldText = text;
        self.oldImageName = imageName;
        self.willHide = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimation:) object:[NSNumber numberWithBool:YES]];
    }
    
    if(self.onWindow){
        if(!self.window.isKeyWindow)
            [self.window makeKeyAndVisible];
        self.window.hidden = NO;
    }
    
    [self.mainView removeAllSubviews];
    
    if (!self.isShow) {
        [self.window addSubview:self.mainView];
    }
    
    BOOL haveText = NO;
    BOOL haveImage = NO;
    
    if (text.length > 0) {
        haveText = YES;
        
        [self setupTextLabel:ActivityFont];
        self.textLabel.text = text;
        self.textLabel.size = [text sizeWithFont:self.textLabel.font boundingRect:CGSizeMake(MainViewMaxWith-20, MainViewMaxHeight - self.activityView.height-30)];
        
        [self.mainView addSubview:self.textLabel];
    }
    
    if (imageName.length > 0) {
        haveImage = YES;
        
        [self setupImageView];
        UIImage *image = [UIImage imageNamed:imageName];
        self.imageView.size = CGSizeMake(image.size.width, image.size.height);
        self.imageView.image = image;
        
        [self.mainView addSubview:self.imageView];
    }else {
        self.imageView.image = nil;
        self.imageView.frame = CGRectZero;
    }
    
    if (haveText && !haveImage) {
        self.textLabel.minX = InnerMargins;
        self.textLabel.minY = InnerMargins;
        self.mainView.size = CGSizeMake(self.textLabel.width + InnerMargins*2, self.textLabel.height + InnerMargins*2);
    }else if (!haveText && haveImage) {
        if (self.imageView.width > MainViewMinWith || self.imageView.height > MainViewMinWith) {
            self.mainView.size = self.imageView.size;
            self.imageView.origin = CGPointMake(0, 0);
        }else {
            self.mainView.size = CGSizeMake(MainViewMinWith, MainViewMinWith);
            self.imageView.center = CGPointMake(MainViewMinWith*0.5, MainViewMinWith*0.5);
        }
    }else {
        switch (position) {
            case HUDImagePositionTop:
            case HUDImagePositionBottom:
            {
                CGFloat width = self.imageView.width > self.textLabel.width ? self.imageView.width : self.textLabel.width + InnerMargins*2;
                CGFloat height = self.imageView.height + self.textLabel.height + InnerMargins*3;
                
                if (width > MainViewMinWith || height > MainViewMinWith) {
                    self.mainView.width = width;
                    self.mainView.height = height;
                }else {
                    self.mainView.width = MainViewMinWith;
                    self.mainView.height = MainViewMinWith;
                }
                
                CGFloat topY = (self.mainView.height - self.imageView.height - self.textLabel.height - InnerMargins)*0.5;
                if (position == HUDImagePositionTop) {
                    self.imageView.minY = topY;
                    self.textLabel.minY = self.imageView.maxY + InnerMargins;
                }else {
                    self.textLabel.minY = topY;
                    self.imageView.minY = self.textLabel.maxY + InnerMargins;
                }
                
                self.imageView.centerX = self.mainView.width*0.5;
                self.textLabel.centerX = self.imageView.centerX;
            }
                break;
            case HUDImagePositionLeft:
            case HUDImagePositionRight:
            {
                if (self.imageView.height > self.textLabel.height) {
                    self.imageView.minY = InnerMargins;
                    self.mainView.height = self.imageView.height + InnerMargins*2;
                    self.textLabel.minY = (self.mainView.height - self.textLabel.height)*0.5;
                }else {
                    self.textLabel.minY = InnerMargins;
                    self.mainView.height = self.textLabel.height + InnerMargins*2;
                    self.imageView.minY = (self.mainView.height - self.imageView.height)*0.5;
                }
                
                self.mainView.width = self.imageView.width + self.textLabel.width + InnerMargins*3;
                
                if (position == HUDImagePositionLeft) {
                    self.imageView.minX = InnerMargins;
                    self.textLabel.minX = self.imageView.maxX + InnerMargins;
                }else {
                    self.textLabel.minX = InnerMargins;
                    self.imageView.minX = self.textLabel.maxX + InnerMargins;
                }
            }
                break;
            default:
                break;
        }
    }
    
    if (!self.isShow) {
        [self showWithTime:duration];
    }
    else {
        if (duration != 0 && !self.willHide) {
            self.willHide = YES;
            [self performSelector:@selector(hideAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

#pragma mark - Animations
- (void)showWithTime:(CGFloat)duration
{
    if (!self.isShow) {
        self.isShow = YES;
        
        if (_animation == HUDAnimationSacleSmall || _animation == HUDAnimationSacleSmallShake) {
            self.mainView.transform = CGAffineTransformMakeScale(2.0, 2.0);
            self.mainView.alpha = 0;
        }else if (_animation == HUDAnimationSacleBig || _animation == HUDAnimationSacleBigShake) {
            self.mainView.transform = CGAffineTransformMakeScale(0, 0);
            self.mainView.alpha = 0;
        }else if (_animation == HUDAnimationFromLeftToRight || _animation == HUDAnimationFromLeftBackLeft) {
            self.mainView.maxX = 0;
        }else if (_animation == HUDAnimationFromTopToBottom || _animation == HUDAnimationFromTopBackTop) {
            self.mainView.maxY = 0;
        }
        
        switch (_animation) {
            case 0:
                [self showAnimationScaleNormal:duration];
                break;
            case 1:
                [self showAnimationSacleShake:duration toSmall:YES];
                break;
            case 2:
                [self showAnimationScaleNormal:duration];
                break;
            case 3:
                [self showAnimationSacleShake:duration toSmall:NO];
                break;
            case 4:
            case 5:
                [self showAnimationFromLeft:duration];
                break;
            case 6:
            case 7:
                [self showAnimationFromTop:duration];
                break;
            default:
                break;
        }
    }
}

- (void)hideAnimation:(BOOL)animation
{
    if (!animation) {
        [self finishHide];
        return;
    }
    
    switch (_animation) {
        case 0:
        case 1:
            [self hideAnimationScaleSmall];
            break;
        case 2:
        case 3:
            [self hideAnimationSacleBig];
            break;
        case 4:
            [self hideAnimationToRight:YES];
            break;
        case 5:
            [self hideAnimationToRight:NO];
            break;
        case 6:
            [self hideAnimationToBottom:YES];
            break;
        case 7:
            [self hideAnimationToBottom:NO];
            break;
        default:
            break;
    }
}

+ (void)hide
{
    [[CLHUD shareHUD] hideAnimation:YES];
}

#pragma mark - Show Animations
- (void)showAnimationScaleNormal:(CGFloat)duration
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.mainView.alpha = 1;
    }completion:^(BOOL finish){
        if (duration != 0 && !self.willHide) {
            self.willHide = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainView setNeedsDisplay];
                [self performSelector:@selector(hideAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            });
            
        }
    }];
}

- (void)showAnimationSacleShake:(CGFloat)duration toSmall:(BOOL)small
{
    [UIView animateWithDuration:0.1 animations:^{
        float scale = small ? 0.7 : 1.4;
        self.mainView.transform = CGAffineTransformMakeScale(scale, scale);
        self.mainView.alpha = 0.6;
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1 animations:^{
            float scale = small ? 1.4 : 0.7;
            self.mainView.transform = CGAffineTransformMakeScale(scale, scale);
            self.mainView.alpha = 0.8;
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1 animations:^{
                self.mainView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.mainView.alpha = 1.0;
            }completion:^(BOOL finish){
                if (duration != 0 && !self.willHide) {
                    self.willHide = YES;
                    [self performSelector:@selector(hideAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }
            }];
        }];
    }];
}

- (void)showAnimationFromLeft:(CGFloat)duration
{
    CGFloat centerX = [self viewCenter].x;
    [UIView animateWithDuration:0.15 animations:^{
        self.mainView.centerX = centerX + 40;
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1 animations:^{
            self.mainView.centerX = centerX - 40;
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1 animations:^{
                self.mainView.centerX = centerX;
            }completion:^(BOOL finish){
                if (duration != 0 && !self.willHide) {
                    self.willHide = YES;
                    [self performSelector:@selector(hideAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }
            }];
        }];
    }];
}

- (void)showAnimationFromTop:(CGFloat)duration
{
    CGFloat centerY = [self viewCenter].y;
    [UIView animateWithDuration:0.15 animations:^{
        self.mainView.centerY = centerY + 40;
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1 animations:^{
            self.mainView.centerY = centerY - 40;
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1 animations:^{
                self.mainView.centerY = centerY;
            }completion:^(BOOL finish){
                if (duration != 0 && !self.willHide) {
                    self.willHide = YES;
                    [self performSelector:@selector(hideAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }
            }];
        }];
    }];
}

- (void)startOriginX
{
    
}

#pragma mark - Hide Animations
- (void)hideAnimationScaleSmall
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(0, 0);
        self.mainView.alpha = 0;
        self.alpha = 0;
    }completion:^(BOOL finish){
        [self finishHide];
    }];
}

- (void)hideAnimationSacleBig
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        self.mainView.alpha = 0;
        self.alpha = 0;
    }completion:^(BOOL finish){
        [self finishHide];
    }];
}

- (void)hideAnimationToRight:(BOOL)right
{
    CGFloat centerX = [self viewCenter].x;
    [UIView animateWithDuration:0.15 animations:^{
        self.mainView.centerX = right ? (centerX - 40) : (centerX + 40);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1 animations:^{
            if (right)
                self.mainView.minX = self.width;
            else
                self.mainView.maxX = 0;
        }completion:^(BOOL finish){
            [self finishHide];
        }];
    }];
}

- (void)hideAnimationToBottom:(BOOL)bottom
{
    CGFloat centerY = [self viewCenter].y;
    [UIView animateWithDuration:0.15 animations:^{
        self.mainView.centerY = bottom ? centerY - 40 : centerY + 40;
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1 animations:^{
            if (bottom)
                self.mainView.minY= self.height;
            else
                self.mainView.maxY = 0;
        }completion:^(BOOL finish){
            [self finishHide];
        }];
    }];
}

- (void)finishHide
{
    if (self.onWindow) {
        [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
        self.window.hidden = YES;
    }
    
    if (!self.onWindow && self.tag == 0xCDCD) {
        if ([self.mainView observationInfo]) {
            [self.mainView removeObserver:self forKeyPath:@"size"];
            [self.mainView removeObserver:self forKeyPath:@"width"];
            [self.mainView removeObserver:self forKeyPath:@"height"];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        self.mainSuperView.hud = nil;
    }
    
    self.mainView.transform = CGAffineTransformMakeScale(1, 1);
    self.mainView.alpha = 1;
    [self.mainView removeFromSuperview];
    
    self.alpha = 1;
    self.isShow = NO;
    self.willHide = NO;
    self.oldText = nil;
    self.oldImageName = nil;
    [self removeFromSuperview];
}

#pragma mark - Methods
+ (BOOL)isShow
{
    return [CLHUD shareHUD].isShow;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"width"] || [keyPath isEqualToString:@"height"] || [keyPath isEqualToString:@"size"]) {
        self.mainView.center = [self viewCenter];
    }
}


@end

static char const * const hudChar = "hud";

@implementation UIView (HUD)

- (void)dealloc
{
    if (self.hud) {
        self.hud = nil;
        [super dealloc];
    }
}

- (void)setHud:(CLHUD *)hud
{
    objc_setAssociatedObject(self, hudChar, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLHUD *)hud
{
    return objc_getAssociatedObject(self, hudChar);
}

@end
