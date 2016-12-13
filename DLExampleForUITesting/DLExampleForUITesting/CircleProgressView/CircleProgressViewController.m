//
//  CircleProgressViewController.m
//  DLExampleForUITesting
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "CircleProgressViewController.h"
#import "DLCircleProgress.h"

@interface CircleProgressViewController()<UITextFieldDelegate>
{
    DLCircleProgress *_netScoreView;
    UITextField      *_numberTextField;
}

@end

@implementation CircleProgressViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    _netScoreView = [[DLCircleProgress alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _netScoreView.backgroundProgressColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0f];
    _netScoreView.progressColorsDictionary = @{
                                               @"0":@[(id)[[UIColor colorWithRed:0.2 green:0.2 blue:0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0.5 green:0.2 blue:0 alpha:1.0] CGColor],(id)[UIColor colorWithRed:0.9 green:0.2 blue:0 alpha:1.0].CGColor],
                                               @"75":@[(id)[[UIColor colorWithRed:0.0 green:0.2 blue:0.2 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0.0 green:0.5 blue:0.2 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0.0 green:0.9 blue:0.2 alpha:1.0] CGColor]],
                                               @"86":@[(id)[[UIColor colorWithRed:0.2 green:0.0 blue:0.2 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0.2 green:0.0 blue:0.5 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0.2 green:0.0 blue:0.9 alpha:1.0] CGColor]]
                                               };
    [_netScoreView setupDefaultView];
    _netScoreView.scoreFont = [UIFont boldSystemFontOfSize:30.f];
    [_netScoreView setPercent:99 animated:YES];
    
    [self.view addSubview:_netScoreView];
    
    // text field
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_netScoreView.frame)+50, 200, 30.0f)];
    [self.view addSubview:_numberTextField];
    _numberTextField.placeholder = @"请填入0~100的数";
    _numberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _numberTextField.delegate = self;
}

#pragma mark - textField delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSString *valueText = textField.text;
    CGFloat doubleValue = [valueText doubleValue];
    
    if (doubleValue<0) {
        doubleValue = 0;
    }
    else if (doubleValue>100)
        doubleValue = 99;
    [_numberTextField resignFirstResponder];
    [_netScoreView setPercent:0 animated:NO];
    [_netScoreView setPercent:doubleValue animated:YES];
    return YES;
}

@end
