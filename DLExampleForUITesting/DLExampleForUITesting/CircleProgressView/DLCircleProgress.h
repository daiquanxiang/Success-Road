//
//  DLCircleProgress.h
//  footballData
//
//  Created by David on 15/12/23.
//  Copyright © 2015年 www.zuqiukong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLCircleProgress : UIView

@property (nonatomic, strong) UIColor *backgroundProgressColor;
@property (nonatomic, strong) NSDictionary *progressColorsDictionary;
@property (nonatomic, strong) UIFont  *scoreFont;

-(void) setupDefaultView;
-(void)setPercent:(NSInteger)percent animated:(BOOL)animated;
@end
