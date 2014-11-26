//
//  CLCache.m
//  CLBasicFramework
//
//  Created by L on 13-11-28.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import "CLCache.h"
#import <objc/runtime.h>

@implementation CLCache

#pragma mark - Path Mehods
+ (NSString *)document
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)cache
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)checkDirectory:(NSString *)directoryName isDocument:(BOOL)isDocument
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = nil;
    if (isDocument)
        path = [[self document] stringByAppendingPathComponent:directoryName];
    else
        path = [[self cache] stringByAppendingPathComponent:directoryName];
    
    BOOL isDirectory;
    BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if ((isExist && isExist)) {
        return path;
    }
    
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    return path;
}

#pragma mark - Write And Read
+ (id)getDataAtPath:(NSString *)path
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unarchiver decodeObjectForKey:@"key"];
    
    [data release];
    [unarchiver release];
    
    return object;
}

+ (void)writeAtPath:(NSString *)path data:(NSData *)data
{
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:data forKey:@"key"];
    [archiver finishEncoding];
    
    [mutableData writeToFile:path atomically:YES];
    
    [mutableData release];
    [archiver release];
}

#pragma mark - Get Data Methods
+ (id)getDataInDocument:(NSString *)fileName
{
    return [self getDataAtPath:[[self document] stringByAppendingPathComponent:fileName]];
}

+ (id)getDataInDocument:(NSString *)fileName directoryName:(NSString *)directoyName
{
    NSString *path = [[[self document] stringByAppendingPathComponent:directoyName] stringByAppendingPathComponent:fileName];
    return [self getDataAtPath:path];
}

+ (id)getDataInCache:(NSString *)fileName
{
    return [self getDataAtPath:[[self cache] stringByAppendingPathComponent:fileName]];
}

+ (id)getDataInCache:(NSString *)fileName directoryName:(NSString *)directoyName
{
    NSString *path = [[[self cache] stringByAppendingPathComponent:directoyName] stringByAppendingPathComponent:fileName];
    return [self getDataAtPath:path];
}

#pragma mark - Write Data Methods
+ (void)writeToDocument:(NSString *)fileName withData:(id)data
{
    [self writeAtPath:[[self document] stringByAppendingPathComponent:fileName] data:data];
}

+ (void)writeToDocument:(NSString *)fileName directoryName:(NSString *)directoyName withData:(id)data
{
    NSString *path = [[self checkDirectory:directoyName isDocument:YES] stringByAppendingPathComponent:fileName];
    [self writeAtPath:path data:data];
}

+ (void)writeToCache:(NSString *)fileName withData:(id)data
{
    [self writeAtPath:[[self cache] stringByAppendingPathComponent:fileName] data:data];
}

+ (void)writeToCache:(NSString *)fileName directoryName:(NSString *)directoyName withData:(id)data
{
    NSString *path = [[self checkDirectory:directoyName isDocument:NO] stringByAppendingPathComponent:fileName];
    
    [self writeAtPath:path data:data];
}

#pragma mark - Remove Data Methods
+ (void)removeDataByPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager isDeletableFileAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}
+ (void)removeDataWithName:(NSString *)fileName directoryName:(NSString *)directoryName inDocument:(BOOL)document
{
    NSString *directory = nil;
    if (document)
        directory = [self document];
    else
        directory = [self cache];
    
    NSString *path = nil;
    if (fileName.length > 0 && directoryName.length > 0)
        path = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", directoryName, fileName]];
    else if (directoryName.length > 0 && fileName.length < 1)
        path = [directory stringByAppendingPathComponent:directoryName];
    else if (directoryName.length < 1 && fileName.length > 0)
        path = [directory stringByAppendingPathComponent:fileName];
    else
        path = nil;
    
    [self removeDataByPath:path];
}

@end

#pragma mark - AutoEncode

@implementation NSObject (Decoder)

- (void)encodeWithCoder:(NSCoder*)coder
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    
    for (NSString *name in propertyArray)
    {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [self init])
    {
        if (decoder == nil)
        {
            return self;
        }
        
        Class clazz = [self class];
        u_int count;
        
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        
        for (NSString *name in propertyArray)
        {
            id value = [decoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}

@end
