//
//  TopScrollViewController.m
//  footballData
//
//  Created by David on 16/1/13.
//  Copyright © 2016年 www.zuqiukong.com. All rights reserved.
//

#import "TopScrollViewController.h"
#import "TopCategoryListView.h"
#import "HotLeagueBaseView.h"
static const NSInteger kHotLeagueBaseViewBeginTag = 500;
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface TopScrollViewController()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    TopCategoryListView *_topListView;
    NSMutableArray      *_topListArray;
    NSInteger           _currentPage;
}
@end

@implementation TopScrollViewController

-(id)init
{
    if (self=[super init]) {
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupViewElements];
    _topListArray = [[NSMutableArray alloc] init];
    [self getTopListData];
}

-(void) setupViewElements
{
    [self setupTopView];
}

-(void) setupContentView
{
    // background scrollView
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topListView.frame), kScreenWidth, kScreenHeight - CGRectGetHeight(_topListView.frame)-60.0f)];
        [self.view addSubview:_backgroundScrollView];
    }
    _backgroundScrollView.contentSize = CGSizeMake(kScreenWidth*[_topListArray count], _backgroundScrollView.frame.size.height);
    _backgroundScrollView.pagingEnabled = YES;
    _backgroundScrollView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollView.delegate = self;
    
    NSInteger index = 0;
    for (;index<[_topListArray count];) {
        HotLeagueBaseView *publicView = [_backgroundScrollView viewWithTag:index+kHotLeagueBaseViewBeginTag];
        if (!publicView) {
            publicView = [[HotLeagueBaseView alloc] initWithFrame:CGRectMake(index*kScreenWidth, 0, kScreenWidth, _backgroundScrollView.frame.size.height)];
            publicView.parentViewController = self;
            [publicView setupViewElements];
            publicView.tag = index+kHotLeagueBaseViewBeginTag;
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [panGesture setDelegate:self];
            [panGesture setMaximumNumberOfTouches:1];
            [publicView addGestureRecognizer:panGesture];
            [_backgroundScrollView addSubview:publicView];
        }
        index ++;
    }
    [self getSeasonIdWithIndex:0];
}

-(void) setupTopView
{
    // top list
    _topListView = [[TopCategoryListView alloc] init];
    _topListView.isHideSearchBar = YES;
    CGRect frame = _topListView.frame;
    frame.origin.y = 44.0f + 20.0f;
    frame.size.height = 36.0f;
    _topListView.frame = frame;
    _topListView.selfHeight = 36.0f;
    _topListView.fontSize = 14.0f;
    [self.view addSubview:_topListView];
    
    __weak id weekSelf = self;
    _topListView.didSelectCategoryBlock = ^(NSInteger index){
        [UIView animateWithDuration:0.20 animations:^{
            TopScrollViewController *strongSelf = weekSelf;
            [strongSelf.backgroundScrollView setContentOffset:CGPointMake(kScreenWidth*index, 0)];
            [strongSelf getSeasonIdWithIndex:index];
        }completion:^(BOOL finished){
        }];
    };
}

#pragma mark - get data
- (void)getSeasonIdWithIndex:(NSInteger) index {
//    HotLeagueBaseView *myBaseView = [_backgroundScrollView viewWithTag:index+kHotLeagueBaseViewBeginTag];
//    if (!myBaseView.seasonYear) {
////        SHOW_PROGRESS(self.view);
//    }
//    [[APIClient_sponia shareClient]getV_ListSeasonCurrBlok:model.competition_id :^(BOOL bol, id responseObje){
//        NSInteger _seasonId;
//        NSString *seasonYear;
//        HIDE_PROGRESS(self.view);
//        NSDictionary *dataDict = (NSDictionary *)responseObje;
//        if (!bol) {
//            _seasonId=0;
//            seasonYear = @"-";
//        }else{
//            _seasonId=[[dataDict objectForKeyOrNil:@"season_id"]integerValue];
//            seasonYear = [NSString stringWithFormat:@"(%@)",[dataDict objectForKey:@"season_name"]];
//        }
//        
//        model.season_id = _seasonId;
//        HotLeagueBaseView *baseView = [_backgroundScrollView viewWithTag:index+kHotLeagueBaseViewBeginTag];
//        if (baseView) {
//            baseView.seasonYear = seasonYear;
//            [baseView updateWithData:model];
//        }
//    }];
}


-(void) getTopListData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_topListArray removeAllObjects];
        for (int i=0; i<10; i++) {
            NewsCategoryModel *category = [[NewsCategoryModel alloc] init];
            category.categoryName = (i%2)?[NSString stringWithFormat:@"分类%d",i]:[NSString stringWithFormat:@"分类名字长%d",i];
            category.typeId = [NSNumber numberWithInteger:i+1000];
            category.objectId = [NSString stringWithFormat:@"%d",i+2000];
            [_topListArray addObject:category];
        }
        [_topListView setupElementsWithData:_topListArray];
        [self setupContentView];
    });
}

#pragma mark - scroll view delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_topListView layerScrollByContentOffset: scrollView.contentOffset];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_topListView layerDidEndDecelerating];
    _currentPage = scrollView.contentOffset.x/kScreenWidth;
    [self getSeasonIdWithIndex:_currentPage];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_topListView layerWillBeginDragging];
}

#pragma mark-gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation;
    HotLeagueBaseView *view =(HotLeagueBaseView*)gesture.view;
    translation = [gesture translationInView:[view.currentTableView superview]];
    [self scrollWithDelta:translation.y];
}

- (void)scrollWithDelta:(CGFloat)delta
{
//    if (delta <- 5) {
//        CGRect frame=CGRectMake(0, kScreenHeight, kScreenWidth, 49);
//        [UITabBar animateWithDuration:0.3
//                           animations:^{
//                           }completion:^(BOOL finished){
//                               
//                           }];
//    }
//    
//    if (delta > 5) {
//        CGRect frame=CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
//        [UITabBar animateWithDuration:0.3
//                           animations:^{
//                           }completion:^(BOOL finished){
//                               
//                           }];
//    }
}
@end
