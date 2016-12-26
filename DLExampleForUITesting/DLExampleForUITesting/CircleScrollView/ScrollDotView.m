//
//  ScrollDotView.m
//  DLExampleForUITesting
//
//  Created by David on 16/12/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ScrollDotView.h"

@implementation ScrollDotView

static const CGFloat kSmallDotWidth = 6.0f;
static const CGFloat kBigDotWidth = 8.0f;
static const NSInteger kDotBeginTag = 200;
static const CGFloat kDotsDistance = 6.0f;
static const CGFloat kViewHeight = 10.0f;

-(void) setupDotViewWithPages:(NSInteger)number
{
    _numberOfPages = number;
    if (!number) {
        return;
    }
    else if (number==1 && _hidesForSinglePage) {
        self.hidden = YES;
        return;
    }
    else
    {
        self.hidden = NO;
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        for (NSInteger i=0; i<number; i++) {
            UIView *dot = [[UIView alloc] init];
            dot.tag = kDotBeginTag + i;
            dot.frame = CGRectMake((i+1)*kDotsDistance+i*kSmallDotWidth, (kViewHeight - kSmallDotWidth)/2, kSmallDotWidth, kSmallDotWidth);
            dot.backgroundColor = [UIColor whiteColor];
            [self addSubview:dot];
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:kSmallDotWidth/2];
        }
        
        CGFloat width = (kDotsDistance + kSmallDotWidth)*number + kDotsDistance;
        CGFloat screenWidth = self.superview.frame.size.width;
        CGFloat rightEdge = 2.0f;
        self.frame = CGRectMake(screenWidth - width - rightEdge, self.frame.origin.y, width, kViewHeight);
    }
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self updateDots];
}
#pragma mark - update pageControl dot size
-(void) updateDots
{
    for (int i=0; i<_numberOfPages; i++)
    {
        UIView *dot = [self viewWithTag:i+kDotBeginTag];
        CGRect frame = dot.frame;
        CGFloat width;
        if (i == _currentPage) {
            width = kBigDotWidth;
            dot.backgroundColor = _currentPageIndicatorTintColor;
        }
        else
        {
            width = kSmallDotWidth;
            dot.backgroundColor = _pageIndicatorTintColor;
        }
        dot.frame = CGRectMake(frame.origin.x+frame.size.width/2-width/2, frame.origin.y+frame.size.height/2-width/2, width, width);
        [dot.layer setCornerRadius:width/2];
    }
}

@end
