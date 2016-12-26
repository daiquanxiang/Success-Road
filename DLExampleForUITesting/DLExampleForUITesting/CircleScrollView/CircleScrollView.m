//
//  CircleScrollView.m
//  DLExampleForUITesting
//
//  Created by David on 16/12/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "CircleScrollView.h"
#import "ScrollDotView.h"
#import "NSTimer+Addition.h"

@interface CircleScrollView()<UIScrollViewDelegate>
{
    ScrollDotView   *_dotView;
    NSInteger       _currentPageIndex;
    NSInteger       _totalPageCount;
    NSMutableArray  *_contentViews;
    NSTimer         *_animationTimer;
    NSTimeInterval  _animationDuration;
}
@end

@implementation CircleScrollView

-(void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount) {
        [self configContentViews];
        [_animationTimer resumeTimerAfterTimeInterval:_animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration>0.0) {
        _animationTimer = [NSTimer
                           scheduledTimerWithTimeInterval:(_animationDuration = animationDuration)
                           target:self
                           selector:@selector(animationTimerDidFired:)
                           userInfo:nil
                           repeats:YES];
        [_animationTimer pauseTimer];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake(5*CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        _currentPageIndex = 0;
        
        _dotView = [[ScrollDotView alloc] init];
        _dotView.hidesForSinglePage = YES;
        _dotView.currentPageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0.9f];
        _dotView.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0.6f];
        _dotView.frame = CGRectMake(0, frame.size.height - 20.f, 0, 0);
        [self addSubview:_dotView];
    }
    return self;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_animationTimer resumeTimerAfterTimeInterval:_animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
        _dotView.currentPage = _currentPageIndex;
        //        NSLog(@"next，当前页:%d",self.currentPageIndex);
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
        _dotView.currentPage = _currentPageIndex;
        //        NSLog(@"previous，当前页:%d",self.currentPageIndex);
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}


#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    if (_totalPageCount>1) {
        NSInteger currentPage = floor(_scrollView.contentOffset.x/CGRectGetWidth(_scrollView.frame));
        CGPoint newOffset = CGPointMake((currentPage+1)*CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y);
        [_scrollView setContentOffset:newOffset animated:YES];
    }
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(_currentPageIndex);
    }
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in _contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(_scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [_scrollView addSubview:contentView];
    }
    if (counter>1) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        _scrollView.scrollEnabled=YES;
    }else{
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        _scrollView.scrollEnabled=NO;
    }
    
    
    
    if (!_dotView||_dotView.numberOfPages != _totalPageCount) {
        [_dotView setupDotViewWithPages:_totalPageCount];
        _dotView.currentPage = 0;
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */

- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
    if (!_contentViews) {
        _contentViews = [@[] mutableCopy];
    }
    [_contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        if (_totalPageCount==1) {
            if (self.fetchContentViewAtIndex(_currentPageIndex)) {
                [_contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
            }
        }else {
            if (self.fetchContentViewAtIndex(previousPageIndex)) {
                [_contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
            }
            
            if (self.fetchContentViewAtIndex(_currentPageIndex)) {
                [_contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
            }
            
            if (self.fetchContentViewAtIndex(rearPageIndex)) {
                UIView *imageView = self.fetchContentViewAtIndex(rearPageIndex);
                BOOL needCopyView = NO;
                for (UIView *view in _contentViews) {
                    if ([view isEqual:imageView]) {
                        needCopyView = YES;
                        break;
                    }
                }
                [_contentViews addObject:needCopyView?[self duplicate:imageView]:imageView];
            }
        }
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if (currentPageIndex<0&&_totalPageCount!=1) {
        return currentPageIndex%_totalPageCount + _totalPageCount;
    }
    else
        return currentPageIndex%_totalPageCount;
}

- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

-(void)dealloc
{
    [_animationTimer invalidate];
    _animationTimer = nil;
}


@end
