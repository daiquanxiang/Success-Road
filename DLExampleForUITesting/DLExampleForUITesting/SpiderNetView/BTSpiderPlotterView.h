//
//  ViewController.m
//  BTLibrary
//
//  Created by Byte on 5/29/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BTSpiderPlotterView : UIView

//example dictionary
/*
 @{@"Design": @"7",
 @"Display Life": @"9",
 @"Camera" : @"6",
 @"Reception": @"9",
 @"Performance" : @"8",
 @"Software": @"7",
 @"Battery Life" : @"9",
 @"Ecosystem": @"8"};
 */
- (id)initWithFrame:(CGRect)frame keyArray:(NSArray*)keyArray valueArray:(NSArray*)valueArray isDefault:(BOOL) isDefault denominator:(CGFloat) denominator maxValue:(CGFloat)maxValue;
// for two spider net view
-(id) initWithFrame:(CGRect)frame keyArray:(NSArray *)keyArray twoValues:(NSArray *)valueArray isDefault:(BOOL)isDefault denominator:(CGFloat)denominator maxValue:(CGFloat)maxValue;

@property (nonatomic, assign) CGFloat valueDivider; // default 1
@property (nonatomic, assign) CGFloat maxValue; // default to the highest value in the dictionary
@property (nonatomic, assign) CGFloat denominator; // 100%所代表的值
@property (nonatomic, strong) UIColor *drawboardColor; // defualt black
@property (nonatomic, strong) UIColor *plotColor; // default dark grey
@property (nonatomic, strong) UIFont *valueFont;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong,readonly) NSArray *anotherValue;
@property (nonatomic, strong) UIColor *anotherPlotColor; // default nil;
@property (nonatomic, strong) UIColor *anotherFillColor; 
@end
