//
//  DragViewController.m
//  DLExampleForUITesting
//
//  Created by David on 16/12/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DragViewController.h"
#import "DragCardView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static const NSInteger kMaxCount = 20;
static NSString* const kFavourPositionKey = @"position";
static const NSInteger  kCardViewBeginTag = 80000;
static const CGFloat kFollowViewWidthHeight = 87.f;
static const CGFloat kFollowViewTopEdge = 13.f;
static const NSInteger kMaxIndexInRow = 3;

@interface DragViewController ()
{
    UIScrollView        *_backScrollView;
    NSMutableArray      *_allCardMutableArray;
    DragCardView        *_currentDragCardView;
    BOOL                _isMovingTeam;
    BOOL                _rightIsBack;
}
@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isMovingTeam = NO;
    _isLongPressing = NO;
    [super viewDidLoad];
    [self setupElements];
    [self setupRightButton];
    _allCardMutableArray = [[NSMutableArray alloc] init];
    //[self refreshLocalFavoriteTeam];
    _rightIsBack = YES;
    
   // _willRemoveArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setupElements
{
    // back scrollview
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_backScrollView];
    }
    _backScrollView.frame = CGRectMake(0, 64.f, kScreenWidth, kScreenHeight-64.f);
    _backScrollView.contentSize = _backScrollView.frame.size;
    _backScrollView.backgroundColor = [UIColor colorWithRed:243.f/255.f green:243.f/255.f blue:243.f/255.f alpha:1.f];
}

-(void) setupRightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_rightButton];
    }
    [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
    _rightButton.backgroundColor = [UIColor clearColor];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f] forState:UIControlStateNormal];
    _rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    CGFloat width = 52.f;
    _rightButton.frame = CGRectMake(kScreenWidth - width - 8, 20, width, 44.f);
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideAllCardView];
    [self getData];
}

-(void) hideAllCardView
{
    for (UIView *view in _backScrollView.subviews) {
        if ([view isKindOfClass:[DragCardView class]]) {
            DragCardView *myView = (DragCardView*)view;
            [myView updateWithType:DragCardTypeNormal];
            myView.hidden = YES;
        }
    }
}

//MARK: 获取数据
-(void) getData
{
    /**
     {
     cardId:@"",
     cardName:@""
     }
     */

    for (NSInteger i = 0; i < kMaxCount; i++) {
        NSString *name = [NSString stringWithFormat:@"%@%ld",(i%2)?@"单数":@"双数",(long)i];
        NSString *cardId = [NSString stringWithFormat:@"card%ld",(long)i];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];//@{@"cardId":cardId,@"cardName":name};
        [dic setValue:cardId forKey:@"cardId"];
        [dic setValue:name forKey:@"cardName"];
        [_allCardMutableArray addObject:dic];
    }
    
    [self checkAndUpdateCardDic];
    [self setupAllFollowCardViews];
}

