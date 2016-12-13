//
//  TopCategoryListView.m
//  footballData
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 www.zuqiukong.com. All rights reserved.
//

#import "TopCategoryListView.h"
//#import "UISearchBar.h"
//#import "UIView+MLScreenshot.h"

@implementation NewsCategoryModel

@end

static const CGFloat kOneNameHeight = 44.0f;
static const CGFloat kSearchButtonNeedWidth = 48.0f;
static const CGFloat kArrowWidth = 12.0f;
static const CGFloat kArrowHeight = 36.0f;
static const CGFloat kLeftEdge = 5.0f;
static const NSInteger kNameLabelBeginTag = 300;
static const NSInteger kLineTag = 9;
static const CGFloat kOneNameLeftRightEdge = 12.0f;
static const CGFloat kLayerWidth = 60.0f;
static const NSInteger kLayerTag = 400;
#define kArray = @[@"热门",@"国内",@"英超",@"西甲",@"广州恒大",@"德甲",@"国安",@"大熊猫",@"其他"];


@interface TopCategoryListView()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray          *_list;
    UIScrollView            *_backgroundScrollView;
    UITapGestureRecognizer  *_singleRecognizer;
    CGPoint                 _lastLocation;
    UIImageView             *_logoView;
    NSInteger               _currentIndex;
    CGFloat                 _screenWidth;
    UIImageView             *_arrowView;
    UIView                  *_maskView;
    CALayer                 *_labelLayer;
    BOOL                    _isPanSelf;
    UITableViewCell         *_minTextLayer;
    UITableViewCell         *_maxTextLayer;
}

@end

@implementation TopCategoryListView

-(id)init
{
    if (self=[super init]) {
//        _screenWidth = [[UIScreen mainScreen] applicationFrame].size.width;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.frame = CGRectMake(0, 20, _screenWidth, kOneNameHeight);
        _selfHeight = 0;
        _fontSize = 0;
//        self.alpha = 0.7f;
    }
    return self;
}

-(void) setupElementsWithData:(id)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        _list = [(NSArray*)data mutableCopy];
    }
    else
        _list = nil;
    
    if ([_list count]) {
        if (!_fontSize) {
            _fontSize = 15.0;
        }
        
        if (!_selfHeight) {
            _selfHeight = 44.0;
        }
        [self setupViews];
    }
}

