//
//  ShowBannerViewController.m
//  DLExampleForUITesting
//
//  Created by David on 16/12/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ShowBannerViewController.h"
#import "CircleScrollView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ShowBannerViewController ()
{
    CircleScrollView        *_cycleBannerView;
    NSMutableArray          *_bannerList;
    UIView              *_backView;
}

@end

@implementation ShowBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(updateBannerViewWithData:) withObject:nil afterDelay:1.5f];
//    [self updateBannerViewWithData:@[@"footballfield.jpg",@"header.jpg",@"searchLogo"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateBannerViewWithData:(id) data
{
    CGFloat width = 280.f;
    CGFloat height = 200.f;
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.f - width/2.f, 80.f, width, height)];
        [self.view addSubview:_backView];
        _backView.backgroundColor = [UIColor redColor];
    }
    if (!_cycleBannerView) {
        _cycleBannerView = [[CircleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height) animationDuration:3.f];
        [_backView addSubview:_cycleBannerView];
    }
    _cycleBannerView.scrollView.scrollsToTop = NO;
    _cycleBannerView.backgroundColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f];
    
    _bannerList = [[NSMutableArray alloc] init];

    /*
     当只有两张banner的时候，会调用复制UIView函数，因为图片数据是本地图片，
     所以复制函数无法正常复制该Image的内容。
     所以需要用，UIImage 与 NSData 互相转换一次才能够正常复制。
     */
    data = @[@"footballfield.jpg",@"header.jpg"];//,@"searchLogo"];
    [_bannerList addObjectsFromArray:data];
    if ([_bannerList count] > 0)
    {
        NSMutableArray *bannerArray = [NSMutableArray new];
        
        for (int i = 0; i < [_bannerList count]; ++i)
        {
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_cycleBannerView.frame), CGRectGetHeight(_cycleBannerView.frame))];
            tempImageView.contentMode = UIViewContentModeScaleAspectFill;
            tempImageView.clipsToBounds = YES;
            
            NSString *imageString =[_bannerList objectAtIndex:i];
            
            NSData *imageDataPng = UIImagePNGRepresentation([UIImage imageNamed:imageString]);
            NSData *imageDataJpg = UIImagePNGRepresentation([UIImage imageNamed:imageString]);
            if (imageDataPng) {
                tempImageView.image = [UIImage imageWithData:imageDataPng];
            }
            else
                tempImageView.image = [UIImage imageWithData:imageDataJpg];
            
            [tempImageView setNeedsLayout];
            [bannerArray addObject:tempImageView];
        }
        
        _cycleBannerView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return [bannerArray objectAtIndex:pageIndex];
        };
        
        _cycleBannerView.totalPagesCount = ^NSInteger(void){
            return [bannerArray count];
        };
        
        //MARK:点击顶部 滚动view 进去
        _cycleBannerView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"tap page: %ld",(long)pageIndex);
        };
    }
}


-(void) dealloc
{
    _cycleBannerView = nil;
}

@end
