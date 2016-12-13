//
//  HotLeagueBaseView.m
//  footballData
//
//  Created by David on 16/1/13.
//  Copyright © 2016年 www.zuqiukong.com. All rights reserved.
//

#import "HotLeagueBaseView.h"

static const CGFloat kTopLogoEdge = 12.0f;
static const CGFloat kLeftSmallEdge = 12.0f;
static const CGFloat kLeftBigEdge = 14.0;
static const CGFloat kLogoWidth = 56.0f;
static const CGFloat kMoreButtonWidth = 70.0f;
static const CGFloat kTopViewHeight = 80.0f;
static const CGFloat kNameTopEdge = 16.0f;
static const CGFloat kButtonHeight = 26.0f;
static const CGFloat kLineWidth = 1.0;
static const CGFloat kCornerRadius = 4.0f;
static const NSInteger kMarkLabelTag = 900;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface HotLeagueBaseView()<UIScrollViewDelegate>
{
    UIView              *_leagueTopBackgroundView;
    UIImageView         *_leagueLogoBigImageView;
    UIImageView         *_leagueLogoSmallImageView;
    UILabel             *_leagueNameLabel;
    UILabel             *_leagueYearLabel;
    UIButton            *_scoreButton;
    UIButton            *_playerButton;
    UIView              *_hightLightView;
    UIView              *_scoreMarkView;
    UIView              *_playerMarkView;
    UIButton            *_moreButton;
    
    UIScrollView                *_contentScrollView;
    UIView        *_scoreView;
    UIView       *_playerView;
    UIView             *_rankingView;
    BOOL                        _internationalCup;
}
@end

@implementation HotLeagueBaseView

-(id)init
{
    if (self=[super init]) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void) setupViewElements
{
    [self setupTopView];
    [self setupContentView];
}

-(void) setupContentView
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_leagueTopBackgroundView.frame), kScreenWidth, self.frame.size.height-CGRectGetMaxY(_leagueTopBackgroundView.frame))];
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth*2, _contentScrollView.frame.size.height);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.scrollEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    [self addSubview:_contentScrollView];
    
    _scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(_contentScrollView.frame))];
    _scoreView.backgroundColor = [UIColor redColor];
    [_contentScrollView addSubview:_scoreView];
    
//    _rankingView = [[UIWCRankingView alloc] initWithFrame:_scoreView.frame];
//    [_contentScrollView addSubview:_rankingView];
//    _rankingView.hidden = YES;
    
    _playerView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(_contentScrollView.frame))];
    _playerView.backgroundColor = [UIColor greenColor];
    [_contentScrollView addSubview:_playerView];
}

