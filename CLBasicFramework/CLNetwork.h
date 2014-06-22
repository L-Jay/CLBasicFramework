//
//  CLNetwork.h
//  CLBasicFramework
//
//  Created by L on 13-11-6.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CLNetwork : NSObject

#pragma mark - Register NetWork
///---------------------------------------------------------------------------------------
/// @name Register NetWork
///---------------------------------------------------------------------------------------


/**
 *	@brief	注册CLNetWork组件URL请求头.
 *
 *	@param 	basicUrl 	基础请求URL头.
 *	@param 	values 	请求URL固定参数.NSDictionary型,key对应相应的value.
 *
 *	@discussion	一般项目的接口的域名都是统一的,BasicURL一般就是域名,具体根据项目情况而定.values为一般固定的参数,比如auth、token等.
 */
+ (void)registerNetWorkWithBasicUrl:(NSString *)basicUrl constValue:(NSDictionary *)values;


/**
 注册CLNetWork组件.
 keyAndValue   返回结果，正确值，以及key.
 messageKey    返回说明key.
 error         请求错误返回.
 */
/**
 *	@brief	注册CLNetWork组件,请求成功状态的key值和对应的value值,描述内容的key值,错误参数.
 *
 *	@param 	keyAndValue 	请求成功下的标签key值、value值.
 *	@param 	key 	描述信息key值.
 *	@param 	error 	错误回调.
 *
 *	@discussion	这里的error是处理多个接口都会报同样错误的,比如链接超时,无法链接服务器,用户名密码错误等,可以统一写在这里处理,每个请求都会调自身的error回调，和这个回调。具体根据项目而定.
 */
+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error;


#pragma mark - NetWork Methods
///---------------------------------------------------------------------------------------
/// @name NetWork Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	固定请求参数添加参数.
 *
 *	@param 	values 	参数列表,NSDictionary型.
 *
 *	@discussion	例如需要用户登录的项目,登录成功会返回一些id之类的参数,每个接口都需要传递id.
 */
+ (void)addValueInConstValue:(NSDictionary *)values;

/**
 *	@brief	固定请求参数删除参数.
 *
 *	@param 	key 	参数对应的key值.
 *
 *	@discussion	例如需要用户登录的项目,一些接口需要id之类的参数才能请求成功,退出后需要在固定请求参数里面删除这些参数,以免出现bug.
 */
+ (void)removeValueInConstValue:(NSString *)key;


#pragma mark - NetWork Request
///---------------------------------------------------------------------------------------
/// @name POST Request Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	POST请求方法.
 *
 *	@param 	typeUrl 	功能URL,与basicUrl拼接为完整的URL,可为空.
 *	@param 	values 	传入参数,NSDictionary型.
 *	@param 	tag 	请求tag值.
 *	@param 	Object   返回数据,NSArray型或NSDictionary型.
 *	@param 	error    返回错误.
 *
 *	@discussion	一般返回数据类型为json格式,这里做了内部解析处理,如果成功的话object为NSArray型或NSDictionary型,如果未成功回把返回数据抛回来自行解析;error回调,如果+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error; 这里做了错误处理,本方法可不做处理.如有请求报错,2个方法都会调用,具体处理请根据当时情况而定.
 */
+ (void)postRequestWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id Object, NSError *error))result;


///---------------------------------------------------------------------------------------
/// @name GET Request Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	GET请求方法.
 *
 *	@param 	useUrl 	是否需要用basicURL.
 *	@param 	typeUrl 	功能URL,与basicUrl拼接为完整的URL,可为空.
 *	@param 	useValue 	是否使用固定请求参数.
 *	@param 	values 	传入参数.
 *	@param 	tag 	请求tag值.
 *	@param 	Object   返回数据,NSArray型或NSDictionary型.
 *	@param 	error    返回错误.
 *
 *	@discussion	一般返回数据类型为json格式,这里做了内部解析处理,如果成功的话object为NSArray型或NSDictionary型,如果未成功回把返回数据抛回来自行解析;error回调,如果+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error; 这里做了错误处理,本方法可不做处理.如有请求报错,2个方法都会调用,具体处理请根据当时情况而定.
 */
+ (void)getRequestUseBasicUrl:(BOOL)useUrl typeUrl:(NSString *)typeUrl useConst:(BOOL)useValue keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id Object, NSError *error))result;


