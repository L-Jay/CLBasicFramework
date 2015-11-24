//
//  CLHUD.h
//  CLBasicFramework
//
//  Created by L on 13-12-11.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLHUDStyle) {
    CLHUDStyleBlack = 0,
    CLHUDStyleIOS7  = 1,
};

typedef NS_ENUM(NSInteger, CLHUDAnimation) {
    CLHUDAnimationSacleSmall = 0,     //从大到小
    CLHUDAnimationSacleSmallShake,    //从大到小并抖动
    CLHUDAnimationSacleBig,           //从小到大
    CLHUDAnimationSacleBigShake,      //从小到大并抖动
    CLHUDAnimationFromLeftToRight,    //从左出现往右消失
    CLHUDAnimationFromLeftBackLeft,   //从左出现往左消失
    CLHUDAnimationFromTopToBottom,    //从上出现往下消失
    CLHUDAnimationFromTopBackTop,     //从上出现往上消失
};

typedef NS_ENUM(NSInteger, CLHUDImagePosition) {
    CLHUDImagePositionTop = 0,  //图片在顶部
    CLHUDImagePositionBottom,   //图片在底部
    CLHUDImagePositionLeft,     //图片在左边
    CLHUDImagePositionRight,    //图片在右边
};

@interface CLHUD : UIView

///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------
@property (nonatomic, readonly) BOOL isShow;

#pragma mark - Register HUD
///---------------------------------------------------------------------------------------
/// @name Register Methods
///---------------------------------------------------------------------------------------

/**
 *	@brief	注册正确、错误状态图片名称.
 *
 *	@param 	succeedName 	成功状态图片名称.
 *	@param 	failName 	错误状态图片名称.
 */
+ (void)registerSucceedImage:(NSString *)succeedName failImage:(NSString *)failName;


/**
 *	@brief	注册弹框背景图片.
 *
 *	@param 	image 	背景图,UIImage型.
 */
+ (void)registerBackgroundImage:(UIImage *)image;

/**
 *	@brief	注册风火轮视图.
 *
 *	@param 	view 	自定义风火轮视图.
 */
+ (void)registerActivityView:(UIView *)view;


/**
 *	@brief	注册文本视图.
 *
 *	@param 	label 	自定义文本视图.
 */
+ (void)registerLabel:(UILabel *)label;


/**
 *	@brief	注册字体属性.
 *
 *	@param 	font 	字体.
 *	@param 	textColor 	字体颜色.
 *	@param 	shadowColor 	字体投影.
 */
+ (void)registerFont:(UIFont *)font textColor:(UIColor *)textColor shadowColor:(UIColor *)shadowColor;


/**
 *	@brief	注册弹框动画.
 *
 *	@param 	animation 	弹框动画,动画类型详见CLHUD头文件.
 */
+ (void)registerAnimation:(CLHUDAnimation)animation;

#pragma mark - Create Methods
/**
 *	@brief	初始化HUD.
 *
 *	@param 	view 	在view上显示hud.
 *
 *	@return	返回一个hud实例.
 */
+ (CLHUD *)hudForView:(UIView *)view;


#pragma mark - ActivityView Methods
///---------------------------------------------------------------------------------------
/// @name Show ActivityView On Window
///---------------------------------------------------------------------------------------

/**
 *	@brief	弹出风火轮.
 */
+ (void)showActivityView;

/**
 *	@brief	弹出风火轮的同时视图不能点击.
 */
+ (void)showActivityViewNOTouch;

/**
 *	@brief	弹出风火轮的同时有背景.
 */
+ (void)showActivityViewWithBackView;

/**
 *	@brief	弹出带文本的风火轮.
 *
 *	@param 	text 	文本内容.
 */
+ (void)showActivityViewWithText:(NSString *)text;

/**
 *	@brief	弹出带文本的风火轮的同时视图不能点击.
 *
 *	@param 	text 	文本内容.
 */
+ (void)showActivityViewNOTouchWithText:(NSString *)text;

/**
 *	@brief	弹出带文本的风火轮的同时有背景.
 *
 *	@param 	text 	文本内容.
 */
+ (void)showActivityViewWithBackViewWithText:(NSString *)text;



///---------------------------------------------------------------------------------------
/// @name Show ActivityView On View
///---------------------------------------------------------------------------------------

/**
 *	@brief	在指定View弹出风火轮.
 *
 *	@param 	view 	要弹出HUD的View.
 *
 *	@discussion	如果视图包含UINavigationController、UITabbarController,view请根据根视图做相应的调整.
 */
+ (void)showActivityViewInView:(UIView *)view;

/**
 *	@brief	在指定View弹出风火轮的同时不能点击.
 *
 *	@param 	view 	要弹出HUD的View.
 *
 *	@discussion	如果视图包含UINavigationController、UITabbarController,view请根据根视图做相应的调整.
 */
+ (void)showActivityViewNOTouchInView:(UIView *)view;

/**
 *	@brief	在指定View弹出风火轮的同时有背景.
 *
 *	@param 	view 	要弹出HUD的View.
 *
 *	@discussion	如果视图包含UINavigationController、UITabbarController,view请根据根视图做相应的调整.
 */
+ (void)showActivityViewWithBackViewInView:(UIView *)view;

/**
 *	@brief	在指定View弹出带文本的风火轮.
 *
 *	@param 	view 	要弹出HUD的View.
 *	@param 	text 	文本内容.
 *
 *	@discussion	如果视图包含UINavigationController、UITabbarController,view请根据根视图做相应的调整.
 */
+ (void)showActivityViewInView:(UIView *)view withText:(NSString *)text;

/**
 *	@brief	在指定View弹出带文本的风火轮的同时不能点击.
 *
 *	@param 	view 	要弹出HUD的View.
 *	@param 	text 	文本内容.
 *
 *	@discussion	如果视图包含UINavigationController、UITabbarController,view请根据根视图做相应的调整.
 */
