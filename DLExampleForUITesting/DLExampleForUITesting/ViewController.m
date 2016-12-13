//
//  ViewController.m
//  DLExampleForUITesting
//
//  Created by David on 15/9/20.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "TranslucentView.h"
#import "CommentAvatarsListView.h"
#import "SCGIFImageView.h"

#import "UIButton+MyObserver.h"
#import "MyAddViewTableView.h"

@interface ViewController ()<UITextFieldDelegate>
{
    UIViewController *redViewController;
    UITextField *_textField;
    UIImageView *_headImageView;
    UIImageView *_headEffectImageView;
    UIImageView *_pmainPicture;
    CommentAvatarsListView *commentAvatarsListView;
    SCGIFImageView *img;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.accessibilityIdentifier = @"myViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // textField
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(150, 100, 100, 20)];
    _textField.placeholder = @"write something";
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
    //switch
    _pSwitch = [[UISwitch alloc] init];
    _pButton.frame = CGRectMake(0, 0, 200, 44);
    _pSwitch.center = self.view.center;
    _pSwitch.accessibilityIdentifier = @"mySwitch";
    [self.view addSubview: _pSwitch];
    // image view
    _pmainPicture=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 190.0f)];
//    _pmainPicture.image=[UIImage imageNamed:@"footballfield.jpg"];
    _pmainPicture.backgroundColor = [UIColor redColor];
    _pmainPicture.contentMode = UIViewContentModeScaleAspectFill;
    _pmainPicture.userInteractionEnabled = YES;
    [self.view addSubview:_pmainPicture];
  
    
    //button
    _pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pButton setTitle: @"请点击" forState: UIControlStateNormal];
    _pButton.frame = CGRectMake(_pSwitch.frame.origin.x, _pSwitch.frame.origin.y+100, 200, 44);
    _pButton.backgroundColor = [UIColor blueColor];
    [_pButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [_pButton addTarget: self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _pButton.accessibilityIdentifier = @"myButton";
    [self.view addSubview: _pButton];
    
    // 头像
    _headImageView = [[UIImageView alloc] init];
    _headImageView.backgroundColor = [UIColor blueColor];
    _headImageView.frame = CGRectMake(0, 100, 100, 100);
//    _headImageView.layer.cornerRadius = 50.0;
//    _headImageView.layer.borderWidth = 1.0;
//    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    _headImageView.layer.masksToBounds = YES;
//    _headImageView.backgroundColor = [UIColor redColor];
//    _headImageView.image = [UIImage imageNamed:@"header.jpg"];
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.view addSubview:bgView];
    [self.view addSubview:_headImageView];
    
    // 模糊化头像
//    _headEffectImageView = [[UIImageView alloc] init];
//    _headEffectImageView.frame = CGRectMake(0, 0, 100, 100);
//    [_pmainPicture addSubview:_headEffectImageView];
    
    
    // label
    UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 44)];
    label.text = @"djkajldklfaj kdjfk sd ";
    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview: label];

    
    UIButton *button = [[UIButton alloc] initWithFrame:_headImageView.frame];
    [self.view addSubview: button];
    
//    TranslucentView *translucentView = [[TranslucentView alloc] initWithFrame:CGRectMake(0, 500, self.view.frame.size.width, 100)];
//    translucentView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:translucentView];
    
    //头像列表
