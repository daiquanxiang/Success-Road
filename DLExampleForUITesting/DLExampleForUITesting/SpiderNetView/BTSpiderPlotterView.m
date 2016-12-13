//
//  ViewController.m
//  BTLibrary
//
//  Created by Byte on 5/29/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#import "BTSpiderPlotterView.h"
static const NSInteger kRealValueBeginTag = 200;
static const NSInteger kSecondValueBeginTag = 300;
@implementation BTSpiderPlotterView{
    //Value and key
    NSArray *_keyArray;
    NSArray *_valueArray;
    CGFloat _centerX;
    CGFloat _centerY;
    	
    //Plotting and UI Array
    NSMutableArray *_pointsLengthArrayArray;
    NSMutableArray *_pointsToPlotArray;
    CGFloat _denominator;
    
    BOOL _isFirstShowDot;
    CALayer *_fillLayer;
    //second net
    BOOL _isTwoNet;
    NSMutableArray *_anotherPointsToPlotArray;
    CALayer *_secondFillLayer;
}
// only one spider net
-(id) initWithFrame:(CGRect)frame keyArray:(NSArray *)keyArray valueArray:(NSArray *)valueArray isDefault:(BOOL)isDefault denominator:(CGFloat)denominator maxValue:(CGFloat)maxValue
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        //Private iVar
        _keyArray = [NSArray array];
        _valueArray = [NSArray array];
        _keyArray = keyArray;
        _valueArray = valueArray;
        _pointsLengthArrayArray = [NSMutableArray array];
        _pointsToPlotArray = [NSMutableArray array];
        _isDefault = isDefault;
        _isFirstShowDot = YES;
        _isTwoNet = NO;
        //Public iVar
        _maxValue = maxValue;
        _denominator = denominator;
        _valueDivider = 1;
        _drawboardColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
        
        [self calculateAllPoints];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame keyArray:(NSArray *)keyArray twoValues:(NSArray *)valueArray isDefault:(BOOL)isDefault denominator:(CGFloat)denominator maxValue:(CGFloat)maxValue
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        //Private iVar
        _keyArray = [NSArray array];
        _valueArray = [NSArray array];
        _anotherValue = [NSArray array];
        _keyArray = keyArray;
        _valueArray = [valueArray objectAtIndex:0];
        _anotherValue = [valueArray objectAtIndex:1];
        _pointsLengthArrayArray = [NSMutableArray array];
        _pointsToPlotArray = [NSMutableArray array];
        _anotherPointsToPlotArray = [NSMutableArray array];
        _isDefault = isDefault;
        _isFirstShowDot = YES;
        _isTwoNet = YES;
        //Public iVar
        _maxValue = maxValue;
        _denominator = denominator;
        _valueDivider = 1;
        _drawboardColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
        
        [self calculateAllPoints];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    // circles
    for (NSArray *pointArray in _pointsLengthArrayArray) {
        if (![pointArray count]) {
            return;
        }
        //plot background
        CGContextRef graphContext = UIGraphicsGetCurrentContext();
        CGContextBeginPath(graphContext);
        CGPoint beginPoint = [[pointArray objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(graphContext, beginPoint.x, beginPoint.y);
        for (NSValue* pointValue in pointArray){
            CGPoint point = [pointValue CGPointValue];
            CGContextAddLineToPoint(graphContext, point.x, point.y);
        }
        CGContextAddLineToPoint(graphContext, beginPoint.x, beginPoint.y);
        CGContextSetStrokeColorWithColor(graphContext, _drawboardColor.CGColor);
        CGContextSetLineWidth(graphContext, 0.5f);
        CGContextStrokePath(graphContext);
    }
    
    // cuts
    NSArray *largestPointArray = [_pointsLengthArrayArray lastObject];
    for (NSValue* pointValue in largestPointArray){
        CGContextRef graphContext = UIGraphicsGetCurrentContext();
        CGContextBeginPath(graphContext);
        CGContextMoveToPoint(graphContext, _centerX, _centerY);
        CGPoint point = [pointValue CGPointValue];
        CGContextAddLineToPoint(graphContext, point.x, point.y);
        CGContextSetStrokeColorWithColor(graphContext, _drawboardColor.CGColor);
        CGContextSetLineWidth(graphContext, 0.5f);
        CGContextStrokePath(graphContext);
    }
    
    // plot 
    if (_isDefault) {

        _fillLayer = [[CALayer alloc] init];
        _fillLayer.backgroundColor = [_plotColor CGColor];
        CAShapeLayer *lineLayer = [self drawNetDetailForLayer:_fillLayer withPlotArray:_pointsToPlotArray isLeft:YES];
        
        // second net
        CAShapeLayer *secondLineLayer = nil;
        if (_isTwoNet) {
            _secondFillLayer = [[CALayer alloc] init];
            _secondFillLayer.backgroundColor = [_anotherPlotColor CGColor];
            secondLineLayer = [self drawNetDetailForLayer:_secondFillLayer withPlotArray:_anotherPointsToPlotArray isLeft:NO];
        }
        
        if (_isFirstShowDot) {
            //dot
            for (NSValue* pointValue in _pointsToPlotArray){
                CGPoint point = [pointValue CGPointValue];
                [self dotAtPoint:point isLeft:YES];
            }
            if (_isTwoNet) {
                for (NSValue* pointValue in _anotherPointsToPlotArray){
                    CGPoint point = [pointValue CGPointValue];
                    [self dotAtPoint:point isLeft:NO];
                }
            }
            
            [CATransaction begin];
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
            scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
            scaleAnimation.duration = 1.1;
            scaleAnimation.cumulative = NO;
            scaleAnimation.repeatCount = 1;
            [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            [_fillLayer addAnimation: scaleAnimation forKey:@"myScale"];
            [lineLayer addAnimation:scaleAnimation forKey:@"myScaleTwo"];
            if (_isTwoNet) {
                [_secondFillLayer addAnimation: scaleAnimation forKey:@"myScale"];
                [secondLineLayer addAnimation:scaleAnimation forKey:@"myScaleTwo"];
            }
            [CATransaction commit];
            _isFirstShowDot = NO;
        }
    }
    
}

-(CAShapeLayer*) drawNetDetailForLayer:(CALayer*) layer withPlotArray:(NSMutableArray*)plotArray isLeft:(BOOL) isLeft
{
    layer.frame = self.bounds;
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.frame = self.bounds;
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = self.bounds;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint beginPoint = [[plotArray objectAtIndex:0] CGPointValue];
    CGPathMoveToPoint(path, nil, beginPoint.x, beginPoint.y);
    for (NSValue* pointValue in plotArray){
        CGPoint point = [pointValue CGPointValue];
        CGPathAddLineToPoint(path, nil, point.x, point.y);
    }
    CGPathAddLineToPoint(path, nil, beginPoint.x, beginPoint.y);
    CGPathCloseSubpath(path);
    
    mask.path = path;
    lineLayer.path = path;
    lineLayer.fillColor = nil;
    lineLayer.opacity = 1.0;
    UIColor *strokeColor = isLeft?[_plotColor colorWithAlphaComponent:1]:[_anotherPlotColor colorWithAlphaComponent:1];
//    [_plotColor colorWithAlphaComponent:1]
    lineLayer.strokeColor = [strokeColor CGColor];
    
    CGPathRelease(path);
    layer.mask = mask;
    [self.layer addSublayer:layer];
    [self.layer addSublayer:lineLayer];
    return lineLayer;
}

-(void) labelAtPoint:(CGPoint) point value:(NSString*) valueString tag:(NSInteger)tag angle:(NSNumber*) angle isSecondNet:(BOOL) isSecond
{
    UILabel *label = (UILabel*)[self viewWithTag:tag+(isSecond? kSecondValueBeginTag:kRealValueBeginTag)];
    if (!label) {
        label = [[UILabel alloc] init];
        [self addSubview:label];
    }
    label.tag = tag+(isSecond? kSecondValueBeginTag:kRealValueBeginTag);
    if (_valueFont) {
        label.font = _valueFont;
    }
    else
        label.font = [UIFont systemFontOfSize:8.0f];
    
    label.text = [NSString stringWithFormat:@"%@",valueString];
    label.textAlignment = NSTextAlignmentCenter;
    UIColor *textColor = isSecond?[_anotherPlotColor colorWithAlphaComponent:0.5f]:[_plotColor colorWithAlphaComponent:0.5f];
    label.textColor = textColor;
    CGSize size = [self sizeForString:label.text attribute:@{NSFontAttributeName:label.font} width:MAXFLOAT];
    CGFloat length =10;
    CGFloat myAngle = [angle floatValue];
    point.x = point.x + length*cos(myAngle);
    point.y = point.y + length*sin(myAngle);
    label.frame = CGRectMake(point.x-size.width/2, point.y-size.height/2, size.width, size.height);
}

-(void) dotAtPoint:(CGPoint) point isLeft:(BOOL) isLeft
{
    CGFloat dotWidth = 3.0f;
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    UIColor *strokeColor = isLeft?[_plotColor colorWithAlphaComponent:1]:[_anotherPlotColor colorWithAlphaComponent:1];
    circleLayer.fillColor = strokeColor.CGColor;
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    [circleLayer setStrokeColor:strokeColor.CGColor];
    [circleLayer setLineWidth:0.5f];
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.x - dotWidth/2, point.y - dotWidth/2, dotWidth, dotWidth));
    circleLayer.path = circlePath;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer addSublayer:circleLayer];
        CGMutablePathRef centerPath = CGPathCreateMutable();
        CGPathAddEllipseInRect(centerPath, NULL, CGRectMake(self.bounds.size.width/2 - dotWidth/2, self.bounds.size.height/2 - dotWidth/2, dotWidth, dotWidth));
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"path"];
        animation.fromValue = (__bridge id)centerPath ;
        animation.toValue = (__bridge id)circlePath;
        animation.duration = 1.0;
        animation.cumulative = NO;
        animation.repeatCount = 1;
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [circleLayer addAnimation: animation forKey:@"myPath"];
        [CATransaction commit];
        CGPathRelease(centerPath);
        CGPathRelease(circlePath);
    });
}