+ (void)showActivityViewNOTouchInView:(UIView *)view withText:(NSString *)text;

/**
 *	@brief	在指定View弹出带文本的风火轮的同时有背景.
 *
 *	@param 	view 	要弹出HUD的View.
 *	@param 	text 	文本内容.
 *
 *	@discussion	如果视图包含UINavigationController、UITabbarController,view请根据根视图做相应的调整.
 */
+ (void)showActivityViewWithBackViewInView:(UIView *)view withText:(NSString *)text;


#pragma mark - Text Methods
///---------------------------------------------------------------------------------------
/// @name Show Succeed And Failed On Window
///---------------------------------------------------------------------------------------

/**
 *	@brief	成功状态弹框.
 */
+ (void)showSucceed;

/**
 *	@brief	带文本的成功状态弹框.
 *
 *	@param 	text 	文本内容.
 */
+ (void)showSucceedWithText:(NSString *)text;


/**
 *	@brief	失败状态弹框.
 */
+ (void)showFailed;

/**
 *	@brief	带文本的失败状态弹框.
 *
 *	@param 	text 	文本内容.
 */
+ (void)showFailedWithText:(NSString *)text;

///---------------------------------------------------------------------------------------
/// @name Show Text And Image On View
///---------------------------------------------------------------------------------------

/**
 *	@brief	文本弹框.
 *
 *	@param 	text 	文本内容.
 */
+ (void)showText:(NSString *)text;

/**
 *	@brief	图片弹框.
 *
 *	@param 	imageName 	图片名称.
 *
 *	@discussion	视图弹窗的默认大小是100x100,如果使用图片大小宽、高都小于100的话,将显示背景框；宽、高任意一边大于100的话将只显示图片.
 */
+ (void)showImage:(NSString *)imageName;

/**
 *	@brief	带有文本和图片弹框.
 *
 *	@param 	text 	文本内容.
 *	@param 	imageName 	图片名称.
 *	@param 	position 	图片位置,详见头文件枚举类型CLHUDImagePosition.
 *	@param 	duration 	显示时长.
 *
 *	@discussion	视图弹窗的默认大小是100x100,如果使用图片大小宽、高都小于100的话,将显示背景框；宽、高任意一边大于100的话将只显示图片.
 */
+ (void)showText:(NSString *)text withImage:(NSString *)imageName imagePosition:(CLHUDImagePosition)position duration:(NSInteger)duration;

#pragma mark - Instance Methods
///---------------------------------------------------------------------------------------
/// @name Show Succeed And Failed On View
///---------------------------------------------------------------------------------------

/**
 *	@brief	成功状态弹框.
 */
- (void)showSucceed;


/**
 *	@brief	带文本的成功状态弹框.
 *
 *	@param 	text 	文本内容.
 */
- (void)showSucceedWithText:(NSString *)text;


/**
 *	@brief	失败状态弹框.
 */
- (void)showFailed;

/**
 *	@brief	带文本的失败状态弹框.
 *
 *	@param 	text 	文本内容.
 */
- (void)showFailedWithText:(NSString *)text;

///---------------------------------------------------------------------------------------
/// @name Show Text And Image On View
///---------------------------------------------------------------------------------------


/**
 *	@brief	文本弹框.
 *
 *	@param 	text 	文本内容.
 */
- (void)showText:(NSString *)text;


/**
 *	@brief	图片弹框.
 *
 *	@param 	imageName 	图片名称.
 *
 *	@discussion	视图弹窗的默认大小是100x100,如果使用图片大小宽、高都小于100的话,将显示背景框；宽、高任意一边大于100的话将只显示图片.
 */
- (void)showImage:(NSString *)imageName;


/**
 *	@brief	带有文本和图片弹框.
 *
 *	@param 	text 	文本内容.
 *	@param 	imageName 	图片名称.
 *	@param 	position 	图片位置,详见头文件枚举类型CLHUDImagePosition.
 *	@param 	duration 	显示时长.
 *
 *	@discussion	视图弹窗的默认大小是100x100,如果使用图片大小宽、高都小于100的话,将显示背景框；宽、高任意一边大于100的话将只显示图片.
 */
- (void)showText:(NSString *)text withImage:(NSString *)image imagePosition:(CLHUDImagePosition)position duration:(NSInteger)duration;


#pragma mark - Class Methods
///---------------------------------------------------------------------------------------
/// @name Class Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	是否正在显示.
 *
 *	@return	返回一个BOOL值,YES为正在显示.
 */
+ (BOOL)isShow;


#pragma mark - Hide HUD Methods
///---------------------------------------------------------------------------------------
/// @name Hide HUD Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	隐藏Window上弹出框.
 */
+ (void)hideAnimation:(BOOL)animation;

/**
 *	@brief	隐藏View上弹出框.
 *
 *	@param 	animation 	是否显示动画,YES为显示.
 *
 *	@discussion	如果hud弹出时是在view上,那隐藏需要调用view.hud隐藏.See 'UIView (HUD)' @property (nonatomic, retain) CLHUD *hud.
 */
- (void)hideAnimation:(BOOL)animation;

/**
 *	@brief	hud隐藏回调.
 */
+ (void)hideComplete:(void (^)(void))complete;

/**
 *	@brief	hud隐藏回调.
 */
- (void)hideComplete:(void (^)(void))complete;

@end

@interface UIView (HUD)
///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------


/**
 *	@brief	UIView的扩展HUD属性.
 *
 *	@discussion	HUD在View上弹出的同时,view.hud同时被赋值,hud更改效果状态必须用view.hud调用才行.
 */
@property (nonatomic, retain) CLHUD *hud;


@end