//    commentAvatarsListView = [[CommentAvatarsListView alloc]
//                                                      initWithData:@[@"a",
//                                                                     @"y",
//                                                                     @"77d",
//                                                                     @"q",
//                                                                     @"c",
//                                                                     @"dad",
//                                                                     @"eeee",
//                                                                     @"llsdl",
//                                                                     @"ddddddada",
//                                                                     @"dallll"]];
//    CGRect newFrame = commentAvatarsListView.frame;
//    newFrame.origin.y = 400.0f;
//    commentAvatarsListView.frame = newFrame;
//    [self.view addSubview:commentAvatarsListView];
    
    MyAddViewTableView *tableView = [[MyAddViewTableView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    [self.view addSubview:tableView];
}


//int CDownloadThread::getProxyPort()
//{
//    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
//    const CFNumberRef portCFnum = (const CFNumberRef)CFDictionaryGetValue(dicRef, (const void*)kCFNetworkProxiesHTTPPort);
//    
//    SInt32 port;
//    if (CFNumberGetValue(portCFnum, kCFNumberSInt32Type, &port))
//    {
//        return port;
//    }
//    return -1;
//}

-(void) getWifiHttpProxy
{
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    const CFNumberRef portCFnum = (const CFNumberRef)CFDictionaryGetValue(dicRef, (const void*) kCFNetworkProxiesHTTPPort);
    SInt32 port;
    if (CFNumberGetValue(portCFnum, kCFNumberSInt32Type, &port))
    {
        NSLog(@"%d",port);
    }
}

-(void) buttonAction:(UIButton*) button
{

    
//    [commentAvatarsListView retractAnimation];
//    [commentAvatarsListView insertNewAvatar:nil];
    
//    SCGIFImageView
//    http://183.61.239.16/mmsns/fdwC9AxOLyibDgm0icVmxEyicQZPogAbEHdkUSpRuqjbOicMEgR1nflQ2puicnlE1bmAe9ficuURrwCSw/0?tp=webp&length=1334&width=750
    //Play gif
//    if (!img) {
//        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"挥旗公仔1-02.gif" ofType:nil];
//        NSData* imageData = [NSData dataWithContentsOfFile:filePath];
//        img = [[SCGIFImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-162/1.5)/2, (CGRectGetHeight(self.view.frame)-188)/2, 600/2.0f, 366.0/2)];
//        img.backgroundColor = [UIColor clearColor];
////        [img setData:imageData];
//        [self.view addSubview:img];
//        img.animating = NO;
//    }
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 耗时的数据处理等
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://183.61.239.16/mmsns/fdwC9AxOLyibDgm0icVmxEyicQZPogAbEHdkUSpRuqjbOicMEgR1nflQ2puicnlE1bmAe9ficuURrwCSw/0?tp=webp&length=1334&width=750"]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新UI
//            [img setData:data];
////            [self showTrickWithType:type imageView:trickImageView];
//        });
//    });
//    
//    img.animating = !img.animating;

    
    
    if (!_pSwitch.on)
    {
        NSString *message = @"good";
        if (_textField.text.length) {
            message = _textField.text;
        }
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"warn" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"算了算了" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        UIAlertAction* rightAction = [UIAlertAction actionWithTitle:@"好的算了" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
//        NSNumber *num = [[NSNumber alloc] initWithInt:2];
//        [num integerValue];
        
        [alertView addAction:defaultAction];
        [alertView addAction:rightAction];
        [self presentViewController:alertView animated:YES completion:nil];
        return;
    }
    
    [self rotate360WithDuration:2.0 repeatCount:1];
    _headImageView.backgroundColor = [UIColor redColor];
    _headImageView.animationDuration = 2.0;
//    _homeLogoView.animationImages = [NSArray arrayWithObjects:_homeLogoView.image,
//                                     _homeLogoView.image,_homeLogoView.image,
//                                     _homeLogoView.image,_homeLogoView.image,
//                                     _homeLogoView.image, nil];
    _headImageView.animationRepeatCount = 1;
    [_headImageView startAnimating];
    
    // 淡化
//    UIImage *image = [self rn_boxblurImageWithBlur:0.5 exclusionPath:nil];
//    CGFloat scale = 1.2f;
//    NSData *data = UIImagePNGRepresentation(image);
//    _headEffectImageView.image = [UIImage imageWithData:data scale:scale];
//    CGRect frame = CGRectMake(0, 0, _headImageView.frame.size.width*scale, _headImageView.frame.size.height*scale);
//
//    [UIView beginAnimations: @"cross dissolve" context: NULL];
//    [UIView setAnimationDuration: 1.0f];
//    _headEffectImageView.frame = frame;
//    _headEffectImageView.center = _headImageView.center;
//    _headImageView.alpha = 0.0f;
//    _headEffectImageView.alpha = 0.0f;
//    _headImageView.hidden = YES;
//    [UIView commitAnimations];

    
//    _headEffectImageView.image = [self rn_boxblurImageWithBlur:0.9 exclusionPath:nil];
//    _headEffectImageView.alpha = 0.5f;
    
//    redViewController = [[UIViewController alloc] init];
//    redViewController.view.backgroundColor = [UIColor redColor];
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setTitle: @"back" forState: UIControlStateNormal];
//    backButton.frame = _pSwitch.frame;
//    backButton.backgroundColor = [UIColor blueColor];
//    [backButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
//    [backButton addTarget: self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [redViewController.view addSubview: backButton];
//    [self presentViewController: redViewController animated:YES completion:^{
//        ;
//    }];
}

- (void)rotate360WithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0,1,0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0,1,0)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.duration = aDuration;
    theAnimation.repeatCount = aRepeatCount;
    theAnimation.removedOnCompletion = YES;
    
    [_headImageView.layer addAnimation:theAnimation forKey:@"transform"];
}

-(void) backAction:(UIButton*) button
{
    [redViewController dismissViewControllerAnimated: YES completion:^{
        ;
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIImage *)rn_boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = _headImageView.image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    // create unchanged copy of the area inside the exclusionPath
    UIImage *unblurredImage = nil;
    if (exclusionPath != nil) {
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = (CGRect){CGPointZero, _headImageView.image.size};
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.path = exclusionPath.CGPath;
        
        // create grayscale image to mask context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(nil, maskLayer.bounds.size.width, maskLayer.bounds.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        [maskLayer renderInContext:context];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *maskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        
        UIGraphicsBeginImageContext(_headImageView.image.size);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextClipToMask(context, maskLayer.bounds, maskImage.CGImage);
        CGContextDrawImage(context, maskLayer.bounds, _headImageView.image.CGImage);
        unblurredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    // overlay images?
    if (unblurredImage != nil) {
        UIGraphicsBeginImageContext(returnImage.size);
        [returnImage drawAtPoint:CGPointZero];
        [unblurredImage drawAtPoint:CGPointZero];
        
        returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
