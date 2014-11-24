//
//  CLUIViewUtils.h
//  CLBasicFramework
//
//  Created by 崔志伟 on 13-11-29.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLViewAnimation) {
    CLViewAnimationFade = 0,            //淡出
    CLViewAnimationRipple,              //波纹
    CLViewAnimationSuckEffect,          //吸收
    CLViewAnimationFlipFromLeft,        //水平翻转,从左向右
    CLViewAnimationFlipFromRight,       //水平翻转,从右向左
    CLViewAnimationFlipFromBottm,       //竖直翻转,从下向上
    CLViewAnimationFlipFromTop,         //竖直翻转,从上向下
    CLViewAnimationPageCurlFromLeft,    //从左翻页
    CLViewAnimationPageCurlFromRight,   //从右翻页
    CLViewAnimationPageCurlFromBottom,  //从下翻页
    CLViewAnimationPageCurlFromTop,     //从上翻页
    CLViewAnimationPageUnCurlFromLeft,  //从左反翻页
    CLViewAnimationPageUnCurlFromRight, //从右反翻页
    CLViewAnimationPageUnCurlFromBottom,//从下反翻页
    CLViewAnimationPageUnCurlFromTop,   //从上反翻页
    CLViewAnimationMoveInFromLeft,      //从左覆盖
    CLViewAnimationMoveInFromRight,     //从右覆盖
    CLViewAnimationMoveInFromBottom,    //从下覆盖
    CLViewAnimationMoveInFromTop,       //从上覆盖
    CLViewAnimationPushFromLeft,        //从左推出
    CLViewAnimationPushFromRight,       //从右推出
    CLViewAnimationPushFromBottom,      //从下推出
    CLViewAnimationPushFromTop,         //从上推出
    CLViewAnimationRevealFromLeft,      //从左移开
    CLViewAnimationRevealFromRight,     //从右移开
    CLViewAnimationRevealFromBottom,    //从下移开
    CLViewAnimationRevealFromTop,       //从上移开
    CLViewAnimationCubeFromLeft,        //从左旋转
    CLViewAnimationCubeFromRight,       //从右旋转
    CLViewAnimationCubeFromBottom,      //从下旋转
    CLViewAnimationCubeFromTop,         //从上旋转
};

@interface UIView(Util)

///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------

#pragma mark - Coordinate
/**
 *	@brief	View的原点X值.
 */
@property (nonatomic) CGFloat minX;

/**
 *	@brief	View的原点Y值.
 */
@property (nonatomic) CGFloat minY;

/**
 *	@brief	View的最大X值.原点X+width.
 */
@property (nonatomic) CGFloat maxX;

/**
 *	@brief	View的最大Y值.原点X+height.
 */
@property (nonatomic) CGFloat maxY;

/**
 *	@brief	View的宽.
 */
@property (nonatomic) CGFloat width;

/**
 *	@brief	View的高.
 */
@property (nonatomic) CGFloat height;

/**
 *	@brief	View的中心点X值.
 */
@property (nonatomic) CGFloat centerX;


/**
 *	@brief	View的中心点Y值.
 */
@property (nonatomic) CGFloat centerY;

/**
 *	@brief	View的原点.
 */
@property (nonatomic) CGPoint origin;

/**
 *	@brief	View的Size.
 */
@property (nonatomic) CGSize size;

/**
 *	@brief	View的中心点.
 */
@property (nonatomic) CGPoint centerBounds;

/**
 *	@brief	View的MinX移动到点.
 */
@property (nonatomic) CGFloat moveMinX;

/**
 *	@brief	View的MinY移动到点.
 */
@property (nonatomic) CGFloat moveMinY;

/**
 *	@brief	View的MaxX移动到点.
 */
@property (nonatomic) CGFloat moveMaxX;

/**
 *	@brief	View的MaxY移动到点.
 */
@property (nonatomic) CGFloat moveMaxY;

#pragma mark - Property Extend
/**
 *	@brief	View所属的ViewController.
 */
@property (nonatomic, assign, readonly) UIViewController *controller;

#pragma mark - Instance Methods
///---------------------------------------------------------------------------------------
/// @name Remove View
///---------------------------------------------------------------------------------------

/**
 *	@brief	删除所有子视图.
 */
- (void)removeAllSubviews;

/**
 *	@brief	删除所有属于class类的子视图.
 *
 *	@param 	class 	Class.
 */
- (void)removeAllSubviewsWith:(Class)class;


#pragma mark - Subview Methods
///---------------------------------------------------------------------------------------
/// @name Get View
///---------------------------------------------------------------------------------------

/**
 *	@brief	获取所属于class类的子视图.
 *
 *	@param 	class 	Class.
 *
 *	@return	返回View,未找到返回nil.
 */
- (UIView *)subviewWithClass:(Class)class;

/**
 *	@brief	获取所属于class类的父视图.
 *
 *	@param 	class 	Class.
 *
 *	@return	返回View,未找到返回nil.
 */
- (UIView *)superviewWithClass:(Class)class;

/**
 *	@brief	获取在index位置的子视图.
 *
 *	@param 	index 	int类型,视图所在位置.
 *
 *	@return	返回View,未找到返回nil.
 */
- (UIView *)subviewAtIndex:(NSInteger)index;


#pragma mark - Animations
///---------------------------------------------------------------------------------------
/// @name Animations
///---------------------------------------------------------------------------------------

/**
 *	@brief	View执行动画.
 *
 *	@param 	animation 	动画类型,详见头文件.
 */
- (void)startAnimation:(CLViewAnimation)animation;


@end
