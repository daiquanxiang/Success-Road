//
//  CommentAvatarsListView.m
//  DLExampleForUITesting
//
//  Created by David on 15/11/19.
//  Copyright © 2015年 David. All rights reserved.
//

#import "CommentAvatarsListView.h"
static const CGFloat kAvatarWidth = 28.0f;
static CGFloat kLeftEdge = 12.0f;
static const CGFloat kTopEdge = 12.0f;
static const CGFloat kAvatarsDistance = 10.0f;
static const CGFloat kAvatarsSmallDistance = 3.0f;
static const CGFloat kOneAvatarNeedWidth = kAvatarsDistance+kAvatarWidth;
static const CGFloat kDuration = 0.5f;
@interface CommentAvatarsListView()
{
    NSMutableArray *_avatarsList;
    NSInteger _currentShowNumberOfAvatars;
    NSInteger _moveToCurrentIndex;
    NSInteger canShowNumberOfAvatars;
}

@end

@implementation CommentAvatarsListView

-(instancetype)initWithData:(id)data
{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSArray class]]) {
            _avatarsList = (NSMutableArray*)[data mutableCopy];
            if ([_avatarsList count]) {
                [self setupAllAvatars];
            }
        }
    }
    return self;
}

-(void) setupAllAvatars
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    canShowNumberOfAvatars = floorf(screenWidth/kOneAvatarNeedWidth);
    kLeftEdge = (screenWidth - canShowNumberOfAvatars*kOneAvatarNeedWidth+kAvatarsDistance)*0.5f;
    _currentShowNumberOfAvatars = [_avatarsList count]>canShowNumberOfAvatars ? canShowNumberOfAvatars:[_avatarsList count];
    self.frame = CGRectMake(0, 0, screenWidth, kTopEdge*2+kAvatarWidth);
    self.backgroundColor = [UIColor brownColor];
    for (NSInteger i=1; i<=_currentShowNumberOfAvatars; i++) {
        [self avatarWithTag:i];
    }
    _moveToCurrentIndex = 1;
    [self openAnimation];
}

-(id) avatarWithTag:(NSInteger) tag
{
//    id obj = [_avatarsList objectAtIndex:tag];
    CGFloat moveToDistance = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kAvatarWidth - tag*kAvatarsSmallDistance+moveToDistance, kTopEdge, kAvatarWidth, kAvatarWidth)];
//    imageView.image = [UIImage imageWithCGImage:<#(nonnull CGImageRef)#>]
    if(tag==_currentShowNumberOfAvatars && [_avatarsList count]>_currentShowNumberOfAvatars)
    {
        UILabel *omitLabel = [[UILabel alloc] initWithFrame:imageView.frame];
        omitLabel.text = @"···";
        omitLabel.textColor = [UIColor whiteColor];
        omitLabel.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        [omitLabel.layer setBorderWidth:0.0f];
        [omitLabel.layer setCornerRadius:kAvatarWidth/2.0f];
        omitLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        omitLabel.textAlignment = NSTextAlignmentCenter;
        omitLabel.layer.masksToBounds = YES;
        omitLabel.tag = tag;
        [self addSubview:omitLabel];
        [self sendSubviewToBack:omitLabel];
        return omitLabel;
    }
    imageView.tag = tag;
    imageView.backgroundColor = tag%2?[UIColor greenColor]:[UIColor redColor];
    [imageView.layer setBorderWidth: 0.0f];
    [imageView.layer setCornerRadius:kAvatarWidth/2.0f];
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [self sendSubviewToBack:imageView];
    return imageView;
}
#pragma mark - animation
-(void) openAnimation
{
    [UIView animateWithDuration:kDuration animations:^{
        UIView *view = [self viewWithTag:_moveToCurrentIndex];
        CGRect newFrame = view.frame;
        newFrame.origin.x = kLeftEdge + (_moveToCurrentIndex-1)*kOneAvatarNeedWidth;
        CGFloat needMoveDistance = newFrame.origin.x - view.frame.origin.x;
        view.frame = newFrame;
        for (NSInteger i = _moveToCurrentIndex+1; i<=_currentShowNumberOfAvatars; i++) {
            UIView *nextView = [self viewWithTag:i];
            newFrame = nextView.frame;
            newFrame.origin.x += needMoveDistance;
            nextView.frame = newFrame;
        }
    } completion:^(BOOL finished) {
        _moveToCurrentIndex++;
        if (_moveToCurrentIndex<=_currentShowNumberOfAvatars) {
            [self openAnimation];
        }
    }];
}

-(void) retractAnimation
{
    [UIView animateWithDuration:kDuration animations:^{
        for (NSInteger i = _moveToCurrentIndex; i>=1; i--) {
            UIView *nextView = [self viewWithTag:i];
            nextView.frame =  CGRectMake(-kAvatarWidth - nextView.tag*kAvatarsSmallDistance, kTopEdge, kAvatarWidth, kAvatarWidth);
        }
    } completion:^(BOOL finished) {
        _moveToCurrentIndex=1;
        [self performSelector:@selector(openAnimation) withObject:self afterDelay:kDuration];
    }];
}

-(void) insertAnimation
{
//    UIView *lastAvatar;
    UIView *avatar = [self viewWithTag:_moveToCurrentIndex];
    [UIView animateWithDuration: 0.5 animations:^{
        CGRect newFrame = avatar.frame;
        newFrame.origin.x = kLeftEdge + (_moveToCurrentIndex-1)*kOneAvatarNeedWidth;
//        CGFloat needMoveDistance = newFrame.origin.x - view.frame.origin.x;
        avatar.frame = newFrame;
        if (_moveToCurrentIndex==_currentShowNumberOfAvatars) {
            [self sendSubviewToBack:avatar];
        }
    } completion:^(BOOL finished) {
        if (_moveToCurrentIndex == _currentShowNumberOfAvatars&&[_avatarsList count]-1>_currentShowNumberOfAvatars) {
            [avatar removeFromSuperview];
            UIView *view = [self viewWithTag:_moveToCurrentIndex+1];
            view.tag = _moveToCurrentIndex;
            return ;
        }
        else if(_moveToCurrentIndex == _currentShowNumberOfAvatars&&[_avatarsList count]-1==canShowNumberOfAvatars)
        {
            UIView *lastView = [self viewWithTag:_moveToCurrentIndex+1];
            [lastView removeFromSuperview];
            UIView *omitView = [self avatarWithTag:canShowNumberOfAvatars];
            omitView.frame = avatar.frame;
            [avatar removeFromSuperview];
            return ;
        }
        _moveToCurrentIndex++;
        [self insertAnimation];
    }];
}

#pragma mark - insert new avatar
-(void) insertNewAvatar:(UIImage *)image
{
    for (NSInteger i = 1; i<=_currentShowNumberOfAvatars; i++) {
        UIView *avatar = [self viewWithTag:i];
        avatar.tag++;
    }
    UIImageView* newAvatar = [self avatarWithTag:1];
    newAvatar.backgroundColor = [UIColor blueColor];
    [self bringSubviewToFront:newAvatar];
    [_avatarsList insertObject:@"dffeoan" atIndex:0];
    _moveToCurrentIndex = 1;
    [self insertAnimation];
}
@end
