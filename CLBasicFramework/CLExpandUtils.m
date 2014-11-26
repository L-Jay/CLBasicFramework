//
//  CLExpandUtils.m
//  CLBasicFramework
//
//  Created by L on 13-12-24.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import "CLExpandUtils.h"
#import <objc/runtime.h>

#pragma mark - UIColor Expand
@implementation UIColor (Expand)

+ (UIColor *)colorWithHexString:(NSString *)string
{
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return nil;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

#pragma mark - UIImage Expand
@implementation UIImage (Expand)
- (CGFloat)width
{
    return self.size.width;
}

- (void)setWidth:(CGFloat)width
{
    
}

- (CGFloat)height
{
    return self.size.height;
}

- (void)setHeight:(CGFloat)height
{
    
}

#pragma mark - Class Methods
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

static char const * const IndexPathChar = "IndexPath";

@implementation UIButton (Expand)

- (void)dealloc
{
    if (self.indexPath) {
        self.indexPath = nil;
        [super dealloc];
    }
}

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, IndexPathChar);
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, IndexPathChar, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation NSTimer (Expand)

-(void)pauseTimer
{
    if ([self isValid])
        [self setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer
{
    if ([self isValid])
        [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if ([self isValid])
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