//MARK: 加载每一个关注view
-(void) setupAllFollowCardViews
{
    CGFloat maxHeight = 0;
    for (NSDictionary *teamDic in _allCardMutableArray) {
        NSNumber *position = [teamDic objectForKey:kFavourPositionKey];
        DragCardView *view = [_backScrollView viewWithTag:[position integerValue]+kCardViewBeginTag];
        CGFloat edge = (kScreenWidth - kMaxIndexInRow*kFollowViewWidthHeight)/4.f;
        NSInteger row = [position integerValue]/kMaxIndexInRow;
        NSInteger index = [position integerValue]%kMaxIndexInRow;
        if (!view) {
            view = [[DragCardView alloc] initWithFrame:CGRectMake(edge+index*(edge+kFollowViewWidthHeight),kFollowViewTopEdge+row*(kFollowViewTopEdge+kFollowViewWidthHeight), kFollowViewWidthHeight, kFollowViewWidthHeight)];
            [_backScrollView addSubview:view];
        }
        view.frame = CGRectMake(edge+index*(edge+kFollowViewWidthHeight),kFollowViewTopEdge+row*(kFollowViewTopEdge+kFollowViewWidthHeight), kFollowViewWidthHeight, kFollowViewWidthHeight);
        view.tag = [position integerValue] + kCardViewBeginTag;
        [view updateWithData:teamDic];
        maxHeight = CGRectGetMaxY(view.frame) + kFollowViewTopEdge;
        [self setLongPressActionWithCardView:view];
        view.hidden = NO;
        [view.fullViewButton addTarget:self action:@selector(teamButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self updateScrollViewContentSizeWithMaxHeight:maxHeight];
}

-(void) updateScrollViewContentSizeWithMaxHeight:(CGFloat) maxHeight
{
    _backScrollView.contentSize = CGSizeMake(kScreenWidth, maxHeight);
}


-(void) setAllTeamEditStyle
{
    for (NSDictionary *dic in _allCardMutableArray) {
        NSNumber *position = [dic objectForKey:kFavourPositionKey];
        NSInteger viewTag = [position integerValue] + kCardViewBeginTag;
        DragCardView *view = [_backScrollView viewWithTag:viewTag];
        [view updateWithType:DragCardTypeEdit];
    }
}

#pragma mark button action
-(void) rightButtonAction:(UIButton*) button
{
    if (_rightIsBack) {
        [self popBack];
        return;
    }
    _isLongPressing = NO;
    // 重新按位置从小到大排序
    [self sortFavourTeamByPosition];
    // 重新编辑位置位置数字都只相差1
    [self checkAndUpdateCardDic];
    // 重新画scroll view
    [self hideAllCardView];
    [self setupAllFollowCardViews];
    [self resetAllCardStyle:DragCardTypeNormal];
    _rightIsBack = YES;
    [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.navigationController.navigationBar.hidden = NO;
}


-(void) teamButtonSelected:(UIButton*) button
{
    NSLog(@"team button %ld",(long)button.tag);
    
    NSDictionary *item = [_allCardMutableArray objectAtIndex:button.tag - kCardViewBeginTag];
    if (!item||_isLongPressing) {
        return;
    }
}

-(void) setLongPressActionWithCardView:(DragCardView*) view
{
    __weak id weekSelf = self;
    __weak id weakView = view;
    
    view.cardDeleteBlock = ^(NSInteger tag) {
        DragViewController *strongSelf = weekSelf;
        UIView *view = [_backScrollView viewWithTag:tag];
        NSLog(@"%@",view);
        [strongSelf sortFavourTeamByPosition];
        NSInteger toTag = [_allCardMutableArray count] + kCardViewBeginTag-1;
        if ([view isKindOfClass:[DragCardView class]]) {
            _currentDragCardView = (DragCardView*) view;
        }
        if (view.tag != toTag) {
            [strongSelf beginMoveAnimationFromTag:view.tag toTag:toTag];
        }
        // delete view
        _currentDragCardView.hidden = YES;
        [strongSelf findAndRemoveCardDictionaryWithTag:_currentDragCardView.tag];
        [strongSelf saveFollowData];
    };
    
    view.cardLongPressBlock = ^(NSInteger tag){
        DragViewController *strongSelf = weekSelf;
        [strongSelf setAllTeamEditStyle];
        strongSelf.navigationController.navigationBar.hidden = YES;
        strongSelf.rightButton.hidden = NO;
        strongSelf.rightButton.enabled = YES;
        strongSelf.isLongPressing = YES;
        _rightIsBack = NO;
        [strongSelf.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        
        if ([strongSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            strongSelf.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        [weakView updateWithType:DragCardTypeDraging];
    };
    
    view.cardDragBlock = ^(DragCardView *teamView, CGPoint location, UILongPressGestureRecognizer* gesture){
        [_backScrollView bringSubviewToFront:teamView];
        DragViewController *strongSelf = weekSelf;
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [teamView updateWithType:DragCardTypeEdit];
            // 重新按位置从小到大排序
            [strongSelf sortFavourTeamByPosition];
            // 重新编辑位置位置数字都只相差1
            [strongSelf checkAndUpdateCardDic];
            // 重新画scroll view
            [strongSelf hideAllCardView];
            [UIView animateWithDuration:0.1 animations:^{
                [strongSelf setupAllFollowCardViews];
            }];
            
            [strongSelf resetFrameForTeamView:teamView tag:teamView.tag];
            [strongSelf setAllTeamEditStyle];
            [strongSelf saveFollowData];
            return ;
        }
        else
            [teamView updateWithType:DragCardTypeDraging];
        
        CGRect frame = teamView.frame;
        CGPoint _point = [gesture locationInView:_backScrollView];
        frame.origin.x = _point.x - location.x;
        frame.origin.y = _point.y - location.y;
        [UIView animateWithDuration:0.1 animations:^{
            teamView.frame = frame;
        }];
        NSLog(@"gridItemframe:%f,%f",frame.origin.x,frame.origin.y);
        NSLog(@"move to point(%f,%f)",location.x,location.y);
        
        _currentDragCardView = teamView;
        NSInteger toTag = [strongSelf tagOfLocation:_point];
        NSLog(@"current tag %ld",(long)toTag);
        if (toTag != teamView.tag) {
            [strongSelf beginMoveAnimationFromTag:teamView.tag toTag:toTag];
        }
        
        //翻页
        [strongSelf moveScrollViewWithLocation:_point];
    };
}

#pragma mark helper method
//MARK: 部分移动
-(void) beginMoveAnimationFromTag:(NSInteger) beginTag toTag:(NSInteger)endTag
{
    if (_isMovingTeam) {
        return;
    }
    NSLog(@"moving begin");
    _isMovingTeam = YES;
    if (beginTag > endTag) {
        NSInteger tempTag = beginTag;
        beginTag = endTag;
        endTag = tempTag;
    }
    BOOL isIncreasingTag = (beginTag == _currentDragCardView.tag);
    
    NSMutableArray *teamViewArray = [[NSMutableArray alloc] init];
    NSMutableArray  *teamDicArray = [[NSMutableArray alloc] init];
    for (NSInteger currentTag = beginTag; currentTag<= endTag; currentTag++) {
        DragCardView *view = [_backScrollView viewWithTag:currentTag];
        // 获取teamView
        if ([view isKindOfClass:[DragCardView class]]) {
            [teamViewArray addObject:view];
        }
        else
        {
            for (NSDictionary *dic in teamDicArray) {
                [_allCardMutableArray addObject:dic];
            }
            _isMovingTeam = NO;
            return;
        }
        
        // 获取team data
        NSDictionary *dic = [self findAndRemoveCardDictionaryWithTag:currentTag];
        if (dic) {
            [teamDicArray addObject:dic];
        }
        else
        {
            for (NSDictionary *dic in teamDicArray) {
                [_allCardMutableArray addObject:dic];
            }
            _isMovingTeam = NO;
            return;
        }
    }
    
    NSInteger cardIndex = 0;
    NSInteger currentTeamTag = _currentDragCardView.tag;
    for (NSInteger currentTag = beginTag; currentTag<= endTag; currentTag++) {
        NSMutableDictionary *teamDic = [teamDicArray objectAtIndex:cardIndex];
        NSLog(@"%@", teamDic);
        NSInteger position = 0;
        if (currentTag == currentTeamTag) {
            position = ((isIncreasingTag?endTag:beginTag)-kCardViewBeginTag);
            [teamDic setObject:[NSNumber numberWithInteger:position] forKey:kFavourPositionKey];
        }
        else
        {
            position = (isIncreasingTag?(currentTag-1):(currentTag+1))-kCardViewBeginTag;
            [teamDic setObject:[NSNumber numberWithInteger:position] forKey:kFavourPositionKey];
        }
        [_allCardMutableArray addObject:teamDic];
        
        DragCardView *teamView = [teamViewArray objectAtIndex:cardIndex];
        CGRect frame = teamView.frame;
        CGFloat edge = (kScreenWidth - kMaxIndexInRow*kFollowViewWidthHeight)/4.f;
        NSInteger row = position/kMaxIndexInRow;
        NSInteger index = position%kMaxIndexInRow;
        frame.origin = CGPointMake(edge+index*(edge+kFollowViewWidthHeight), kFollowViewTopEdge+row*(kFollowViewTopEdge+kFollowViewWidthHeight));
        teamView.tag = position + kCardViewBeginTag;
        if (_currentDragCardView != teamView) {
            [UIView animateWithDuration:0.5 animations:^{
                teamView.frame = frame;
            }];
        }
        cardIndex++;
    }
    _isMovingTeam = NO;
    NSLog(@"moving end");
}

//MARK: 增加字段
-(void) checkAndUpdateCardDic
{
    /**
     {
     cardId:@"",
     cardName:@""
     }
     need to add favourPosition = 0;
     */
    for (NSInteger index = 0;index<_allCardMutableArray.count;index++) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:[_allCardMutableArray objectAtIndex:index]];
        [mutableDic setObject:[NSNumber numberWithInteger:index] forKey:kFavourPositionKey];
        [_allCardMutableArray replaceObjectAtIndex:index withObject:mutableDic];
    }
}

//MARK: 按照这个位置重新排序
-(void) sortFavourTeamByPosition
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kFavourPositionKey ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [_allCardMutableArray sortUsingDescriptors:sortDescriptors];
}

//MARK: 在 关注数组 中查找对应的主队数据，并移除该球队
-(NSDictionary*) findAndRemoveCardDictionaryWithTag:(NSInteger)tag
{
    NSDictionary *findDic;
    for (NSDictionary *dic in _allCardMutableArray) {
        NSNumber *position = [dic objectForKey:kFavourPositionKey];
        if ([position integerValue] == (tag-kCardViewBeginTag)) {
            findDic = dic;
            break;
        }
    }
    if (findDic) {
        [_allCardMutableArray removeObject:findDic];
        return findDic;
    }
    return nil;
}

//MARK: 保存本地关注的球队
-(void) saveFollowData
{
    [self sortFavourTeamByPosition];
}

-(void) resetFrameForTeamView:(DragCardView*)teamView tag:(NSInteger) tag
{
    CGRect frame = teamView.frame;
    NSInteger position = tag - kCardViewBeginTag;
    CGFloat edge = (kScreenWidth - kMaxIndexInRow*kFollowViewWidthHeight)/4.f;
    NSInteger row = position/kMaxIndexInRow;
    NSInteger index = position%kMaxIndexInRow;
    frame.origin = CGPointMake(edge+index*(edge+kFollowViewWidthHeight), kFollowViewTopEdge+row*(kFollowViewTopEdge+kFollowViewWidthHeight));
    [UIView animateWithDuration:0.1 animations:^{
        teamView.frame = frame;
    }];
}

-(NSInteger) tagOfLocation:(CGPoint) location
{
    {
        CGFloat edge = (kScreenWidth - kMaxIndexInRow*kFollowViewWidthHeight)/4.f;
        NSInteger row = (location.y)/(kFollowViewTopEdge+kFollowViewWidthHeight);
        NSInteger index = location.x/(edge+kFollowViewWidthHeight);
        return (row*kMaxIndexInRow + index + kCardViewBeginTag);
    }
    return 0;
}

-(void) moveScrollViewWithLocation:(CGPoint) location
{
    CGPoint contentOffset = _backScrollView.contentOffset;
    CGFloat minOffsetY = contentOffset.y;
    CGFloat maxOffsetY = contentOffset.y + CGRectGetHeight(_backScrollView.frame);
    CGFloat contentSizeHeight = _backScrollView.contentSize.height;
    if (location.y - kFollowViewWidthHeight/2.f <= 0) {
        contentOffset.y = 0;
        _backScrollView.contentOffset = contentOffset;
    }
    else if (location.y + kFollowViewWidthHeight/2.f >= contentSizeHeight)
    {
        // 置底
        contentOffset.y = contentSizeHeight - CGRectGetHeight(_backScrollView.frame);
        if (contentOffset.y<0) {
            contentOffset.y = 0;
        }
        _backScrollView.contentOffset = contentOffset;
    }
    else
    {
        CGFloat edge = 0.f;
        if (location.y - kFollowViewWidthHeight/2.f < minOffsetY) {
            edge = location.y - minOffsetY - kFollowViewWidthHeight/2.f;
        }
        else if (location.y + kFollowViewWidthHeight/2.f > maxOffsetY)
        {
            edge = location.y - maxOffsetY + kFollowViewWidthHeight/2.f;
        }
        else
        {
            return;
        }
        [UIView animateWithDuration:0.1 animations:^{
            CGPoint myContentOffset = _backScrollView.contentOffset;
            myContentOffset.y = myContentOffset.y+edge;
            _backScrollView.contentOffset = myContentOffset;
        }];
    }
}

-(void) resetAllCardStyle:(DragCardType) type
{
    for (NSDictionary *dic in _allCardMutableArray) {
        NSNumber *position = [dic objectForKey:kFavourPositionKey];
        NSInteger viewTag = [position integerValue] + kCardViewBeginTag;
        DragCardView *view = [_backScrollView viewWithTag:viewTag];
        [view updateWithType:type];
    }
}

@end
