//
//  CLUIImageView+CLNetwork.h
//  CLBasicFramework
//
//  Created by L on 13-11-28.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUIViewUtils.h"

@interface UIImageView(CLNetWork)
///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------


/**
 *	@brief	属性imageUrl.
 *
 *	@discussion	将要获取的图片URL直接赋值到这个属性即可.
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 *	@brief	是否显示ActivityView.
 */
@property (nonatomic) BOOL showActivityView;

/**
 *	@brief	ActivityView的Style.
 */
@property (nonatomic) UIActivityIndicatorViewStyle activityStyle;

/**
 *	@brief	图片下载完成后执行动画,详见CLUIViewUtils.h头文件.
 */
@property (nonatomic) ViewAnimation animation;


///---------------------------------------------------------------------------------------
/// @name Download Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	图片下载进度.
 *	@param 	imageProgress 下载进度,float型.
 */
- (void)downloadImageProgress:(void (^)(CGFloat progress))imageProgress;

/**
 
 
 */
/**
 *	@brief	图片下载完成回调.
 *	@param 	succeed BOOL型,YES为下载图片成功.
 *
 *	@discussion	下载成功后会自动添加到缓存.
 */
- (void)downloadImageFinish:(void (^)(BOOL succeed))finish;



///---------------------------------------------------------------------------------------
/// @name Download Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	清除图片缓存.
 */
+ (void)removeImageCache;


@end
