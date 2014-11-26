//
//  CLUIImageView+CLNetwork.m
//  CLBasicFramework
//
//  Created by L on 13-11-28.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import "CLUIImageView+CLNetwork.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "CLNetWork.h"
#import "CLCache.h"
#import "Reachability.h"

typedef void (^FinishBLock)(BOOL finish);

static char const * const imageUrlChar = "imageUrl";
static char const * const dontShow = "dontShow";
static char const * const onlyWifi = "onlyWifi";
static char const * const immediately = "immediately";
static char const * const useOriginal = "useOriginal";
static char const * const activityChar = "activity";
static char const * const finishBlockChar = "finishBlock";
static char const * const animationChar = "animation";

@interface UIImageView(download)

@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, copy) FinishBLock finishBlcok;

@end

@implementation UIImageView(CLNetWork)
@dynamic activityStyle;
@dynamic animation;

- (void)dealloc
{
    self.imageUrl = nil;
    self.activityView = nil;
    self.finishBlcok = nil;
    
    objc_setAssociatedObject(self, animationChar, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [super dealloc];
}

#pragma mark - Propertys
- (BOOL)dontShowActivityView
{
    NSNumber *number = objc_getAssociatedObject(self, dontShow);
    return [number boolValue];
}

- (void)setDontShowActivityView:(BOOL)dontShowActivityView
{
    [self setup];
    NSNumber *number = [NSNumber numberWithBool:dontShowActivityView];
    objc_setAssociatedObject(self, dontShow, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle
{
    [self setup];
    self.activityView.activityIndicatorViewStyle = activityStyle;
}

- (BOOL)onlyWIFI
{
    NSNumber *number = objc_getAssociatedObject(self, onlyWifi);
    return [number boolValue];
}

- (void)setOnlyWIFI:(BOOL)onlyWIFI
{
    NSNumber *number = [NSNumber numberWithBool:onlyWIFI];
    objc_setAssociatedObject(self, onlyWifi, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dontReplaceImmediately
{
    NSNumber *number = objc_getAssociatedObject(self, immediately);
    return [number boolValue];
}

- (void)setDontReplaceImmediately:(BOOL)dontReplaceImmediately
{
    NSNumber *number = [NSNumber numberWithBool:dontReplaceImmediately];
    objc_setAssociatedObject(self, immediately, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dontUseOriginalImage
{
    NSNumber *number = objc_getAssociatedObject(self, useOriginal);
    return [number boolValue];
}

- (void)setDontUseOriginalImage:(BOOL)dontUseOriginalImage
{
    NSNumber *number = [NSNumber numberWithBool:dontUseOriginalImage];
    objc_setAssociatedObject(self, useOriginal, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAnimation:(CLViewAnimation)animation
{
    objc_setAssociatedObject(self, animationChar, [NSNumber numberWithInteger:animation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CLViewAnimation)animation
{
    NSNumber *number = objc_getAssociatedObject(self, animationChar);
    
    return [number integerValue];
}

- (FinishBLock)finishBlcok
{
    return objc_getAssociatedObject(self, finishBlockChar);
}

- (void)setFinishBlcok:(FinishBLock)finishBlcok
{
    objc_setAssociatedObject(self, finishBlockChar, finishBlcok, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIActivityIndicatorView *)activityView
{
    return objc_getAssociatedObject(self, activityChar);
}

- (void)setActivityView:(UIActivityIndicatorView *)activityView
{
    objc_setAssociatedObject(self, activityChar, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageUrl
{
    return objc_getAssociatedObject(self, imageUrlChar);
}

- (void)setImageUrl:(NSString *)imageUrl
{
    if (imageUrl.length < 1)
        return;
    
    objc_setAssociatedObject(self, imageUrlChar, imageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable || (self.onlyWIFI && status != ReachableViaWiFi))
        return;
    
    
    UIImage *image = [[UIImage alloc] initWithData:[CLCache getDataInCache:[self.imageUrl lastPathComponent] directoryName:@"ImageCache"]];
    
    if (image) {
        self.image = image;
        [self setNeedsLayout];
        [image release];
    } else {
        [self setup];
        
        if (self.dontShowActivityView)
            [self.activityView stopAnimating];
        else
            [self.activityView startAnimating];
        
        __block typeof(self) bself = self;
        
        [CLNetwork getRequestWithUrl:self.imageUrl withTag:[imageUrl lastPathComponent] requestResult:^(id object, NSError *error){
            [bself.activityView stopAnimating];
            
            __block UIImage *image = [[UIImage alloc] initWithData:object];
            if (image) {
                if (self.finishBlcok)
                    self.finishBlcok(YES);
                
                if (self.dontUseOriginalImage) {
                    NSData *smallData = UIImageJPEGRepresentation(image, 0.5);
                    [CLCache writeToCache:[bself.imageUrl lastPathComponent] directoryName:@"ImageCache" withData:smallData];
                }else
                    [CLCache writeToCache:[bself.imageUrl lastPathComponent] directoryName:@"ImageCache" withData:object];
                
                if (image && !self.dontReplaceImmediately) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        bself.image = image;
                        [image release];
                        [bself setNeedsLayout];
                        [bself startAnimation:self.animation];
                    });
                }
            }else {
                if (self.finishBlcok) {
                    self.finishBlcok(NO);
                }
            }
        }];
    }
}

#pragma mark - Instance Methods
- (void)setup
{
    if (!self.activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped = YES;
        activityView.center = self.centerBounds;
        [self addSubview:activityView];
        self.activityView = activityView;
        [activityView release];
    }
}

- (void)downloadImageProgress:(void (^)(CGFloat))imageProgress
{
    [CLNetwork requestProgressWithTag:self.imageUrl progress:^(unsigned long long reciveLength, unsigned long long totalLength, float progress){
        imageProgress(progress);
    }];
}

- (void)downloadImageFinish:(void (^)(BOOL))finish
{
    self.finishBlcok = finish;
}

#pragma mark - Class Methods
+ (void)cacheImage:(UIImage *)image withName:(NSString *)name
{
    [self cacheImageData:UIImageJPEGRepresentation(image, 0.5) withName:name];
}

+ (void)cacheImageData:(NSData *)imageData withName:(NSString *)name
{
    if (imageData)
        [CLCache writeToCache:name directoryName:@"CLImageCache" withData:imageData];
}

+ (void)removeImageCache
{
    [CLCache removeDataWithName:nil directoryName:@"CLImageCache" inDocument:NO];
}

@end
