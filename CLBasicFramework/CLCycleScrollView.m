//
//  CLCycleScrollView.m
//  CLCycleScrollView
//
//  Created by L on 14-6-27.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "CLCycleScrollView.h"
#import "CLExpandUtils.h"
#import "CLBasicFramework.h"

@interface CLCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *contentViews;
@property (nonatomic, retain) NSMutableDictionary *reusableViewDic;

@property (nonatomic, assign) NSInteger numOfViews;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

@property (nonatomic, retain) NSTimer *autoTimer;

@end

@implementation CLCycleScrollView

- (void)dealloc
{
    CLRELEASE(_scrollView);
    
    CLRELEASE(_contentViews);
    CLRELEASE(_reusableViewDic);
    
    CLRELEASE(_tapGesture);
    
    CLRELEASE(_autoTimer);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //===== init data
        self.contentViews = [NSMutableArray array];
        self.reusableViewDic = [NSMutableDictionary dictionary];
        self.interspaceWidth = 0;
        
        //=====  ScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 1.0;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        [scrollView release];
        
        //===== TapGesture
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentView)];
        tapGesture.numberOfTapsRequired = 1;
        self.tapGesture = tapGesture;
        [tapGesture release];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    self.scrollView.frame = CGRectMake(0, 0, self.width+self.interspaceWidth, self.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*3, 0);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0);
    
    if (self.autoScrollDuration > 0) {
        //===== Timer
        self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollDuration
                                                          target:self
                                                        selector:@selector(nextPage)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    
    [self reloadData];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectEqualToRect(self.bounds, self.superview.bounds))
        return [super hitTest:point withEvent:event];
    
    CGPoint touchPoint = [self convertPoint:point toView:self.superview];
    CGRect touchScrollRect = CGRectMake(0, self.minY, self.superview.width, self.height);
    if (CGRectContainsPoint(touchScrollRect, touchPoint))
        return self.scrollView;
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - Methods
- (void)reloadData
{
    [self.contentViews removeAllObjects];
    
    NSInteger preViewIndex = [self validIndex:self.currentIndex-1];
    NSInteger curViewIndex = [self validIndex:self.currentIndex];
    NSInteger nexViewIndex = [self validIndex:self.currentIndex+1];
    
    CLCycleScrollViewContentView *preContentView = [self.dataSource cycleScrollView:self viewAtIndex:preViewIndex];
    CLCycleScrollViewContentView *curContentView = [self.dataSource cycleScrollView:self viewAtIndex:curViewIndex];
    CLCycleScrollViewContentView *nexContentView = [self.dataSource cycleScrollView:self viewAtIndex:nexViewIndex];
    
    [self.contentViews addObject:preContentView];
    [self.contentViews addObject:curContentView];
    [self.contentViews addObject:nexContentView];
    
    //===
    [self reLayoutSubviews];
}

- (void)nextPage
{
    [self.autoTimer pauseTimer];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*2, 0) animated:YES];
}

