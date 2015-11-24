//
//  CLNSStringUtils.h
//  CLBasicFramework
//
//  Created by 崔志伟 on 13-12-18.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (Util)

#pragma mark - Expand Class Methods
///---------------------------------------------------------------------------------------
/// @name 数据类型转String
///---------------------------------------------------------------------------------------

/**
 *	@brief	int型转String.
 *
 *	@param 	value 	int型参数.
 *
 *	@return	返回一个NSString字符串.
 */
+ (NSString *)intString:(int)value;

/**
 *	@brief	float型转String.
 *
 *	@param 	value 	float型参数.
 *
 *	@return	返回一个NSString字符串.
 */
+ (NSString *)floatString:(float)value;


#pragma mark - Expand Instance Methods
///---------------------------------------------------------------------------------------
/// @name MD5
///---------------------------------------------------------------------------------------

/**
 *	@brief	MD5.
 *
 *	@return	返回一个NSString字符串.
 */
- (NSString *)md5;


#pragma mark - Validate String
///---------------------------------------------------------------------------------------
/// @name 验证字符串
///---------------------------------------------------------------------------------------

/**
 *	@brief	验证手机号.
 *
 *	@return	返回一个NSString字符串.
 */
- (BOOL)validateiPhoneNum;

/**
 *	@brief	验证邮箱.
 *
 *	@return	返回一个NSString字符串.
 */
- (BOOL)validateEmail;

/**
 *	@brief	验证URL.
 *
 *	@return	返回一个NSString字符串.
 */
- (BOOL)validateURL;


/**
 *	@brief	自定义验证.
 *
 *	@param 	matchStr 	正则表达式字符串.
 *
 *	@return	返回一个BOOL值,合法返回YES.
 */
- (BOOL)validateMatchesString:(NSString *)matchStr;


#pragma mark - String Size
///---------------------------------------------------------------------------------------
/// @name String Size Methods
///---------------------------------------------------------------------------------------

/**
 *	@brief	字符串根据字体,空间占据的大小.
 *
 *	@param 	font 	字体.
 *	@param 	size 	大小.
 *
 *	@return	返回CGSize.
 */
- (CGSize)sizeWithFont:(UIFont *)font boundingRect:(CGSize)size;

/*
 */
- (NSString *)AES128EncryptWithKey:(NSString *)key;

/*
 */
- (NSString *)AES128DecryptWithKey:(NSString *)key;

/*
 */
- (NSData *)base64Encoded;

/*
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

/*
 */
- (NSString *)sha1;

/*
 */
- (NSString *)URLEncode;

@end