-(void) setupViews
{
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] init];
        [self addSubview:_backgroundScrollView];
    }
    _backgroundScrollView.backgroundColor = [UIColor clearColor];
    _backgroundScrollView.frame = CGRectMake(kLeftEdge, 0, _screenWidth - kLeftEdge - (_isHideSearchBar?kLeftEdge:kSearchButtonNeedWidth), _selfHeight);
    _backgroundScrollView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollView.scrollsToTop = NO;
    // singleTouch
    if (!_singleRecognizer) {
        _singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameSingleTouch:)];
        //添加一个手势监测；
        [_backgroundScrollView addGestureRecognizer:_singleRecognizer];
    }
    //点击的次数
    _singleRecognizer.numberOfTapsRequired = 1; // 单击

    for (UIView *view in _backgroundScrollView.subviews) {
        if (view.tag>=kNameLabelBeginTag) {
            [view removeFromSuperview];
        }
    }
    [_labelLayer removeFromSuperlayer];
    _labelLayer = nil;
    CGFloat lastOriginX = 0.0f;
    for (NSInteger i=0; i<[_list count]; i++) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.tag = kNameLabelBeginTag + i;
        nameLabel.font = [UIFont systemFontOfSize:_fontSize];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.textColor = [UIColor grayColor];
        NewsCategoryModel *model = [_list objectAtIndex:i];
        nameLabel.text = model.categoryName;
        CGSize size = [self sizeForString:nameLabel.text attribute:@{NSFontAttributeName:nameLabel.font} width:MAXFLOAT];
        nameLabel.frame = CGRectMake(lastOriginX, 0, size.width+2*kOneNameLeftRightEdge, _selfHeight);
        [_backgroundScrollView addSubview:nameLabel];
        //sublabel
        UILabel *subLabel = [[UILabel alloc] initWithFrame:nameLabel.bounds];
        subLabel.font = [UIFont boldSystemFontOfSize:_fontSize];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        subLabel.text = model.categoryName;//[_list objectAtIndex:i];
        UITableViewCell *subBackgroundView = [[UITableViewCell alloc] initWithFrame:nameLabel.bounds];
        subBackgroundView.tag = kLayerTag;
        [nameLabel addSubview:subBackgroundView];
        [subBackgroundView.contentView addSubview:subLabel];
        lastOriginX += size.width + 2*kOneNameLeftRightEdge;
    }
    _backgroundScrollView.contentSize = CGSizeMake(lastOriginX, _selfHeight);
    
    
    //line
    CGFloat logoHeightWidth = 25.0f;
    CGFloat lineWidth = 0.5f;
    if (![self viewWithTag:kLineTag]&&!_isHideSearchBar) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth - kSearchButtonNeedWidth - lineWidth, (_selfHeight - logoHeightWidth)/2, lineWidth, logoHeightWidth)];
        line.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0f];//#dcdcdc
        line.tag = kLineTag;
        [self addSubview:line];
    }
    
    //search button
    if (!_logoView&&!_isHideSearchBar) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(_screenWidth-kSearchButtonNeedWidth, 0, kSearchButtonNeedWidth, _selfHeight)];
        _logoView.image = [UIImage imageNamed:@"searchLogo"];
        [self addSubview:_logoView];
        
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(_screenWidth - kSearchButtonNeedWidth, 0, kSearchButtonNeedWidth, _selfHeight);
        [self addSubview:searchButton];
        [searchButton addTarget:self action:@selector(searchButtonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!_arrowView) {
        _arrowView=[[UIImageView alloc]init];
        [_backgroundScrollView addSubview:_arrowView];
    }
    UIView *firstOneNameLabel = [_backgroundScrollView viewWithTag:kNameLabelBeginTag+0];
    _arrowView.frame = CGRectMake(firstOneNameLabel.frame.size.width/2-kArrowWidth/2, _selfHeight-kArrowHeight, kArrowWidth, kArrowHeight);
    [_backgroundScrollView bringSubviewToFront:_arrowView];
    _arrowView.image=[UIImage imageNamed:@"bottomArrow"];
    
    //透明层
//    CGFloat layerWidth = 58.0f;
//    if (!_teamColor) {
//        _teamColor = [UIColor greenColor];
//    }
//    
//    if (!_maskView) {
//        _maskView = [[UIView alloc] initWithFrame:CGRectMake(_screenWidth-kSearchButtonNeedWidth-layerWidth-0.5f, 0, layerWidth, _selfHeight)];
////        [self addSubview:_maskView];
//        CAGradientLayer *layer = [CAGradientLayer layer];
//        layer.frame = CGRectMake(CGRectGetMaxX(_backgroundScrollView.frame)-layerWidth-0.5f, 0, layerWidth, _selfHeight);
//        layer.borderWidth = 0;
//        UIColor *clearTeamColor = [_teamColor colorWithAlphaComponent:0.0f];
//        layer.colors = [NSArray arrayWithObjects:(id)clearTeamColor.CGColor,
//                        (id)_teamColor.CGColor,nil];
//        layer.startPoint = CGPointMake(0.5, 0.5);
//        layer.endPoint = CGPointMake(1.0, 0.5);
//        [self.layer insertSublayer:layer atIndex:0];
//    }
    
    _currentIndex = 0;
    _lastLocation = CGPointMake(0, 0);
    [self resetLabelColor];
}

-(void) setupSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(_screenWidth, 0, _screenWidth, _selfHeight)];
    _searchBar.alpha = 0.0f;
    _searchBar.placeholder = @"搜索资讯";
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    [_searchBar setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_searchBar];
}

#pragma mark - action fuction
-(void) searchButtonDidSelected:(UIButton*) button
{
    if (!_searchBar) {
        [self setupSearchBar];
    }
    [self openSearchBar];
}

-(void) nameSingleTouch:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_backgroundScrollView];
    _isPanSelf = YES;
    _currentIndex = [self currentIndexWithLocation:point];
    if (_currentIndex >= _list.count) {
        return;
    }
    if (point.x > _lastLocation.x) {
        [self moveToRight];
        _lastLocation = point;
    }
    else if (point.x < _lastLocation.x)
    {
        [self moveToLeft];
        _lastLocation = point;
    }
}

