//
//  CLBasicFramework.h
//  CLBasicFramework
//
//  Created by 崔志伟 on 14-3-4.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLNetwork.h"
#import "CLUIImageView+CLNetwork.h"
#import "CLHUD.h"
#import "CLCache.h"
#import "CLUIViewUtils.h"
#import "CLNSStringUtils.h"
#import "CLExpandUtils.h"
#import "Reachability.h"
#import "OpenUDID.h"

/** 设备版本 CGFloat型. */
#define DEVICE_VERSION DeviceSystemVersion()
/** 是否是iOS7或者更高. */
#define DEVICE_ISIOS7  (DeviceSystemVersion() >= 7)

#define CLRELEASE(exp) [exp release], exp = nil

#ifndef CLLog
#if DEBUG
#define CLLog(id, ...) NSLog((@"%s [Line %d] " id),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define CLLog(id, ...)
#endif
#endif

#define CLLogRect(view) CLLog(@"%@", NSStringFromCGRect(view.frame))
#define CLLogOrigin(view) CLLog(@"%@", NSStringFromCGPoint(view.origin))
#define CLLogSize(view) CLLog(@"%@", NSStringFromCGSize(view.size))

/**
 *	@brief	CLStatusOrientation 当前视图方向.
 */
#define CLStatusOrientation [[UIApplication sharedApplication] statusBarOrientation]

/**
 *	@brief	当前视图是不是竖屏
 *
 *	@param 	CLStatusOrientation
 *
 *	@return	返回BOOL值,是为YES.
 */
#define CLStatusIsVertical  UIInterfaceOrientationIsPortrait(CLStatusOrientation)


#define CLStatusIsPortrait   CLStatusOrientation == UIInterfaceOrientationPortrait
#define CLStatusIsUpsideDown CLStatusOrientation == UIInterfaceOrientationPortraitUpsideDown
#define CLStatusIsLeft       CLStatusOrientation == UIInterfaceOrientationLandscapeLeft
#define CLStatusIsRight      CLStatusOrientation == UIInterfaceOrientationLandscapeRight

CGFloat DeviceSystemVersion();

@interface CLBasicFramework : NSObject

///---------------------------------------------------------------------------------------
/// @name Class Methods
///---------------------------------------------------------------------------------------

/**
 *	@brief	设备的UUID
 *
 *	@return	返回设备UUID,string类型.
 */
+ (NSString *)UUID;


@end

