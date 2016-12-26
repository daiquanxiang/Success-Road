//
//  NSTimer+Addition.h
//  DLExampleForUITesting
//
//  Created by David on 16/12/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
-(void) pauseTimer;
-(void) resumeTimer;
-(void) resumeTimerAfterTimeInterval:(NSTimeInterval) interval;
@end
