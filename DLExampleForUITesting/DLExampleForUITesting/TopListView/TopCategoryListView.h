//
//  TopCategoryListView.h
//  footballData
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 www.zuqiukong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface NewsCategoryModel : NSObject
@property (nonatomic,strong) NSString* categoryName;
@property (nonatomic,strong) NSString* objectId;
@property (nonatomic,strong) NSNumber* typeId;
@end

@interface TopCategoryListView : UIView

-(void) setupElementsWithData:(id)data;

@property (nonatomic,strong) void(^didSelectCategoryBlock)(NSInteger index);
@property (nonatomic,strong) void(^didSearchBlock)(NSString *searchString,UISearchBar *searchBar);
@property (nonatomic,strong) void(^didCloseSearchBar)(void);
@property (nonatomic,strong) void(^didBeginSearch)(void);
@property (nonatomic,strong) UIColor *teamColor;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,assign) BOOL isHideSearchBar;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat selfHeight;

-(void) layerScrollByContentOffset:(CGPoint) offset;
-(void) layerDidEndDecelerating;
-(void) layerWillBeginDragging;
@end
