//
//  DragCardView.m
//  DLExampleForUITesting
//
//  Created by David on 16/12/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DragCardView.h"

static const CGFloat kLogoTopEdge = 10.f;
static const CGFloat kNameBottomEdge = 8.f;
static const CGFloat kNameRightEdge = 5.f;
static const CGFloat kMainLogoWidthHeight = 18.f;
static const CGFloat kMainLogoBorderWidth = 2.f;
static const CGFloat kSelfCorner = 4.f;
static const CGFloat kNormalBorderWidth = 0.5;
static const CGFloat kSelectBorderWidth = 2.f;
static const CGFloat kDeleteLogoWidthHeight = 24.f;
static const CGFloat kOutBorderEdge = 6.f;
static const CGFloat kDeleteButtonWidthHeight = 40.f;
static const NSInteger kDeleteButtonTagBiggerThanFullButton = 10000;

static NSString* const kFavourPositionKey = @"favourPosition";
@interface DragCardView()
{
    UIButton        *_deleteButton;
    UIImageView     *_teamLogo;
    UILabel         *_teamNameLabel;
    UILabel         *_mainTeamLabel;
    UIView          *_mainTeamBackView;
    NSDictionary    *_teamDictionary;
    UIView          *_markView;
    UILabel         *_moveTipLabel;
    NSString        *_teamId;
    NSString        *_teamType;
    UIImageView     *_deleteLogo;
    CGPoint         _location;
    BOOL            _isShaking;
}
@end


@implementation DragCardView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupElements];
    }
    return self;
}

-(void) setupElements
{
    // drag view
    if (!_backDragView) {
        _backDragView = [[UIView alloc] init];
        [self addSubview:_backDragView];
    }
    _backDragView.frame = self.bounds;
    _backDragView.layer.borderWidth = kNormalBorderWidth;
    _backDragView.layer.borderColor = [UIColor grayColor].CGColor;
    _backDragView.layer.cornerRadius = kSelfCorner;
    _backDragView.layer.masksToBounds = YES;
    _backDragView.backgroundColor = [UIColor whiteColor];
    
    // team logo
    if (!_teamLogo) {
        _teamLogo = [[UIImageView alloc] init];
        [_backDragView addSubview:_teamLogo];
    }
    CGFloat teamWidth = CGRectGetWidth(_backDragView.frame)/2;
    _teamLogo.frame = CGRectMake(CGRectGetWidth(_backDragView.frame)/2-teamWidth/2, kLogoTopEdge, teamWidth, teamWidth);
    
    // team name
    if (!_teamNameLabel) {
        _teamNameLabel = [[UILabel alloc] init];
        [_backDragView addSubview:_teamNameLabel];
    }
    _teamNameLabel.text = @"切尔西";
    _teamNameLabel.font = [UIFont systemFontOfSize:14.f];
    _teamNameLabel.textAlignment = NSTextAlignmentCenter;
    _teamNameLabel.textColor = [UIColor blackColor];
    CGSize size = [self sizeForString:@"切尔西" attribute:@{NSFontAttributeName:_teamNameLabel.font} width:MAXFLOAT];
    _teamNameLabel.frame = CGRectMake(kNameRightEdge, teamWidth*2-kNameBottomEdge - size.height, teamWidth*2 - 2*kNameRightEdge, size.height);
    _teamNameLabel.adjustsFontSizeToFitWidth = YES;
    _teamNameLabel.minimumScaleFactor = 10/14.f;
    
    if (!_fullViewButton) {
        _fullViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_fullViewButton];
    }
    _fullViewButton.frame = CGRectMake(0, 0, _backDragView.frame.size.width, _backDragView.frame.size.height);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
    [_fullViewButton addGestureRecognizer:longPress];
}

-(void)updateWithData:(id)data
{
    /**
     {
     cardId:@"",
     cardName:@""
     }
     */
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        _teamDictionary = data;
        //team name
        _teamNameLabel.text = [data objectForKey:@"cardName"];
        //team logo
        //_teamType = [data objectForKey:@"watchFormat"];
        _teamLogo.image = [UIImage imageNamed:@"team_logo_default"];
        // main team logo
        NSNumber *position = [data objectForKey:kFavourPositionKey];
        if (!position) {
            return;
        }
    }
}

