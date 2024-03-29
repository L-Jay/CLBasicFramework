//
//  CLNetwork.m
//  CLBasicFramework
//
//  Created by L on 13-11-6.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import "CLNetwork.h"
#import <objc/runtime.h>
#import "CLBasicFramework.h"

#define CLRELEASE(exp) [exp release], exp = nil

typedef void (^RequestCallBack)(id object, NSError *error);
typedef void (^RequestWithTag)(id object, NSError *error, NSString *tag);
typedef void (^ErrorCallBack)(NSError *error);
typedef void (^ProgressCallBack)(unsigned long long reciveLength, unsigned long long totalLength, float progress);

@interface NSURLConnection (ReciveData)

@property (nonatomic, retain) NSMutableData *reciveData;

@property (nonatomic, copy) RequestCallBack requestBlock;
@property (nonatomic, copy) RequestWithTag requestWithTagBlock;
@property (nonatomic, copy) ProgressCallBack getProgressBlock;
@property (nonatomic, copy) ProgressCallBack sendProgressBlock;

@property (nonatomic, retain) NSNumber *getFileLength;
@property (nonatomic, retain) NSNumber *sendFileLength;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) NSInteger statusCode;

@end

@interface CLNetwork ()<NSURLConnectionDelegate>

@property (nonatomic, copy) NSString *basicUrl;
@property (nonatomic, retain) NSMutableDictionary *constValue;

@property (nonatomic, copy) NSString *resultKey;
@property (nonatomic) NSInteger successValue;
@property (nonatomic, copy) NSString *messageKey;

@property (nonatomic, copy) ErrorCallBack errorBlock;

@property (nonatomic, retain) NSMutableDictionary *requestDic;


@end

@implementation CLNetwork

- (void)dealloc
{
    CLRELEASE(_basicUrl);
    CLRELEASE(_constValue);
    
    CLRELEASE(_resultKey);
    CLRELEASE(_messageKey);
    
    Block_release(_errorBlock);
    
    CLRELEASE(_requestDic);
    
    [super dealloc];
}

#pragma mark - Singleton
+ (CLNetwork *)shareNetWork
{
    static CLNetwork *netWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [[self alloc] init];
        netWork.requestDic = [NSMutableDictionary dictionary];
    });
    
    return netWork;
}

#pragma mark - Register NetWork
+ (void)registerNetWorkWithBasicUrl:(NSString *)basicUrl constValue:(NSDictionary *)values
{
    CLNetwork *netWork = [self shareNetWork];
    netWork.basicUrl = basicUrl;
    netWork.constValue = [NSMutableDictionary dictionaryWithDictionary:values];
}

+ (void)registerNetWorkWithResultKeyAndSuccessValue:(NSDictionary *)keyAndValue messageKey:(NSString *)key error:(void (^)(NSError *))error
{
    CLNetwork *netWork = [self shareNetWork];
    netWork.errorBlock = error;
    
    if (!keyAndValue || !key) {
        NSError *error = [[NSError alloc] initWithDomain:@"返回结果参数未注册" code:1234567 userInfo:nil];
        netWork.errorBlock(error);
        [error release];
        
        return;
    }
    
    netWork.resultKey = [[keyAndValue allKeys] objectAtIndex:0];
    netWork.successValue = [[[keyAndValue allValues] objectAtIndex:0] integerValue];
    netWork.messageKey = key;
}

#pragma mark - NetWork Methods
+ (void)addValueInConstValue:(NSDictionary *)values
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    
    for (NSString *key in values.allKeys)
        [netWork.constValue setObject:[values objectForKey:key] forKey:key];
}

+ (void)removeValueInConstValue:(NSString *)key
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    [netWork.constValue removeObjectForKey:key];
}

#pragma mark - NetWork Request
+ (void)postRequestWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (tag.length > 0 && connection) {
        connection.requestBlock = result;
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *content = [self contentString:values useConstValue:YES];
    
    NSString *urlString = nil;
    if (typeUrl)
        urlString = [NSString stringWithFormat:@"%@%@", netWork.basicUrl, typeUrl];
    else
        urlString = netWork.basicUrl;
    
    NSURL *requestURL = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:0 timeoutInterval:20];
    NSString *contentLength = [NSString stringWithFormat:@"%lu", (unsigned long)[content length]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:netWork startImmediately:NO];
    urlConnection.reciveData = [NSMutableData data];
    urlConnection.requestBlock = result;
    if (tag.length > 0)
        urlConnection.tag = tag;
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlConnection start];
    
    if (tag.length > 0)
        [netWork.requestDic setObject:urlConnection forKey:tag];
    
    [requestURL release];
    [request release];
    [urlConnection release];
}

