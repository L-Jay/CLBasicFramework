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

typedef void (^FinishBLock)(BOOL finish);

static char const * const imageUrlChar = "imageUrl";
static char const * const activityChar = "activity";
static char const * const finishBlockChar = "finishBlock";
static char const * const animationChar = "animation";

@interface UIImageView(download)

@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, copy) FinishBLock finishBlcok;

@end

@implementation UIImageView(CLNetWork)
@dynamic showActivityView;
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
- (void)setShowActivityView:(BOOL)showActivityView
{
    [self setup];
    [self.activityView stopAnimating];
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle
{
    [self setup];
    self.activityView.activityIndicatorViewStyle = activityStyle;
}

//====================
- (void)setAnimation:(ViewAnimation)animation
{
    objc_setAssociatedObject(self, animationChar, [NSNumber numberWithInteger:animation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ViewAnimation)animation
{
    NSNumber *number = objc_getAssociatedObject(self, animationChar);
    
    return [number integerValue];
}

//====================
- (FinishBLock)finishBlcok
{
    return objc_getAssociatedObject(self, finishBlockChar);
}

- (void)setFinishBlcok:(FinishBLock)finishBlcok
{
    objc_setAssociatedObject(self, finishBlockChar, finishBlcok, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//====================
- (UIActivityIndicatorView *)activityView
{
    return objc_getAssociatedObject(self, activityChar);
}

- (void)setActivityView:(UIActivityIndicatorView *)activityView
{
    objc_setAssociatedObject(self, activityChar, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//====================
- (NSString *)imageUrl
{
    return objc_getAssociatedObject(self, imageUrlChar);
}

- (void)setImageUrl:(NSString *)imageUrl
{
    if (imageUrl.length < 1) {
        return;
    }
    
    [CLNetwork cancelRequestWithTag:imageUrl];
    
    objc_setAssociatedObject(self, imageUrlChar, imageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIImage *image = [[UIImage alloc] initWithData:[CLCache getDataInCache:[self.imageUrl lastPathComponent] directoryName:@"ImageCache"]];
    
    if (image) {
        self.image = image;
        [self setNeedsLayout];
        [image release];
    } else {
        [self setup];
        [self.activityView startAnimating];
        
        __block typeof(self) bself = self;
        
        //
        [CLNetwork getRequestWithUrl:self.imageUrl withTag:imageUrl requestResult:^(id object, NSError *error){
            [bself.activityView stopAnimating];
            
            __block UIImage *image = [[UIImage alloc] initWithData:object];
            if (image) {
                if (self.finishBlcok) {
                    self.finishBlcok(YES);
                }
                
                [CLCache writeToCache:[bself.imageUrl lastPathComponent] directoryName:@"ImageCache" withData:object];
                
                if (image) {
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

//====================
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
+ (void)removeImageCache
{
    [CLCache removeDataWithName:nil directoryName:@"ImageCache" isDocument:NO];
}

@end
