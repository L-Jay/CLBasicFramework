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
 *	@brief	是否显示ActivityView,默认为NO,显示.
 */
@property (nonatomic) BOOL dontShowActivityView;

/**
 *	@brief	是否只在wifi下下载图片,默认为NO.
 */
@property (nonatomic) BOOL onlyWIFI;

/**
 *	@brief	图片下载完成是否立即替换，默认为NO,替换.
 */
@property (nonatomic) BOOL dontReplaceImmediately;

/**
 *	@brief	是否使用下载原图(不使用压缩存储),默认为NO,使用.
 */
@property (nonatomic) BOOL dontUseOriginalImage;


/**
 *	@brief	ActivityView的Style.
 */
@property (nonatomic) UIActivityIndicatorViewStyle activityStyle;

/**
 *	@brief	图片下载完成后执行动画,详见CLUIViewUtils.h头文件.
 */
@property (nonatomic) CLViewAnimation animation;


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
/// @name Cache Methods
///---------------------------------------------------------------------------------------

/**
 *	@brief	缓存图片.
 *
 *	@param 	image 	图片.
 */
+ (void)cacheImage:(UIImage *)image withName:(NSString *)name;

/**
 *	@brief	缓存图片.
 *
 *	@param 	imageData 	图片数据.
 */
+ (void)cacheImageData:(NSData *)imageData withName:(NSString *)name;

/**
 *	@brief	清除图片缓存.
 */
+ (void)removeImageCache;


@end