/**
 *	@brief	GET请求方法.
 *
 *	@param 	url 	是否需要用basicURL.
 *	@param 	tag 	请求tag值.
 *	@param 	Object   返回数据,NSArray型或NSDictionary型.
 *	@param 	error    返回错误.
 *
 *	@discussion	一般返回数据类型为json格式,这里做了内部解析处理,如果成功的话object为NSArray型或NSDictionary型,如果未成功回把返回数据抛回来自行解析;error回调,如果+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error; 这里做了错误处理,本方法可不做处理.如有请求报错,2个方法都会调用,具体处理请根据当时情况而定.
 */
+ (void)getRequestWithUrl:(NSString *)url withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result;


/**
 *	@brief	GET请求方法.
 *
 *	@param 	useUrl 	是否需要用basicURL.
 *	@param 	values 	传入参数.
 *	@param 	tag 	请求tag值.
 *	@param 	Object   返回数据,NSArray型或NSDictionary型.
 *	@param 	error    返回错误.
 *
 *	@discussion	一般返回数据类型为json格式,这里做了内部解析处理,如果成功的话object为NSArray型或NSDictionary型,如果未成功回把返回数据抛回来自行解析;error回调,如果+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error; 这里做了错误处理,本方法可不做处理.如有请求报错,2个方法都会调用,具体处理请根据当时情况而定.
 */
+ (void)getRequestWithUrl:(NSString *)url keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result;


/**
 *	@brief	GET请求方法.
 *
 *	@param 	typeUrl 	功能URL,与basicUrl拼接为完整的URL,可为空.
 *	@param 	tag 	请求tag值.
 *	@param 	Object   返回数据,NSArray型或NSDictionary型.
 *	@param 	error    返回错误.
 *
 *	@discussion	一般返回数据类型为json格式,这里做了内部解析处理,如果成功的话object为NSArray型或NSDictionary型,如果未成功回把返回数据抛回来自行解析;error回调,如果+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error; 这里做了错误处理,本方法可不做处理.如有请求报错,2个方法都会调用,具体处理请根据当时情况而定.
 */
+ (void)getRequestUseBasicUrlAndConstValueWithTypeUrl:(NSString *)typeUrl withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result;


/**
 *	@brief	GET请求方法.
 *
 *	@param 	typeUrl 	功能URL,与basicUrl拼接为完整的URL,可为空.
 *	@param 	values 	传入参数.
 *	@param 	tag 	请求tag值.
 *	@param 	Object   返回数据,NSArray型或NSDictionary型.
 *	@param 	error    返回错误.
 *
 *	@discussion	一般返回数据类型为json格式,这里做了内部解析处理,如果成功的话object为NSArray型或NSDictionary型,如果未成功回把返回数据抛回来自行解析;error回调,如果+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *error))error; 这里做了错误处理,本方法可不做处理.如有请求报错,2个方法都会调用,具体处理请根据当时情况而定.
 */
+ (void)getRequestUseBasicUrlAndConstValueWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result;



#pragma mark - Request Progress
///---------------------------------------------------------------------------------------
/// @name Request Progress Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	请求进度.
 *
 *	@param 	reciveLength   接收的文件长度.
 *	@param 	totalLength    文件总长度.
 *	@param 	progress       接收进度.
 */
+ (void)requestProgressWithTag:(NSString *)tag progress:(void (^)(unsigned long long reciveLength, unsigned long long totalLength, float progress))progress;


/**
 *	@brief	上传进度.
 *
 *	@param 	reciveLength   接收的文件长度.
 *	@param 	totalLength    文件总长度.
 *	@param 	progress       接收进度.
 */
+ (void)sendProgressWithTag:(NSString *)tag progress:(void (^)(unsigned long long sendLength, unsigned long long totalLength, float progress))progress;

#pragma mark - Cancel Request
///---------------------------------------------------------------------------------------
/// @name Request Progress Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	取消某个请求.
 *
 *	@param 	tag 	取消请求的tag值.
 */
+ (void)cancelRequestWithTag:(NSString *)tag;


/**
 *	@brief	取消所有请求.
 */
+ (void)cancelAllRequest;


#pragma mark - NetWorkStatus Methods
///---------------------------------------------------------------------------------------
/// @name NetWork Status Methods
///---------------------------------------------------------------------------------------


/**
 *	@brief	当前是否有网络.
 *
 *	@return	如果有网,返回YES.
 */
+ (BOOL)isNetworkAvailable;


/**
 *	@brief	当前网络状态.
 *
 *	@return	返回NetworkStatus型,详见Reachability.h头文件.
 */
+ (NetworkStatus)currentNetworkStatus;

/**
 *	@brief	当前网络名称.
 *
 *	@return	返回当前网络名称,如Wifi,3G.
 */
+ (NSString *)currentNetworkStatusName;


@end
