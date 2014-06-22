//
//  CLCache.h
//  CLBasicFramework
//
//  Created by 崔志伟 on 13-11-28.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

/**
 * 工程中所建立的Model类,不用序列化,此类内部已经做了序列化处理.
 * 直观来讲,直接把NSArray,NSDictionary直接存入读取即可.
 */

#import <Foundation/Foundation.h>

@interface CLCache : NSObject

#pragma mark - Get Data Methods
///---------------------------------------------------------------------------------------
/// @name 读取沙盒数据方法
///---------------------------------------------------------------------------------------

/**
 *	@brief	获取存在Document的数据.
 *
 *	@param 	fileName 	文件名称.
 *
 *	@return	返回一个id类型,没有返回nil.
 */
+ (id)getDataInDocument:(NSString *)fileName;


/**
 *	@brief	获取存在Document的数据.
 *
 *	@param 	fileName 	文件名称.
 *	@param 	directoyName 	文件夹名称.
 *
 *	@return	返回一个id类型,没有返回nil.
 */
+ (id)getDataInDocument:(NSString *)fileName directoryName:(NSString *)directoyName;


/**
 *	@brief	获取存在Cache的数据.
 *
 *	@param 	fileName 	文件名称.
 *
 *	@return	返回一个id类型,没有返回nil.
 */
+ (id)getDataInCache:(NSString *)fileName;


/**
 *	@brief	获取存在Cache的数据.
 *
 *	@param 	fileName 	文件名称.
 *	@param 	directoyName 	文件夹名称.
 *
 *	@return	返回一个id类型,没有返回nil.
 */
+ (id)getDataInCache:(NSString *)fileName directoryName:(NSString *)directoyName;


#pragma mark - Write Data Methods
///---------------------------------------------------------------------------------------
/// @name 存入沙盒数据方法
///---------------------------------------------------------------------------------------

/**
 *	@brief	向Document写入数据.
 *
 *	@param 	fileName 	存入数据命名名称.
 *	@param 	data 	NSArray or NSDictionary.
 */
+ (void)writeToDocument:(NSString *)fileName withData:(id)data;


/**
 *	@brief	向Document写入数据.
 *
 *	@param 	fileName 	存入数据命名名称.
 *	@param 	directoyName 	存入文件夹命名名称.,如果需要,不需要传入nil.
 *	@param 	data 	NSArray or NSDictionary.
 */
+ (void)writeToDocument:(NSString *)fileName directoryName:(NSString *)directoyName withData:(id)data;


/**
 *	@brief	向Cache写入数据.
 *
 *	@param 	fileName 	存入数据命名名称.
 *	@param 	data 	NSArray or NSDictionary.
 */
+ (void)writeToCache:(NSString *)fileName withData:(id)data;


/**
 *	@brief	向Cache写入数据.
 *
 *	@param 	fileName 	存入数据命名名称.
 *	@param 	directoyName 	存入文件夹命名名称.,如果需要,不需要传入nil.
 *	@param 	data 	NSArray or NSDictionary.
 */
+ (void)writeToCache:(NSString *)fileName directoryName:(NSString *)directoyName withData:(id)data;


#pragma mark - Remove Data Methods
/**
 *	@brief	删除沙盒中存入数据.
 *
 *	@param 	fileName 	存入数据名称.
 *	@param 	directoryName 	文件夹名称,若为nil,则从根目录查找,否从文件夹内查找.
 *	@param 	document 	是否存储在document里,是从document中查找,否从Cache中查找.
 */
+ (void)removeDataWithName:(NSString *)fileName directoryName:(NSString *)directoryName isDocument:(BOOL)document;


@end