+ (void)postRequestWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResultWithTag:(void (^)(id, NSError *, NSString *))result
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (tag.length > 0 && connection) {
        connection.requestWithTagBlock = result;
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *content = [self contentString:values useConstValue:YES];
    NSString *urlString = nil;
    if (typeUrl)
        urlString = [NSString stringWithFormat:@"%@%@", netWork.basicUrl, typeUrl];
    else
        urlString = netWork.basicUrl;
    
    NSURL *requestURL = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:0 timeoutInterval:20];
    NSString *contentLength = [NSString stringWithFormat:@"%lu", (unsigned long)[content length]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:netWork startImmediately:NO];
    urlConnection.reciveData = [NSMutableData data];
    urlConnection.requestWithTagBlock = result;
    if (tag.length > 0)
        urlConnection.tag = tag;
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlConnection start];
    
    if (tag.length > 0)
        [netWork.requestDic setObject:urlConnection forKey:tag];
    
    [requestURL release];
    [request release];
    [urlConnection release];
}

+ (void)postImageRequestWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values image:(UIImage *)image withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    [self postImageRequestWithTypeUrl:typeUrl keyAndValues:values imageData:UIImageJPEGRepresentation(image, 0.5) withTag:tag requestResult:result];
}

+ (void)postImageRequestWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values imageData:(NSData *)imageData withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    if (!imageData)
        return;
    
    CLNetwork *netWork = [CLNetwork shareNetWork];
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (tag.length > 0 && connection) {
        connection.requestBlock = result;
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = nil;
    if (typeUrl)
        urlString = [NSString stringWithFormat:@"%@%@", netWork.basicUrl, typeUrl];
    else
        urlString = netWork.basicUrl;
    
    NSURL *requestURL = [[NSURL alloc] initWithString:urlString];
    
    NSString *boundary = @"CLNetworkBoundary7d33a816d302b6";
    NSString *midBoundary = [NSString stringWithFormat:@"--%@", boundary];
    NSString *endBoundary = [NSString stringWithFormat:@"%@--", midBoundary];
    
    NSMutableString *bodyString = [NSMutableString string];
    
    for (NSString *key in [values allKeys]) {
        [bodyString appendFormat:@"%@\r\n", midBoundary];
        [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [bodyString appendFormat:@"%@\r\n", [values objectForKey:key]];
    }
    
    [bodyString appendFormat:@"%@\r\n", midBoundary];
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"imageName\"; filename=\"fileName.png\"\r\n"];
    [bodyString appendFormat:@"Content-Type: image/png, image/jpge, image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    
    NSString *endString = [NSString stringWithFormat:@"\r\n%@", endBoundary];
    
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:imageData];
    [postData appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSString *contentLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:0 timeoutInterval:20];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:netWork startImmediately:NO];
    urlConnection.reciveData = [NSMutableData data];
    urlConnection.requestBlock = result;
    if (tag.length > 0)
        urlConnection.tag = tag;
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlConnection start];
    
    if (tag.length > 0)
        [netWork.requestDic setObject:urlConnection forKey:tag];
    
    [requestURL release];
    [request release];
    [urlConnection release];
}

//==================GET
+ (void)getRequestUseBasicUrl:(BOOL)useUrl typeUrl:(NSString *)typeUrl useConst:(BOOL)useValue keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (tag.length > 0 && connection) {
        connection.requestBlock = result;
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *content = [self contentString:values useConstValue:useValue];
    content = content.length ? [NSString stringWithFormat:@"?%@", content] : @"";
    typeUrl = typeUrl.length ? typeUrl : @"";
    
    NSString *urlString = nil;
    if (useUrl)
        urlString = [NSString stringWithFormat:@"%@%@%@", netWork.basicUrl, typeUrl, content];
    else
        urlString = [NSString stringWithFormat:@"%@%@", typeUrl, content];
    
    NSURL *requestURL = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL
                                                                cachePolicy:0
                                                            timeoutInterval:20];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:netWork startImmediately:NO];
    urlConnection.reciveData = [NSMutableData data];
    urlConnection.requestBlock = result;
    if (tag.length > 0)
        urlConnection.tag = tag;
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlConnection start];
    
    if (tag.length > 0)
        [netWork.requestDic setObject:urlConnection forKey:tag];
    
    [requestURL release];
    [request release];
    [urlConnection release];
}