-(void)updateWithType:(DragCardType)type
{
    switch (type) {
        case DragCardTypeMain:
        {}
            break;
        case DragCardTypeMove:
        {
            if (!_markView) {
                _markView = [[UIView alloc] init];
                [_backDragView addSubview:_markView];
            }
            _markView.frame = CGRectMake(0, 0, _backDragView.frame.size.width, _backDragView.frame.size.height);
            _markView.backgroundColor = [UIColor colorWithRed:33.f/255.f green:37.f/255.f blue:48.f/255.f alpha:0.7f];
            _markView.hidden = NO;
            [self bringSubviewToFront:_fullViewButton];
        }
            break;
        case DragCardTypeNormal:
        {
            _backDragView.layer.borderColor = [UIColor grayColor].CGColor;
            _moveTipLabel.hidden = YES;
            _markView.hidden = YES;
            _backDragView.layer.borderWidth = kNormalBorderWidth;
            _backDragView.backgroundColor = [UIColor whiteColor];
            _teamNameLabel.textColor = [UIColor blackColor];
            [_deleteButton removeFromSuperview];
            _deleteButton = nil;
            [_deleteLogo removeFromSuperview];
            _deleteLogo = nil;
            [self disableEditing];
        }
            break;
        case DragCardTypeSelected:
        {
            UIColor *themeColor = [UIColor blueColor];
            _backDragView.layer.borderColor = themeColor.CGColor;
            _backDragView.backgroundColor = [themeColor colorWithAlphaComponent:0.08];
            _teamNameLabel.textColor = themeColor;
            _backDragView.layer.borderWidth = kSelectBorderWidth;
        }
            break;
        case DragCardTypeEdit:
        {
            UIColor *themeColor = [UIColor blueColor];
            if (!_deleteLogo) {
                _deleteLogo = [[UIImageView alloc] init];
                [self addSubview:_deleteLogo];
            }
            _deleteLogo.frame = CGRectMake(CGRectGetWidth(self.frame)-kDeleteLogoWidthHeight+kOutBorderEdge, -kOutBorderEdge, kDeleteLogoWidthHeight, kDeleteLogoWidthHeight);
            _deleteLogo.layer.masksToBounds = YES;
            _deleteLogo.layer.cornerRadius = kDeleteLogoWidthHeight/2.f;
            _deleteLogo.backgroundColor = themeColor;
            _deleteLogo.image = [UIImage imageNamed:@"teams_addmy_ic_delete"];
            
            if (!_deleteButton) {
                _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:_deleteButton];
            }
            _deleteButton.frame = CGRectMake(CGRectGetMaxX(_deleteLogo.frame)-kDeleteButtonWidthHeight, CGRectGetMinY(_deleteLogo.frame), kDeleteButtonWidthHeight, kDeleteButtonWidthHeight);
            _deleteButton.tag = _fullViewButton.tag+kDeleteButtonTagBiggerThanFullButton;
            [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            _backDragView.layer.borderColor = themeColor.CGColor;
            _backDragView.layer.borderWidth = kSelectBorderWidth;
            _backDragView.backgroundColor = [UIColor whiteColor];
            [self enableEditing];
        }
            break;
            
        case DragCardTypeDraging:
        {
            [self disableEditing];
            UIColor *themeColor = [UIColor blueColor];
            _backDragView.layer.borderColor = themeColor.CGColor;
            _backDragView.backgroundColor = [themeColor colorWithAlphaComponent:0.5];
            _backDragView.layer.borderWidth = 0;
            _moveTipLabel.hidden = YES;
            _markView.hidden = YES;
            [_deleteButton removeFromSuperview];
            _deleteButton = nil;
            [_deleteLogo removeFromSuperview];
            _deleteLogo = nil;
        }
            break;
        default:
            break;
    }
}

-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _fullViewButton.tag = tag;
   // if (_deleteButton) {
     //   _deleteButton.tag = tag + kDeleteButtonTagBiggerThanFullButton;
    //}
}

#pragma mark - long press
-(void)longPressTap:(UILongPressGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _location = [gesture locationInView:self];
            NSLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            _location = [gesture locationInView:self];
            if (_cardDragBlock) {
                _cardDragBlock(self,_location,gesture);
            }
            NSLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            if (_cardDragBlock) {
                _cardDragBlock(self,_location,gesture);
            }
            NSLog(@"press long changed");
            break;
        default:
            NSLog(@"press long else");
            break;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_cardLongPressBlock) {
            _cardLongPressBlock(self.tag);
        }
    }
}

- (void) enableEditing {
    if (_isShaking)
        return;
    
    // put item in editing mode
    _isShaking = YES;
    
    // start the wiggling animation
    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.18;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void) disableEditing {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    _isShaking = NO;
}

-(void) deleteButtonAction:(UIButton*) button
{
    if (_cardDeleteBlock) {
        _cardDeleteBlock(self.tag);
    }
}

#pragma mark - tool
-(CGSize) sizeForString:(NSString*)string attribute:(NSDictionary*) attribute width:(CGFloat)width
{
    CGRect newFrame = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attribute
                                           context:nil];
    newFrame.size.height = ceil(newFrame.size.height);
    newFrame.size.width = ceil(newFrame.size.width);
    return newFrame.size;
}

@end