- (void)prevPage
{
    [self.autoTimer pauseTimer];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - Private Methods
- (NSInteger)numOfViews
{
    return [self.dataSource numberOfViewsInCycleScrollView:self];
}

- (NSInteger)validIndex:(NSInteger)index
{
    if (index == -1)
        return self.numOfViews-1;
    else if (index == self.numOfViews)
        return 0;
    else
        return index;
}

- (void)addToReusableViews:(CLCycleScrollViewContentView *)contentView
{
    NSMutableArray *array = [self.reusableViewDic objectForKey:contentView.identifier];
    if (array)
        [array addObject:contentView];
    else {
        array = [NSMutableArray arrayWithObject:contentView];
        [self.reusableViewDic setObject:array forKey:contentView.identifier];
    }
}

- (CLCycleScrollViewContentView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier
{
    NSArray *array = [self.reusableViewDic objectForKey:identifier];
    return array.count > 0 ? [array objectAtIndex:0] : nil;
}

- (void)reLayoutSubviews
{
    [self.scrollView removeAllSubviews];
    
    for (int i = 0; i < self.contentViews.count; i++) {
        CLCycleScrollViewContentView *view = [self.contentViews objectAtIndex:i];
        view.cycleScrollView = self;
        
        //====
        if (view.zoomScale > 1.0)
            [view setZoomScale:1.0 animated:YES];
        
        //====
        view.minX = self.scrollView.width*i;
        
        //====
        if (i == 1) {
            [view addGestureRecognizer:self.tapGesture];
            
            if (self.maxZoomScale > 1.0) {
                view.maximumZoomScale = self.maxZoomScale;
                [self.tapGesture requireGestureRecognizerToFail:view.doubleTapGesture];
            }
        }
        
        //====
        [self.scrollView addSubview:view];
    }
}

- (void)clickContentView
{
    [self.delegate cycleScrollView:self didSelectViewAtIndex:self.currentIndex];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.autoTimer pauseTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    //=====
    CGFloat willMove = round(scrollView.contentOffset.x/scrollView.width)-1;
    
    if (willMove == 1) {
        //====
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - scrollView.width, 0);
        self.currentIndex = [self validIndex:self.currentIndex+1];
        
        //===
        [self.delegate cycleScrollView:self willShowViewAtIndex:self.currentIndex];
        
        //===
        [self addToReusableViews:[self.contentViews objectAtIndex:0]];
        [self.contentViews removeObjectAtIndex:0];
        
        NSInteger willAddIndex = [self validIndex:self.currentIndex+1];
        
        CLCycleScrollViewContentView *contentView = [self.dataSource cycleScrollView:self viewAtIndex:willAddIndex];
        [self.contentViews addObject:contentView];
        NSMutableArray *tempArray = [self.reusableViewDic objectForKey:contentView.identifier];
        [tempArray removeObject:contentView];
        
        //===
        [self reLayoutSubviews];
        
    }else if (willMove == -1) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + scrollView.width, 0);
        self.currentIndex = [self validIndex:self.currentIndex-1];
        
        //===
        [self.delegate cycleScrollView:self willShowViewAtIndex:self.currentIndex];
        
        //===
        [self addToReusableViews:[self.contentViews lastObject]];
        [self.contentViews removeObjectAtIndex:self.contentViews.count-1];
        
        NSInteger willAddIndex = [self validIndex:self.currentIndex-1];
        
        CLCycleScrollViewContentView *contentView = [self.dataSource cycleScrollView:self viewAtIndex:willAddIndex];
        [self.contentViews insertObject:contentView atIndex:0];
        NSMutableArray *tempArray = [self.reusableViewDic objectForKey:contentView.identifier];
        [tempArray removeObject:contentView];
        
        //===
        [self reLayoutSubviews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    [self.autoTimer resumeTimerAfterTimeInterval:self.autoScrollDuration];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.autoTimer resumeTimerAfterTimeInterval:self.autoScrollDuration];
}

@end

@interface CLCycleScrollViewContentView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGesture;

@end

@implementation CLCycleScrollViewContentView

- (void)dealloc
{
    CLRELEASE(_identifier);
    
    CLRELEASE(_doubleTapGesture);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier
{
    if (self = [super initWithFrame:frame]) {
        self.identifier = identifier;
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 1;
        self.delegate = self;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomContentView:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        self.doubleTapGesture = doubleTap;
        [doubleTap release];
    }
    
    return self;
}

- (void)zoomContentView:(UIGestureRecognizer *)gesture
{
    if (self.maximumZoomScale == 1)
        return;
    
    CGPoint center = [gesture locationInView:gesture.view];
    CGFloat scale = (self.zoomScale == self.maximumZoomScale) ? self.minimumZoomScale : self.maximumZoomScale;
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:center];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [self.cycleScrollView.autoTimer pauseTimer];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
    
    if (scale == 1)
        [self.cycleScrollView.autoTimer resumeTimerAfterTimeInterval:self.cycleScrollView.autoScrollDuration];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *subView in self.subviews)
        return subView;
    
    return nil;
}

@end