+ (void)getRequestUseBasicUrl:(BOOL)useUrl typeUrl:(NSString *)typeUrl useConst:(BOOL)useValue keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResultWithTag:(void (^)(id, NSError *, NSString *))result
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (tag.length > 0 && connection) {
        connection.requestWithTagBlock = result;
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    NSString *content = [self contentString:values useConstValue:useValue];
    content = content.length ? [NSString stringWithFormat:@"?%@", content] : @"";
    typeUrl = typeUrl.length ? typeUrl : @"";
    
    NSString *urlString = nil;
    if (useUrl)
        urlString = [NSString stringWithFormat:@"%@%@%@", netWork.basicUrl, typeUrl, content];
    else
        urlString = [NSString stringWithFormat:@"%@%@", typeUrl, content];
    
    NSURL *requestURL = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL
                                                                cachePolicy:0
                                                            timeoutInterval:20];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:netWork startImmediately:NO];
    urlConnection.reciveData = [NSMutableData data];
    urlConnection.requestWithTagBlock = result;
    if (tag.length > 0)
        urlConnection.tag = tag;
    [urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlConnection start];
    
    if (tag.length > 0)
        [netWork.requestDic setObject:urlConnection forKey:tag];
    
    [requestURL release];
    [request release];
    [urlConnection release];
}

+ (void)getRequestWithUrl:(NSString *)url withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    [self getRequestUseBasicUrl:NO typeUrl:url useConst:NO keyAndValues:nil withTag:tag requestResult:result];
}

+ (void)getRequestWithUrl:(NSString *)url withTag:(NSString *)tag requestResultWithTag:(void (^)(id, NSError *, NSString *))result
{
    [self getRequestUseBasicUrl:NO typeUrl:url useConst:NO keyAndValues:nil withTag:tag requestResultWithTag:result];
}

+ (void)getRequestWithUrl:(NSString *)url keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    [self getRequestUseBasicUrl:NO typeUrl:url useConst:NO keyAndValues:values withTag:tag requestResult:result];
}

+ (void)getRequestUseBasicUrlAndConstValueWithTypeUrl:(NSString *)typeUrl withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    [self getRequestUseBasicUrl:YES typeUrl:typeUrl useConst:YES keyAndValues:nil withTag:tag requestResult:result];
}

+ (void)getRequestUseBasicUrlAndConstValueWithTypeUrl:(NSString *)typeUrl keyAndValues:(NSDictionary *)values withTag:(NSString *)tag requestResult:(void (^)(id, NSError *))result
{
    [self getRequestUseBasicUrl:YES typeUrl:typeUrl useConst:YES keyAndValues:values withTag:tag requestResult:result];
}

#pragma mark - Methods

+ (NSString *)contentString:(NSDictionary *)values useConstValue:(BOOL)use
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    
    NSMutableDictionary *finalValue = [NSMutableDictionary dictionary];
    if (use) {
        [finalValue addEntriesFromDictionary:netWork.constValue];
    }
    
    [finalValue addEntriesFromDictionary:values];
    
    NSMutableString *content = [NSMutableString string];
    
    NSInteger i = 0;
    for (NSString *key in finalValue.allKeys) {
        id value = [finalValue objectForKey:key];
        
        if ([value isKindOfClass:NSData.class]) {
            value = [value description];
        }
        
        [content appendString:[NSString stringWithFormat:@"%@=%@%@", [key URLEncode], [value URLEncode], (i<finalValue.allKeys.count-1 ?  @"&" : @"")]];
        
        i++;
    }
    
    if (content.length > 0) {
        return content;
    }
    
    return nil;
}

#pragma mark - Request Progress
+ (void)requestProgressWithTag:(NSString *)tag progress:(void (^)(unsigned long long, unsigned long long, float))progress
{
    if (tag.length < 1) {
        NSLog(@"没有输入tag值，无法获取progress");
        return;
    }
    
    CLNetwork *netWork = [CLNetwork shareNetWork];
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (connection) {
        connection.getProgressBlock = progress;
    }
}

+ (void)sendProgressWithTag:(NSString *)tag progress:(void (^)(unsigned long long, unsigned long long, float))progress
{
    if (tag.length < 1) {
        NSLog(@"没有输入tag值，无法获取progress");
        return;
    }
    
    CLNetwork *netWork = [CLNetwork shareNetWork];
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (connection) {
        connection.sendProgressBlock = progress;
    }
}

