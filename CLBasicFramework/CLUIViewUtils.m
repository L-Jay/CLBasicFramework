//
//  CLUIViewUtils.m
//  CLBasicFramework
//
//  Created by L on 13-11-29.
//  Copyright (c) 2013年 Cui. All rights reserved.
//

#import "CLUIViewUtils.h"
#import <objc/runtime.h>

static char const * const controllerChar = "controller";

@implementation UIView(Util)

#pragma mark - Coordinate
- (CGFloat)minX {
	return self.frame.origin.x;
}

- (void)setMinX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)minY {
	return self.frame.origin.y;
}

- (void)setMinY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)maxX {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x - frame.size.width;
	self.frame = frame;
}

- (CGFloat)maxY {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setMaxY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y - frame.size.height;
	self.frame = frame;
}

- (CGFloat)centerX {
	return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
	return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGPoint)origin {
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (CGPoint)centerBounds {
	return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setCenterBounds:(CGPoint)centerBounds
{
    
}

#pragma mark - Property Extend
- (void)setController:(UIViewController *)controller
{
    
}

- (UIViewController *)controller
{
    for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
    
    return nil;
}

#pragma mark - Instance Methods
- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)removeAllSubviewsWith:(Class)class
{
    for (UIView *view in self.subviews)
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
}

#pragma mark - Subview Methods
- (UIView *)subviewWithClass:(Class)class
{
    if ([self isKindOfClass:class])
        return self;
    
    for (UIView *subview in self.subviews) {
        UIView *view = [subview subviewWithClass:class];
        if (view)
            return view;
    }
    
    return nil;
}

- (UIView *)superviewWithClass:(Class)class
{
    if ([self isKindOfClass:class])
        return self;
    else if (self.superview)
        return [self.superview superviewWithClass:class];
    else
        return nil;
}

- (UIView *)subviewAtIndex:(NSInteger)index
{
    if (self.subviews.count > index)
        return [self.subviews objectAtIndex:index];
    
    return nil;
}

#pragma mark - Animations
- (void)startAnimation:(ViewAnimation)animation
{
    CATransition *transtion = [CATransition animation];
    transtion.delegate = self;
    transtion.timingFunction = UIViewAnimationCurveEaseInOut;
    
    CGFloat duration = 0.3;
    NSString *animationType = nil;
    NSString *animationSubType = nil;
    
    switch (animation) {
        case AnimationFade:
            animationType = kCATransitionFade;
            break;
        case AnimationRipple:
            animationType = @"rippleEffect";
            duration = 0.5;
            break;
        case AnimationSuckEffect:
            animationType = @"suckEffect";
            break;
        case AnimationFlipFromLeft:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationFlipFromRight:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationFlipFromBottm:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationFlipFromTop:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromTop;
            break;
        case AnimationPageCurlFromLeft:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationPageCurlFromRight:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationPageCurlFromBottom:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationPageCurlFromTop:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromTop;
            break;
        case AnimationPageUnCurlFromLeft:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationPageUnCurlFromRight:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationPageUnCurlFromBottom:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationPageUnCurlFromTop:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromTop;
            break;
        case AnimationMoveInFromLeft:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationMoveInFromRight:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationMoveInFromBottom:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationMoveInFromTop:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromTop;
            break;
        case AnimationPushFromLeft:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationPushFromRight:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationPushFromBottom:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationPushFromTop:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromTop;
            break;
        case AnimationRevealFromLeft:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationRevealFromRight:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationRevealFromBottom:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationRevealFromTop:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromTop;
            break;
        case AnimationCubeFromLeft:
            animationType = @"cube";
            animationSubType = kCATransitionFromLeft;
            break;
        case AnimationCubeFromRight:
            animationType = @"cube";
            animationSubType = kCATransitionFromRight;
            break;
        case AnimationCubeFromBottom:
            animationType = @"cube";
            animationSubType = kCATransitionFromBottom;
            break;
        case AnimationCubeFromTop:
            animationType = @"cube";
            animationSubType = kCATransitionFromTop;
            break;
        default:
            animationType = kCATransitionFade;
            break;
    }
    
    transtion.duration = duration;
    transtion.type = animationType;
    transtion.subtype = animationSubType;
    [self.layer addAnimation:transtion forKey:nil];
    transtion = nil;
}

@end