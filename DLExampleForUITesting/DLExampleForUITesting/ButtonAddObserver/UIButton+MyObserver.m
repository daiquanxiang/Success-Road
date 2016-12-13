//
//  UIButton+MyObserver.m
//  DLExampleForUITesting
//
//  Created by David on 16/5/29.
//  Copyright © 2016年 David. All rights reserved.
//

#import "UIButton+MyObserver.h"

@implementation UIButton (MyObserver)

-(instancetype)init
{
    self=[super init];
    if (self) {
        [self addMyObserver];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMyObserver];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addMyObserver];
    }
    return self;
}

-(void) addMyObserver
{
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"])
    {
        if (self.highlighted) {
            NSLog(@"yes");
            UIViewController *viewController = [self viewController];
            NSString *controllerName = NSStringFromClass([viewController class]);
            NSLog(@"%@####%@",viewController,controllerName);
        }
        else
            NSLog([NSString stringWithFormat:@"my button selected,%@",self.titleLabel.text]);
    }
}

-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

-(void) dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}


@end