#pragma mark - animation
- (void) resetLabelColor
{
    for (UIView *view in _backgroundScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)view;
            label.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f];
            UIView *subBackground = [label viewWithTag:kLayerTag];
            subBackground.hidden = YES;
            label.font = [UIFont systemFontOfSize:_fontSize];
        }
    }
    UILabel *label = (UILabel*) [_backgroundScrollView viewWithTag:_currentIndex+kNameLabelBeginTag];
    label.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
    label.font = [UIFont boldSystemFontOfSize:_fontSize];
    //arrow
    CGRect frame = _arrowView.frame;
    frame.origin.x = CGRectGetMidX(label.frame) - kArrowWidth/2;
    [UIView animateWithDuration:0.2f animations:^{
        _arrowView.frame = frame;
    } completion:^(BOOL finished) {
        _isPanSelf = NO;
    }];
    _labelLayer.frame = label.frame;
    if (_didSelectCategoryBlock&&_isPanSelf) {
        _didSelectCategoryBlock(_currentIndex);
    }
}

-(void) openSearchBar
{
    [self searchBarTextDidBeginEditing:_searchBar];
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = _searchBar.frame;
        frame.origin.x = kLeftEdge;
        _searchBar.frame = frame;
        _searchBar.alpha = 1.0f;
        _arrowView.alpha = 0.0f;
        UIView *line = [self viewWithTag:kLineTag];
        line.alpha = 0.0f;
        _backgroundScrollView.alpha = 0.0f;
        _logoView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        ;
    }];
    for (NSInteger i=[_list count]-1; i>=0; i--) {
        UIView *label = [_backgroundScrollView viewWithTag:i+kNameLabelBeginTag];
        [UIView animateWithDuration:0.9 delay:1 usingSpringWithDamping:0.5f initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = label.frame;
            frame.origin.y = _selfHeight;
            label.frame = frame;
            label.alpha = 0.0f;
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

-(void) closeSearchBar
{
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = _searchBar.frame;
        frame.origin.x = _screenWidth;
        _searchBar.frame = frame;
        _searchBar.alpha = 0.0f;
        _arrowView.alpha = 1.0f;
        UIView *line = [self viewWithTag:kLineTag];
        line.alpha = 1.0f;
        _backgroundScrollView.alpha = 1.0f;
        _logoView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
    
    for (NSInteger i=[_list count]-1; i>=0; i--) {
        UIView *label = [_backgroundScrollView viewWithTag:i+kNameLabelBeginTag];
        [UIView animateWithDuration:0.1 delay:0.05 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = label.frame;
            frame.origin.y = 0;
            label.frame = frame;
            label.alpha = 1.0f;
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

-(CGFloat) originXForNameLabel
{
    // need current select is the middle one
    UIView *currentNameLabel = [_backgroundScrollView viewWithTag:_currentIndex+kNameLabelBeginTag];
    CGFloat middleNeedWidth = _backgroundScrollView.frame.size.width/2 - currentNameLabel.frame.size.width/2;
    CGFloat currentSelectMinX = CGRectGetMinX(currentNameLabel.frame);
    CGFloat newOriginX = currentSelectMinX - middleNeedWidth;
    //move to left
    if (newOriginX<0) {
        newOriginX = 0;
    }
    
    //move to right
    CGSize size = _backgroundScrollView.contentSize;
    if (newOriginX+_backgroundScrollView.frame.size.width >= size.width) {
        newOriginX = size.width - _backgroundScrollView.frame.size.width;
    }
    return newOriginX;
}

-(void) moveToLeft
{
    [self resetLabelColor];
    CGPoint currentPoint = _backgroundScrollView.contentOffset;
    if (currentPoint.x<=0) {
        return;
    }
    CGFloat newOriginX = [self originXForNameLabel];
    [UIView animateWithDuration:1.0f animations:^{
        _backgroundScrollView.contentOffset = CGPointMake(newOriginX, currentPoint.y);
    } completion:^(BOOL finished) {
        ;
    }];
}

-(void) moveToRight
{
    [self resetLabelColor];
    CGSize size = _backgroundScrollView.contentSize;
    CGPoint currentPoint = _backgroundScrollView.contentOffset;
    if (currentPoint.x >= size.width - _backgroundScrollView.frame.size.width) {
        return;
    }
    CGFloat newOriginX = [self originXForNameLabel];
    [UIView animateWithDuration:1.0f animations:^{
        _backgroundScrollView.contentOffset = CGPointMake(newOriginX, currentPoint.y);
    } completion:^(BOOL finished) {
        ;
    }];
}

#pragma mark - search delegate
-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar becomeFirstResponder];
    _searchBar.showsCancelButton = YES;
    //将 cancel 改成 取消 并且显示白色
    for(id item in [searchBar.subviews[0] subviews])
    {
        NSLog(@"%@",item);
        if([item isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)item;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            btn.tintColor = [UIColor whiteColor];
            [btn setNeedsDisplay];
        }
        
        if ([item isKindOfClass:[UITextField class]])
        {
            UITextField *tf = (UITextField *)item;
            [tf setTintColor:[UIColor grayColor]];
        }
    }
    _searchBar.text = @"";
    if (_didBeginSearch) {
        _didBeginSearch();
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    [self closeSearchBar];
    if (_didCloseSearchBar) {
        _didCloseSearchBar();
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    if (_didSearchBlock) {
        _didSearchBlock(searchBar.text,(UISearchBar*)searchBar);
    }
}

-(void) setAllNameLabelSmallSize
{
    for (NSInteger i=0 ; i<[_list count]; i++) {
        UILabel *label = (UILabel*) [_backgroundScrollView viewWithTag:i+kNameLabelBeginTag];
        label.font = [UIFont systemFontOfSize:_fontSize];
        label.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f];
    }
}

-(void) setAllNameLabelBoldSize
{
    for (NSInteger i=0 ; i<[_list count]; i++) {
        UILabel *label = (UILabel*) [_backgroundScrollView viewWithTag:i+kNameLabelBeginTag];
        label.font = [UIFont boldSystemFontOfSize:_fontSize];
        label.textColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
    }
}

#pragma mark - outlet fuction
-(void) layerScrollByContentOffset:(CGPoint)offset
{
    if (_isPanSelf) {
        return;
    }
    if (!_labelLayer) {
        _labelLayer = [[CALayer alloc] init];
        [_backgroundScrollView.layer addSublayer:_labelLayer];
        _labelLayer.frame = CGRectMake(0, 0, kLayerWidth, _selfHeight);
    }
    
    CGRect frame = _labelLayer.frame;
    NSInteger _currentPage = floor(offset.x/_screenWidth);
    if (_currentPage<=0) {
        _currentPage = 0;
    }
    CGFloat restDistance = offset.x - _currentPage*_screenWidth;
//    NSLog([NSString stringWithFormat:@"%f",restDistance]);
//    NSLog(@"rest :%f",restDistance);
//    NSLog(@"page :%ld",(long)_currentPage);
    NSInteger tag = _currentPage + kNameLabelBeginTag;
    UIView *label = [_backgroundScrollView viewWithTag:tag];
    CGFloat percent = (restDistance*1.0f) / _screenWidth;
    frame.origin.x = ceil(label.frame.origin.x + CGRectGetWidth(label.frame)*percent);
    frame.size.width = [self getLayerWidthWithCurrentTag:tag currentPercent:percent];
    _labelLayer.frame = frame;
    [self nameLabelTextLayerWithFrame:frame];
}

- (void) nameLabelTextLayerWithFrame:(CGRect) frame
{
    CGFloat minX = CGRectGetMinX(frame);
    CGFloat maxX = CGRectGetMaxX(frame);
    NSInteger minIndex = [self currentIndexWithLocation:CGPointMake(minX, 0)];
    NSInteger maxIndex = [self currentIndexWithLocation:CGPointMake(maxX, 0)];
    UILabel *minLabel = (UILabel*)[_backgroundScrollView viewWithTag:minIndex+kNameLabelBeginTag];
    UILabel *maxLabel = (UILabel*)[_backgroundScrollView viewWithTag:maxIndex+kNameLabelBeginTag];
    if (maxIndex==minIndex&&minIndex ==0) {
        maxLabel = nil;
    }
    _minTextLayer = [minLabel viewWithTag:kLayerTag];
    _minTextLayer.hidden = NO;
    CGFloat width = CGRectGetMaxX(minLabel.frame) - minX;
    _minTextLayer.frame = CGRectMake(minLabel.frame.size.width-width, 0, width, minLabel.frame.size.height);
    _minTextLayer.contentView.frame = _minTextLayer.bounds;
    UIView *subLabel = [[_minTextLayer.contentView subviews] objectAtIndex:0];
    CGRect subFrame = subLabel.frame;
    subFrame.origin.x = -_minTextLayer.frame.origin.x;
    subLabel.frame = subFrame;
    _minTextLayer.layer.masksToBounds = YES;

    if (!maxLabel) {
        return;
    }
    _maxTextLayer = [maxLabel viewWithTag:kLayerTag];
    _maxTextLayer.hidden = NO;
    width = maxX - CGRectGetMinX(maxLabel.frame);
    _maxTextLayer.frame = CGRectMake(0, 0, width, maxLabel.frame.size.height);
    _maxTextLayer.contentView.frame = _maxTextLayer.bounds;
    subLabel = [[_maxTextLayer.contentView subviews] objectAtIndex:0];
    subFrame = subLabel.frame;
    subFrame.origin.x = 0;
    subLabel.frame = subFrame;
    _maxTextLayer.layer.masksToBounds = YES;
}

-(CGFloat) getLayerWidthWithCurrentTag:(NSInteger) tag currentPercent:(CGFloat) percent
{
    UIView *label = [_backgroundScrollView viewWithTag:tag];
    CGFloat layerWidth = 0.f;
    NSInteger leftTag = tag - 1;
    NSInteger rightTag = tag + 1;
    if (percent == 0) {
        return CGRectGetWidth(label.frame);
    }
    else if (percent < 0)
    {
        percent = MAX(-1, percent);
        UIView *leftLabel = [_backgroundScrollView viewWithTag:leftTag];
        CGFloat currentPercent = 1 + percent;
        layerWidth = currentPercent * CGRectGetWidth(label.frame) - percent * CGRectGetWidth(leftLabel.frame);
    }
    else
    {
        percent = MIN(1, percent);
        UIView *rightLabel = [_backgroundScrollView viewWithTag:rightTag];
        CGFloat currentPercent = 1 - percent;
        layerWidth = currentPercent * CGRectGetWidth(label.frame) + percent * CGRectGetWidth(rightLabel.frame);
    }
    return layerWidth;
}

-(void) layerWillBeginDragging
{
    [self setAllNameLabelSmallSize];
    _labelLayer.hidden = NO;
}

-(void) layerDidEndDecelerating
{
    CGPoint point = CGPointMake(_labelLayer.frame.origin.x, _labelLayer.frame.origin.y);
    _currentIndex = [self currentIndexWithLocation:point];
    NSLog(@"layerDidEndDecelerating%ld",(long)_currentIndex);
    if (point.x > _lastLocation.x) {
        [self moveToRight];
        _lastLocation = point;
    }
    else if (point.x < _lastLocation.x)
    {
        [self moveToLeft];
        _lastLocation = point;
    }
    else
        [self resetLabelColor];
    _labelLayer.hidden = YES;

}

#pragma mark -tool
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(CGSize) sizeForString:(NSString*)string attribute:(NSDictionary*) attribute width:(CGFloat)width
{
    CGRect newFrame = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attribute
                                           context:nil];
    newFrame.size.height = ceil(newFrame.size.height);
    return newFrame.size;
}

-(NSInteger) currentIndexWithLocation:(CGPoint) location
{
    NSInteger index = 0;
    for ( ; index<[_list count]; index++) {
        UIView *view = [_backgroundScrollView viewWithTag:index+kNameLabelBeginTag];
        CGFloat minOriginX = CGRectGetMinX(view.frame);
        CGFloat maxOriginX = CGRectGetMaxX(view.frame);
        if (minOriginX<=location.x&&location.x<maxOriginX) {
            break;
        }
    }
    return index;
}
@end
