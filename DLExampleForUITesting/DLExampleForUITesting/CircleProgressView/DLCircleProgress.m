//
//  DLCircleProgress.m
//  footballData
//
//  Created by David on 15/12/23.
//  Copyright © 2015年 www.zuqiukong.com. All rights reserved.
//

#import "DLCircleProgress.h"

static const CGFloat kCircleWidth = 4.0;
static const CGFloat kLeftRightEdge = 2.0f;
static const CGFloat kAnimationDuration = 0.7f;

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

@interface DLCircleProgress()
{
    CGFloat         _width;
    CAShapeLayer    *_trackLayer;
    CAShapeLayer    *_progressLayer;
    NSInteger       _percent;
    UILabel         *_tipLabel;
    UILabel         *_scoreLabel;
    NSTimer         *_countDownTimer;
    CAGradientLayer *gradientLayer;
}

@end

@implementation DLCircleProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void) setupDefaultView
{
    _width = MAX(self.frame.size.width, self.frame.size.height)-2*kLeftRightEdge;
    if (_width<=kCircleWidth*2) {
        return;
    }
    
    _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
    _trackLayer.frame = CGRectMake(kLeftRightEdge, kLeftRightEdge, _width, _width);
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    _trackLayer.strokeColor = [_backgroundProgressColor CGColor];//指定path的渲染颜色
    _trackLayer.opacity = 0.25; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _trackLayer.lineWidth = kCircleWidth;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_width/2+kLeftRightEdge, _width/2+kLeftRightEdge) radius:(_width-kCircleWidth)/2 startAngle:degreesToRadians(-230) endAngle:degreesToRadians(50) clockwise:YES];//上面说明过了用来构建圆形
    _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = CGRectMake(kLeftRightEdge, kLeftRightEdge, _width, _width);
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor redColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = kCircleWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //tip label
    _tipLabel = [[UILabel alloc] init];
    [self addSubview:_tipLabel];
    _tipLabel.text = @"评分";
    _tipLabel.font = [UIFont systemFontOfSize:10];
    _tipLabel.textColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1];
    CGSize size = [self sizeForString:_tipLabel.text attribute:@{NSFontAttributeName:_tipLabel.font} width:MAXFLOAT];
    _tipLabel.frame = CGRectMake(_width/2.0f+kLeftRightEdge*2-size.width/2, _width-size.height, size.width, size.height);
    
    //score label
    _scoreLabel = [[UILabel alloc] init];
    [self addSubview:_scoreLabel];
    _scoreLabel.text = @"-";
    _scoreLabel.font = [UIFont boldSystemFontOfSize:18];
    _scoreLabel.textColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1];
    size = [self sizeForString:_scoreLabel.text attribute:@{NSFontAttributeName:_scoreLabel.font} width:MAXFLOAT];
    _scoreLabel.frame = CGRectMake(_width/2.0f+kLeftRightEdge*2-size.width/2, _width/2+kLeftRightEdge-size.height/2, size.width, size.height);
}

-(void)setPercent:(NSInteger)percent animated:(BOOL)animated
{
    //clean layer
    [gradientLayer removeFromSuperlayer];
    gradientLayer = nil;
    _countDownTimer = nil;

    NSArray *colors = [[NSArray alloc] init];
    for (NSString *key in [_progressColorsDictionary allKeys]) {
        if (percent>=[key integerValue]) {
            colors = [_progressColorsDictionary objectForKey:key];
        }
    }
    if (![colors count]) {
        colors = [[_progressColorsDictionary allValues] lastObject];
    }
    
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    
    gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    UIColor *firstColor = [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)([colors objectAtIndex:0])];
    UIColor *secondColor = [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)([colors objectAtIndex:1])];
    [gradientLayer1 setColors:[NSArray arrayWithObjects: (id)[firstColor CGColor],(id)[secondColor CGColor], nil]];
    [gradientLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
    gradientLayer2.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    firstColor = [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)([colors objectAtIndex:2])];
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)secondColor.CGColor,(id)firstColor.CGColor, nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [gradientLayer setBackgroundColor:secondColor.CGColor];
    [self.layer addSublayer:gradientLayer];
    
    
    _percent = percent;

//    _scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)percent];
    _scoreLabel.text = @"0";
    if (_scoreFont) {
        _scoreLabel.font = _scoreFont;
    }
    _scoreLabel.textColor = [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)([colors objectAtIndex:1])];
    CGSize size = [self sizeForString:_scoreLabel.text attribute:@{NSFontAttributeName:_scoreLabel.font} width:MAXFLOAT];
    CGRect frame = _scoreLabel.frame;
    frame.origin.x += frame.size.width/2.0 - size.width/2;
    frame.size.width = size.width;
    _scoreLabel.frame = frame;
    _progressLayer.strokeEnd = 1/100.0;
    dispatch_after(0.01, dispatch_get_main_queue(), ^{
        [self startMyAnimation];
    });
    [self beginCountDownTime];
}

-(void) startMyAnimation
{
    [CATransaction begin];
//    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:kAnimationDuration];
    _progressLayer.strokeEnd = _percent/100.0;
    [CATransaction commit];
}

- (void) beginCountDownTime
{
    if (!_countDownTimer) {
        NSTimeInterval interval = kAnimationDuration/_percent;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(countingDownTime) userInfo:nil repeats:YES];
        [_countDownTimer fire];
        [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)_percent];
        [_countDownTimer invalidate];
        CGSize size = [self sizeForString:_scoreLabel.text attribute:@{NSFontAttributeName:_scoreLabel.font} width:MAXFLOAT];
        CGRect frame = _scoreLabel.frame;
        frame.origin.x += frame.size.width/2.0 - size.width/2;
        frame.size.width = size.width;
        _scoreLabel.frame = frame;
    });
}

-(void) countingDownTime
{
    _scoreLabel.text = [NSString stringWithFormat:@"%d",[_scoreLabel.text intValue]+1];
    CGSize size = [self sizeForString:_scoreLabel.text attribute:@{NSFontAttributeName:_scoreLabel.font} width:MAXFLOAT];
    CGRect frame = _scoreLabel.frame;
    frame.origin.x += frame.size.width/2.0 - size.width/2;
    frame.size.width = size.width;
    _scoreLabel.frame = frame;
}

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