-(void) setupTopView
{
    // top view
    _leagueTopBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    [self addSubview:_leagueTopBackgroundView];
    _leagueTopBackgroundView.backgroundColor = [UIColor whiteColor];

    _leagueLogoBigImageView = [[UIImageView alloc] initWithFrame:_leagueTopBackgroundView.bounds];
    [_leagueTopBackgroundView addSubview:_leagueLogoBigImageView];
    _leagueLogoBigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leagueLogoBigImageView.alpha = 0.2;
    
    // content
    _leagueLogoSmallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftSmallEdge, kTopLogoEdge, kLogoWidth, kLogoWidth)];
    [_leagueTopBackgroundView addSubview:_leagueLogoSmallImageView];
    
    _leagueNameLabel = [[UILabel alloc] init];
    [_leagueTopBackgroundView addSubview:_leagueNameLabel];
    _leagueNameLabel.textAlignment = NSTextAlignmentLeft;
    _leagueNameLabel.textColor = [UIColor blackColor];
    _leagueNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    _leagueYearLabel = [[UILabel alloc] init];
    [_leagueTopBackgroundView addSubview:_leagueYearLabel];
    _leagueYearLabel.textAlignment = NSTextAlignmentLeft;
    _leagueYearLabel.font = [UIFont systemFontOfSize:12.0f];
    _leagueYearLabel.textColor = [UIColor grayColor];
    
    CGFloat centerButtonWidth = (kScreenWidth - CGRectGetMaxX(_leagueLogoSmallImageView.frame) - kLeftSmallEdge-2*kLeftBigEdge-kMoreButtonWidth)/2;
    
    UIView  *buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leagueLogoSmallImageView.frame)+kLeftSmallEdge, CGRectGetMaxY(_leagueLogoSmallImageView.frame)-1-kButtonHeight, centerButtonWidth*2, kButtonHeight)];
    [_leagueTopBackgroundView addSubview:buttonBackgroundView];
    [buttonBackgroundView.layer setBorderColor:[UIColor purpleColor].CGColor];
    [buttonBackgroundView.layer setBorderWidth:kLineWidth];
    [buttonBackgroundView.layer setCornerRadius:kCornerRadius];
    buttonBackgroundView.layer.masksToBounds = YES;
    
    _hightLightView = [[UIView alloc] init];
    _hightLightView.backgroundColor = [UIColor purpleColor];
    [buttonBackgroundView addSubview:_hightLightView];
    _hightLightView.frame = CGRectMake(0, 0, centerButtonWidth, kButtonHeight);
    
    // button label
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:_hightLightView.frame];
    scoreLabel.text = @"笑口组";
    [self setButtonLabelSameProperty:scoreLabel isHightLight:NO];
    [buttonBackgroundView addSubview:scoreLabel];
    [buttonBackgroundView sendSubviewToBack:scoreLabel];
    
    // mark view
    _scoreMarkView = [[UIView alloc] initWithFrame:scoreLabel.frame];
    [buttonBackgroundView addSubview:_scoreMarkView];
    _scoreMarkView.backgroundColor = [UIColor purpleColor];
    UILabel *markLabel = [[UILabel alloc] initWithFrame:scoreLabel.bounds];
    markLabel.text = @"笑口组";
    [self setButtonLabelSameProperty:markLabel isHightLight:YES];
    markLabel.tag = kMarkLabelTag;
    [_scoreMarkView addSubview:markLabel];
    _scoreMarkView.layer.masksToBounds = YES;
    
    UILabel *playerLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerButtonWidth, 0, centerButtonWidth, kButtonHeight)];
    playerLabel.text = @"西门口";
    [self setButtonLabelSameProperty:playerLabel isHightLight:NO];
    [buttonBackgroundView addSubview:playerLabel];
    [buttonBackgroundView sendSubviewToBack:playerLabel];
    // mark view
    _playerMarkView = [[UIView alloc] initWithFrame:CGRectMake(centerButtonWidth, 0, 0, kButtonHeight)];
    [buttonBackgroundView addSubview:_playerMarkView];
    _playerMarkView.backgroundColor = [UIColor purpleColor];
    markLabel = [[UILabel alloc] initWithFrame:playerLabel.bounds];
    markLabel.text = @"西门口";
    [self setButtonLabelSameProperty:markLabel isHightLight:YES];
    markLabel.tag = kMarkLabelTag;
    [_playerMarkView addSubview:markLabel];
    _playerMarkView.layer.masksToBounds = YES;
    
    _scoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBackgroundView addSubview:_scoreButton];
    _scoreButton.frame = _hightLightView.frame;
    [self setCenterButtonSameProperty:_scoreButton];
    
    _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBackgroundView addSubview:_playerButton];
    _playerButton.frame = CGRectMake(centerButtonWidth, 0, centerButtonWidth, kButtonHeight);
    [self setCenterButtonSameProperty:_playerButton];
    
    // more button
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leagueTopBackgroundView addSubview:_moreButton];
    _moreButton.frame = CGRectMake(kScreenWidth - kMoreButtonWidth - kLeftBigEdge, CGRectGetMinY(buttonBackgroundView.frame), kMoreButtonWidth, kButtonHeight);
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_moreButton.layer setBorderColor:[UIColor purpleColor].CGColor];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_moreButton.layer setBorderWidth:kLineWidth];
    [_moreButton.layer setCornerRadius:kCornerRadius];
    [_moreButton addTarget:self action:@selector(moreInfomationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setCenterButtonSameProperty:(UIButton*) button
{
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button addTarget:self action:@selector(centerButtonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setButtonLabelSameProperty:(UILabel*) label isHightLight:(BOOL)isHightLight
{
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = isHightLight?[UIColor whiteColor]:[UIColor purpleColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.backgroundColor = [UIColor clearColor];
}

-(void) updateWithData:(id)data
{
//    if (![data isKindOfClass:[leagueObj class]]) {
//        return;
//    }
//    leagueObj *model = (leagueObj*)data;
//    _model = model;
//    if ([model.format isEqualToString:@"International cup"]) {
//        _internationalCup=YES;
//    }else {
//        _internationalCup=NO;
//    }
//    // logo
//    NSString *leagueLogoPng = [NSString stringWithFormat:@"%ld.png",(long)model.competition_id];
//    [_leagueLogoBigImageView cacheM_setBlurImageWithURL:AutoMake_leagueLogoURL(leagueLogoPng)placeholderImage:IMAGE(@"teams_league_default_logo@3x.png")];
//    [_leagueLogoSmallImageView cacheM_setImageWithURL:AutoMake_leagueLogoURL(leagueLogoPng)
//                                   placeholderImage:IMAGE(@"teams_league_default_logo@3x.png") canClean:YES];
//    // name
//    _leagueNameLabel.text = model.name;
//    CGSize size = [self sizeForString:_leagueNameLabel.text attribute:@{NSFontAttributeName:_leagueNameLabel.font} width:MAXFLOAT];
//    _leagueNameLabel.frame = CGRectMake(CGRectGetMaxX(_leagueLogoSmallImageView.frame)+kLeftSmallEdge, kNameTopEdge, size.width, size.height);
//    
//    // year
//    _leagueYearLabel.text = _seasonYear;
//    CGFloat smallEdge = 6.0f;
//    size = [self sizeForString:_leagueYearLabel.text attribute:@{NSFontAttributeName:_leagueYearLabel.font} width:MAXFLOAT];
//    _leagueYearLabel.frame = CGRectMake(CGRectGetMaxX(_leagueNameLabel.frame)+smallEdge, CGRectGetMidY(_leagueNameLabel.frame)-size.height/2, size.width, size.height);
//    
//    if(_internationalCup){
//        _rankingView.hidden = NO;
//        _scoreView.hidden = YES;
//        // ranking
//        [_rankingView setLeagueViewController:_parentViewController];
////        [_rankingView.rankingView:_parentViewController];
//        _rankingView.rankingView.parentViewController = _parentViewController;
//        [_rankingView setSid:model.season_id setLeagueName:model.name];
//    }else {
//        _scoreView.hidden = NO;
//        _rankingView.hidden = YES;
//        // score
//        [_scoreView setSeasonId:model.season_id];
//    }
//    // player
//    [_playerView setSeasonId:model.season_id];
}

#pragma mark - scroll view delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hightLightViewMoveByContentOffset:scrollView.contentOffset];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger page = scrollView.contentOffset.x/kScreenWidth;
//    if (page) {
//        _currentTableView =(UITableView*) _playerView.tableView;
//    }
//    else if(_scoreView.hidden)
//    {
//        // _ranking
//        _currentTableView = (UITableView*)_rankingView.rankingView;
//    }
//    else // score
//        _currentTableView = (UITableView*)_scoreView.tableView;
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [_topListView layerWillBeginDragging];
}

#pragma mark - animation
-(void) hightLightViewMoveByContentOffset:(CGPoint) contentOffset
{
    CGRect frame = _hightLightView.frame;
    CGFloat originX = contentOffset.x/kScreenWidth*_hightLightView.frame.size.width;
    frame.origin.x = originX;
    _hightLightView.frame = frame;
    [self markLabelMoveWithHighLightViewFrame:frame];
}

-(void) markLabelMoveWithHighLightViewFrame:(CGRect) frame
{
    CGFloat minX = CGRectGetMinX(frame);
    CGFloat maxX = CGRectGetMaxX(frame);
    UILabel *_scoreMarkLabel = (UILabel*)[_scoreMarkView viewWithTag:kMarkLabelTag];
    //    UILabel *_playerMarkLabel = (UILabel*)[_playerMarkView viewWithTag:kMarkLabelTag];
    if (maxX<CGRectGetWidth(frame)||minX>CGRectGetWidth(frame)) {
        return;
    }
    // score mark view
    CGFloat width = CGRectGetWidth(frame) - minX;
    _scoreMarkView.frame = CGRectMake(minX, 0, width, kButtonHeight);
    CGRect subFrame = _scoreMarkLabel.frame;
    subFrame.origin.x = -_scoreMarkView.frame.origin.x;
    _scoreMarkLabel.frame = subFrame;
    
    width = maxX - CGRectGetWidth(frame);
    _playerMarkView.frame = CGRectMake(CGRectGetMinX(_playerMarkView.frame), 0, width, kButtonHeight);
}

#pragma mark - button action
-(void) centerButtonDidSelect:(UIButton*) button
{
    NSInteger page = 0;
    if (button == _scoreButton) {
        page = 0;
    }
    else
        page = 1;
//    [UIView animateWithDuration:0.25 animations:^{
        _contentScrollView.contentOffset = CGPointMake(kScreenWidth*page, 0);
//    } completion:^(BOOL finished) {
//        ;
//    }];
    
}

-(void) moreInfomationButtonAction:(UIButton*) button
{

}

#pragma mark - tool
-(CGSize) sizeForString:(NSString*)string attribute:(NSDictionary*) attribute width:(CGFloat)width
{
    CGRect newFrame = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attribute
                                           context:nil];
    newFrame.size.height = ceil(newFrame.size.height);
    return newFrame.size;
}

@end
