//
//  CommentAvatarsListView.h
//  DLExampleForUITesting
//
//  Created by David on 15/11/19.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentAvatarsListView : UIView

-(instancetype) initWithData:(id)data;
-(void) retractAnimation;
-(void) insertNewAvatar:(UIImage*)image;

@end
