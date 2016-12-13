//
//  TranslucentView.m
//  DLExampleForUITesting
//
//  Created by David on 15/11/18.
//  Copyright © 2015年 David. All rights reserved.
//

#import "TranslucentView.h"

@implementation TranslucentView

- (void) drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor *startColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];//[UIColor orangeColor];
    CGFloat *startColorComponents = (CGFloat *)CGColorGetComponents([startColor CGColor]);
    UIColor *endColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    CGFloat *endColorComponents = (CGFloat *)CGColorGetComponents([endColor CGColor]);
    CGFloat colorComponents[8] = {
        //four orange color
        startColorComponents[0],
        startColorComponents[1],
        startColorComponents[2],
        startColorComponents[3],
        
        //four blue color
        endColorComponents[0],
        endColorComponents[1],
        endColorComponents[2],
        endColorComponents[3],
    };
    
    CGFloat colorIndices[2] = {
        0.0f,//color 0 in the colorComponents array
        1.0f,//color 1 in the colorComponents array
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, (const CGFloat *)&colorComponents, (const CGFloat *)&colorIndices, 2);
    
    CGColorSpaceRelease(colorSpace);
    CGPoint startPoint, endPoint;
    startPoint = CGPointMake(200, 220);
    endPoint = CGPointMake(300, 220);
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGContextRestoreGState(currentContext);
}

@end
