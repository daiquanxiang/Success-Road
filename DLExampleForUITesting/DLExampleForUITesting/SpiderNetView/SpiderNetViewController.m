//
//  SpiderNetViewController.m
//  DLExampleForUITesting
//
//  Created by David on 16/2/29.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SpiderNetViewController.h"
#import "BTSpiderPlotterView.h"

@interface SpiderNetViewController()
{
    BTSpiderPlotterView *_netNoneSpiderView;
}
@end

@implementation SpiderNetViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //spider view

    CGFloat kNetSpiderViewWidth = 130.0f;
    NSDictionary *valueDictionary = @{@"射门": @"1.0",
                                      @"传球": @"2",
                                      @"盘带" : @"1.5",
                                      @"控球": @"2",
                                      @"速度" : @"1.9",
                                      @"耐力": @"1.8",
                                      @"灵敏" : @"2",
                                      @"力量": @"1.4"};
    
    _netNoneSpiderView = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(100, 200, kNetSpiderViewWidth, kNetSpiderViewWidth) keyArray:[valueDictionary allKeys] valueArray:[valueDictionary allValues] isDefault:YES denominator:3.0f maxValue:3.0f];
//    CGFloat centerX = iwidth_app - (iwidth_app - CGRectGetMaxX(_netBirthdayLabel.frame))/2;
//    _netNoneSpiderView.center = CGPointMake(centerX, kNetViewHeight/2);
    _netNoneSpiderView.plotColor = [UIColor colorWithRed:0 green:.71 blue:1 alpha:.4];
    [self.view addSubview:_netNoneSpiderView];
    
    // reset button
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:resetButton];
    resetButton.frame = CGRectMake(20, 400, 300, 44);
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) resetButtonAction:(UIButton*) button
{
    [_netNoneSpiderView removeFromSuperview];
    _netNoneSpiderView = nil;
    CGFloat kNetSpiderViewWidth = 130.0f;
    NSArray *anotherValue = @[@"2.0",
                              @"1.0",
                              @"1.5",
                              @"1.0",
                              @"1.1",
                              @"1.2",
                              @"1.0",
                              @"1.6"];
    
    NSDictionary *valueDictionary = @{@"射门": @"1.0",
                                      @"传球": @"2",
                                      @"盘带" : @"1.5",
                                      @"控球": @"2",
                                      @"速度" : @"1.9",
                                      @"耐力": @"1.8",
                                      @"灵敏" : @"2",
                                      @"力量": @"1.4"};
    NSArray *twoValues = [[NSArray alloc] initWithObjects:[valueDictionary allValues], anotherValue, nil];
    _netNoneSpiderView = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(100, 200, kNetSpiderViewWidth, kNetSpiderViewWidth) keyArray:[valueDictionary allKeys] twoValues:twoValues isDefault:YES denominator:3.0f maxValue:3.0f];
    _netNoneSpiderView.anotherPlotColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.4];
    _netNoneSpiderView.plotColor = [UIColor colorWithRed:0 green:.71 blue:1 alpha:.4];
    [self.view addSubview:_netNoneSpiderView];
}

@end
