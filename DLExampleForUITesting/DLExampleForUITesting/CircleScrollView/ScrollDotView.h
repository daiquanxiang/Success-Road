//
//  ScrollDotView.h
//  DLExampleForUITesting
//
//  Created by David on 16/12/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollDotView : UIView
// default is 0
@property (nonatomic, assign) NSInteger numberOfPages;
// default is 0, pinned to 0... numberOfPages -1
@property (nonatomic, assign) NSInteger currentPage;
// if there is only one page. default is NO
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

-(void)setupDotViewWithPages:(NSInteger) number;
@end
