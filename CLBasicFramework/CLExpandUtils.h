//
//  CLExpandUtils.h
//  CLBasicFramework
//
//  Created by 崔志伟 on 13-12-24.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - UIColor Expand
///---------------------------------------------------------------------------------------
/// @name Class Methods
///---------------------------------------------------------------------------------------

@interface UIColor (Expand)
/**
 *	@brief	转换6进制颜色.
 *
 *	@param 	string 	6进制颜色字符串.
 *
 *	@return	返回UIColor.
 */
+ (UIColor *)colorWithHexString:(NSString *)string;


@end

#pragma mark - UIImage Expand
@interface UIImage (Expand)
///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------

/**
 *	@brief	图片宽.
 */
@property (nonatomic) CGFloat width;

/**
 *	@brief	图片高.
 */
@property (nonatomic) CGFloat height;

///---------------------------------------------------------------------------------------
/// @name Class Methods
///---------------------------------------------------------------------------------------

/**
 *	@brief	根据颜色,指定Rect生成图片.
 *
 *	@param 	color 	颜色.
 *	@param 	rect 	大小.
 *
 *	@return	返回生成的图片.
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;


@end

@interface UIButton (Expand)
///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------

/**
 *	@brief	扩展的UIButton的NSIndexPath属性.
 */
@property (nonatomic, retain) NSIndexPath *indexPath;


@end