#pragma mark - Cancel Request
+ (void)cancelRequestWithTag:(NSString *)tag
{
    if (tag.length < 1) {
        NSLog(@"没有输入tag值，无法取消响应的请求");
        return;
    }
    
    CLNetwork *netWork = [CLNetwork shareNetWork];
    
    NSURLConnection *connection = [netWork.requestDic objectForKey:tag];
    if (connection) {
        [connection cancel];
        [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [netWork.requestDic removeObjectForKey:tag];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

+ (void)cancelAllRequest
{
    CLNetwork *netWork = [CLNetwork shareNetWork];
    
    for (NSURLConnection *connection in [netWork.requestDic allValues]) {
        if ([connection isKindOfClass:[NSURLConnection class]] && connection) {
            [connection cancel];
            [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
    }
    
    [netWork.requestDic removeAllObjects];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - NSURLConnectionDelegate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    //#warning learn
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    connection.statusCode = [(NSHTTPURLResponse *)response statusCode];
    
    connection.getFileLength = [NSNumber numberWithUnsignedLongLong:[response expectedContentLength]];
    
    if (connection.getProgressBlock) {
        connection.getProgressBlock(0, [connection.getFileLength unsignedLongLongValue], 0);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [connection.reciveData appendData:data];
    
    if (connection.getProgressBlock) {
        float progress = connection.reciveData.length*1.0 / [connection.getFileLength unsignedLongLongValue]*1.0;
        connection.getProgressBlock(connection.reciveData.length, [connection.getFileLength unsignedLongLongValue], progress);
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if ([connection.sendFileLength integerValue] != totalBytesExpectedToWrite) {
        NSNumber *totalLength = [[NSNumber alloc] initWithInteger:totalBytesExpectedToWrite];
        connection.sendFileLength = totalLength;
        [totalLength release];
    }
    
    if (connection.sendProgressBlock) {
        connection.sendProgressBlock(totalBytesWritten, totalBytesExpectedToWrite, (totalBytesWritten*0.1) / (totalBytesExpectedToWrite*0.1));
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (connection.tag.length > 0)
        [[CLNetwork shareNetWork].requestDic removeObjectForKey:connection.tag];
    
    if (error) {
        if ([CLNetwork shareNetWork].errorBlock) {
            ([CLNetwork shareNetWork].errorBlock)(error);
        }
        
        if (connection.requestBlock) {
            connection.requestBlock(nil, error);
        }
        
        if (connection.requestWithTagBlock) {
            connection.requestWithTagBlock(nil, error, connection.tag);
        }
    }
    
    //
    [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (connection.getProgressBlock) {
        connection.getProgressBlock([connection.getFileLength unsignedLongLongValue], [connection.getFileLength unsignedLongLongValue], 1);
    }
    
    if (connection.sendProgressBlock) {
        connection.sendProgressBlock([connection.sendFileLength unsignedLongLongValue], [connection.sendFileLength unsignedLongLongValue], 1);
    }
    
    if (connection.tag.length > 0)
        [[CLNetwork shareNetWork].requestDic removeObjectForKey:connection.tag];
    
    NSError *error = nil;
    NSError *jsonError = nil;
    
    id object = [NSJSONSerialization JSONObjectWithData:connection.reciveData options:kNilOptions error:&jsonError];
    
    if (jsonError) {
        NSString *reciveStr = [[NSString alloc] initWithData:connection.reciveData encoding:NSASCIIStringEncoding];
        NSData *recivedata = [reciveStr dataUsingEncoding:NSUTF8StringEncoding];
        if (recivedata) {
            jsonError = nil;
            object = [NSJSONSerialization JSONObjectWithData:recivedata options:kNilOptions error:&jsonError];
        }
    }
    
    if (jsonError) {        
        NSString *reciveStr = [[NSString alloc] initWithData:connection.reciveData encoding:NSUTF8StringEncoding];
        NSData *recivedata = [reciveStr dataUsingEncoding:NSUTF8StringEncoding];
        if (recivedata) {
            jsonError = nil;
            object = [NSJSONSerialization JSONObjectWithData:recivedata options:kNilOptions error:&jsonError];
        }
    }
    
    if(jsonError){
        error = [[NSError alloc] initWithDomain:@"JSON解析数据异常" code:jsonError.code userInfo:jsonError.userInfo];
        object = connection.reciveData;
    }else {
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (self.resultKey) {
                if ([[object allKeys] containsObject:self.resultKey]) {
                    NSInteger resultValue = [[object objectForKey:self.resultKey] integerValue];
                    if (resultValue != self.successValue) {
                        NSString *domian = [object objectForKey:self.messageKey] ? : @"";
                        error = [[NSError alloc] initWithDomain:domian code:resultValue userInfo:object];
                    }
                }
            }else {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:object];
                [tempDic setObject:[NSString stringWithFormat:@"%ld", (long)connection.statusCode] forKey:@"CLStatusCode"];
                object = tempDic;
            }
        }
    }
    
    if ([CLNetwork shareNetWork].errorBlock && error) {
        ([CLNetwork shareNetWork].errorBlock)(error);
    }
    
    if (connection.requestBlock) {
        connection.requestBlock(object, error);
    }
    
    if (connection.requestWithTagBlock)
        connection.requestWithTagBlock(object, error, connection.tag);
    
    [error release];
    
    [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - NetWorkStatus Methods
//是否有可用网络
+ (BOOL)isNetworkAvailable{
    if([self currentNetworkStatus] == NotReachable){
        return NO;
    }
    return YES;
}

//当前网络状态
+ (NetworkStatus)currentNetworkStatus{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability currentReachabilityStatus];
}

//当前网络状态名称
+ (NSString *)currentNetworkStatusName{
    switch ([self currentNetworkStatus]) {
        case NotReachable:
            return @"NotNetwork";
        case ReachableViaWiFi:
            return @"Wifi";
        case ReachableVia3G:
            return @"3G";
        case ReachableVia2G:
            return @"2G";
    }
}

@end

@implementation NSURLConnection (ReciveData)

static char const * const reciveDataChar = "reciveData";
static char const * const requestBlockChar = "requestBlock";
static char const * const requestWithTagChar = "requestWithTagBlock";
static char const * const getProgressBlockChar = "getProgressBlock";
static char const * const sendProgressBlockChar = "sendProgressBlock";
static char const * const getFileLengthChar = "getFileLength";
static char const * const sendFileLengthChar = "sendFileLength";
static char const * const tagChar = "tag";
static char const * const statusCodeChar = "clstatusCode";

- (void)dealloc
{
    self.reciveData = nil;
    
    self.requestBlock = nil;
    self.requestWithTagBlock = nil;
    self.getProgressBlock = nil;
    self.sendProgressBlock = nil;
    
    self.getFileLength = nil;
    self.sendFileLength = nil;
    
    self.tag = nil;
    
    [super dealloc];
}

- (NSMutableData *)reciveData
{
    return objc_getAssociatedObject(self, reciveDataChar);
}

- (void)setReciveData:(NSMutableData *)reciveData
{
    objc_setAssociatedObject(self, reciveDataChar, reciveData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RequestCallBack)requestBlock
{
    return objc_getAssociatedObject(self, requestBlockChar);
}

- (void)setRequestBlock:(RequestCallBack)requestBlock
{
    objc_setAssociatedObject(self, requestBlockChar, requestBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (RequestWithTag)requestWithTagBlock
{
    return objc_getAssociatedObject(self, requestWithTagChar);
}

- (void)setRequestWithTagBlock:(RequestWithTag)requestWithTagBlock
{
    objc_setAssociatedObject(self, requestWithTagChar, requestWithTagBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ProgressCallBack)getProgressBlock
{
    return objc_getAssociatedObject(self, getProgressBlockChar);
}

- (void)setGetProgressBlock:(ProgressCallBack)progressBlock
{
    objc_setAssociatedObject(self, getProgressBlockChar, progressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ProgressCallBack)sendProgressBlock
{
    return objc_getAssociatedObject(self, sendProgressBlockChar);
}

- (void)setSendProgressBlock:(ProgressCallBack)sendProgressBlock
{
    objc_setAssociatedObject(self, sendProgressBlockChar, sendProgressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)getFileLength
{
    return objc_getAssociatedObject(self, getFileLengthChar);
}

- (void)setGetFileLength:(NSNumber *)fileLength
{
    objc_setAssociatedObject(self, getFileLengthChar, fileLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)sendFileLength
{
    return objc_getAssociatedObject(self, sendFileLengthChar);
}

- (void)setSendFileLength:(NSNumber *)sendFileLength
{
    objc_setAssociatedObject(self, sendFileLengthChar, sendFileLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)tag
{
    return objc_getAssociatedObject(self, tagChar);
}

- (void)setTag:(NSString *)tag
{
    objc_setAssociatedObject(self, tagChar, tag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)statusCode
{
    NSNumber *number = objc_getAssociatedObject(self, statusCodeChar);
    
    return [number integerValue];
}

- (void)setStatusCode:(NSInteger)statusCode
{
    NSNumber *number = [NSNumber numberWithInteger:statusCode];
    objc_setAssociatedObject(self, statusCodeChar, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
