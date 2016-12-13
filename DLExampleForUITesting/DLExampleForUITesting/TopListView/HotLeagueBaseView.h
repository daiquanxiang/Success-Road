//
//  HotLeagueBaseView.h
//  footballData
//
//  Created by David on 16/1/13.
//  Copyright © 2016年 www.zuqiukong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HotLeagueBaseView : UIView
@property (nonatomic,weak)  id parentViewController;
@property (nonatomic,strong,readonly) UITableView *currentTableView;
@property (nonatomic,strong) NSString *seasonYear;
@property (nonatomic,strong) UIView *playerView;
-(void) setupViewElements;
-(void) updateWithData:(id) data;
@end