#pragma mark - Main Function
- (void)calculateAllPoints
{
    [_pointsLengthArrayArray removeAllObjects];
    [_pointsToPlotArray removeAllObjects];
    if (_isTwoNet)
        [_anotherPointsToPlotArray removeAllObjects];
    
    //init Angle, Key and Value
    NSArray *angleArray = [self getAngleArrayFromNumberOfSection:(int)[_keyArray count]];
    
    //Calculate all the lengths
    CGFloat boundWidth = self.bounds.size.width;
    CGFloat boundHeight =  self.bounds.size.height;
    _centerX = boundWidth/2;
    _centerY = boundHeight/2;
    CGFloat maxLength = MIN(boundWidth, boundHeight) * 17/40;
    int plotCircles = (_maxValue/_valueDivider);
    CGFloat lengthUnit = maxLength/plotCircles;
    NSArray *lengthArray = [self getLengthArrayWithLengthUnit:lengthUnit maxLength:maxLength];
    
    //get all the points and plot
    for (NSNumber *lengthNumber in lengthArray) {
        CGFloat length = [lengthNumber floatValue];
        [_pointsLengthArrayArray addObject:[self getPlotPointWithLength:length angleArray:angleArray]];
    }
    
    int section = 0;
    for (id value in _valueArray) {
        CGFloat valueFloat = [value floatValue]/_denominator*_maxValue;
        if (valueFloat > _maxValue) {
            NSLog(@"ERROR - Value number is higher than max value - value: %f - maxValue: %f", valueFloat, _maxValue);
            return;
        }
        
        CGFloat length = valueFloat/_maxValue * maxLength;
        CGFloat angle = [[angleArray objectAtIndex:section] floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [_pointsToPlotArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        section++;
    }
    section = 0;
    for (id value in _anotherValue) {
        CGFloat valueFloat = [value floatValue]/_denominator*_maxValue;
        if (valueFloat > _maxValue) {
            NSLog(@"ERROR - Value number is higher than max value - value: %f - maxValue: %f", valueFloat, _maxValue);
            return;
        }
        
        CGFloat length = valueFloat/_maxValue * maxLength;
        CGFloat angle = [[angleArray objectAtIndex:section] floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [_anotherPointsToPlotArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        section++;
    }
    
    if (!_isDefault) {
        return;
    }
    
    //label
    [self drawLabelWithMaxLength:maxLength labelArray:_keyArray angleArray:angleArray];
    
    for (int i=0; i<[_pointsToPlotArray count]; i++) {
         CGPoint point = [[_pointsToPlotArray objectAtIndex:i] CGPointValue];
        [self labelAtPoint:point value:[_valueArray objectAtIndex:i] tag:i angle:[angleArray objectAtIndex:i] isSecondNet:NO];
    }
    for (int j=0; j<[_anotherPointsToPlotArray count]; j++) {
        CGPoint point = [[_anotherPointsToPlotArray objectAtIndex:j] CGPointValue];
        [self labelAtPoint:point value:[_anotherValue objectAtIndex:j] tag:j angle:[angleArray objectAtIndex:j] isSecondNet:YES];
    }
}

#pragma mark - Helper Function
- (NSArray *)getAngleArrayFromNumberOfSection:(int)numberOfSection
{
    NSMutableArray *angleArray = [NSMutableArray array];
    for (int section = 0; section < numberOfSection; section++) {
        [angleArray addObject:[NSNumber numberWithFloat:(float)section/(float)[_keyArray count] * 2*M_PI]];
    }
    return angleArray;
}

- (NSArray *)getLengthArrayWithLengthUnit:(CGFloat)lengthUnit maxLength:(CGFloat)maxLength
{
    NSMutableArray *lengthArray = [NSMutableArray array];
    for (CGFloat length = lengthUnit; length <= maxLength; length += lengthUnit) {
        [lengthArray addObject:[NSNumber numberWithFloat:length]];
    }
    return lengthArray;
}

- (NSArray *)getPlotPointWithLength:(CGFloat)length angleArray:(NSArray *)angleArray
{
    NSMutableArray *pointArray = [NSMutableArray array];
    //each length find the point
    for (NSNumber *angleNumber in angleArray) {
        CGFloat angle = [angleNumber floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    //store
    return pointArray;
}

- (void)drawLabelWithMaxLength:(CGFloat)maxLength labelArray:(NSArray *)labelArray angleArray:(NSArray *)angleArray
{
    int labelTag = 921;
    maxLength = 65;
    while (true) {
        UIView *label = [self viewWithTag:labelTag];
        if (!label) break;
        [label removeFromSuperview];
    }
    
    int section = 0;
    CGFloat fontSize = 13;
    CGFloat labelLength = maxLength + maxLength/10+3;
    for (NSString *labelString in labelArray) {
        CGFloat angle = [[angleArray objectAtIndex:section] floatValue];
        CGFloat x = _centerX + labelLength*cos(angle);
        CGFloat y = _centerY + labelLength*sin(angle);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x - 5*fontSize/2+20, y - fontSize/2, 5*fontSize, fontSize)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:fontSize];
//        label.transform = CGAffineTransformMakeRotation(((float)section/[labelArray count]) *
//                                                        (2*M_PI) + M_PI_2);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
        label.text = labelString;
        label.tag = labelTag;
        [label sizeToFit];
        [self addSubview: label];
        
        section++;
    }
}

#pragma mark - setters
- (void)setValueDivider:(CGFloat)valueDivider
{
    _valueDivider = valueDivider;
    [self calculateAllPoints];
    [self setNeedsDisplay];
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self calculateAllPoints];
    [self setNeedsDisplay];
}

- (void)setDrawboardColor:(UIColor *)drawboardColor
{
    _drawboardColor = drawboardColor;
    [self calculateAllPoints];
    [self setNeedsDisplay];
}

- (void)setPlotColor:(UIColor *)plotColor
{
    _plotColor = plotColor;
    [self calculateAllPoints];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_keyArray) {
        [self calculateAllPoints];
        [self setNeedsDisplay];
    }
}

-(void) setValueFont:(UIFont *)valueFont
{
    for (int i=0; i<[_keyArray count]; i++) {
        UILabel *label = (UILabel*)[self viewWithTag:i+kRealValueBeginTag];
        if (label&&valueFont) {
            label.font = valueFont;
            _valueFont = valueFont;
        }
    }
}

#pragma mark - tool
-(CGSize) sizeForString:(NSString*)string attribute:(NSDictionary*) attribute width:(CGFloat)width
{
    CGRect newFrame = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attribute
                                           context:nil];
    newFrame.size.height = ceil(newFrame.size.height);
    return newFrame.size;
}

@end
