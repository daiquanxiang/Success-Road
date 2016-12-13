//
//  MyAddViewTableView.m
//  DLExampleForUITesting
//
//  Created by David on 16/8/30.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyAddViewTableView.h"
#import "RCLabel.h"

@implementation MyAddViewTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor=[UIColor redColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupElements];
        });
    }
    return self;
}

-(void) setupElements
{
//    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    myLabel.backgroundColor = [UIColor greenColor];
//    [self addSubview:myLabel];
       RCLabel *_contentLabel = [[RCLabel alloc] initWithFrame:CGRectMake(20,100,200,600)];
        [self addSubview:_contentLabel];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    [_contentLabel setFont:[UIFont systemFontOfSize:22.f]];
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:@"<font color=#92959f>因为对方阵容不符合条件而判</font></font> <b><font color=#ff9c00>3-0</font></b>"];
    _contentLabel.componentsAndPlainText = componentsDS;
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        if (indexPath.row==0) {
            return 50.0f;
        }else if (indexPath.row==1) {
            return 161.0f;
        }
        else
            return 58.f;
    }
    else
    {
            return 62.f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.0f;
    }
    return 0.0f;
}

@end
