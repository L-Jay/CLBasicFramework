//
//  CLBasicFramework.m
//  CLBasicFramework
//
//  Created by L on 14-3-4.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "CLBasicFramework.h"

@implementation CLBasicFramework

#pragma mark - IOS Version
CGFloat DeviceSystemVersion() {
    static CGFloat _deviceSystemVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *valueArray = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
        NSMutableString *versionString = [NSMutableString stringWithFormat:@"%d.", [[valueArray objectAtIndex:0] intValue]];
        for (int i = 1; i < valueArray.count; i++) {
            [versionString appendString:[valueArray objectAtIndex:i]];
        }
        
        _deviceSystemVersion = [versionString floatValue];
    });
    return _deviceSystemVersion;
}

#pragma mark - ID
+ (NSString *)UUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    return uuid;
}

@end

