//
//  DragCardView.h
//  DLExampleForUITesting
//
//  Created by David on 16/12/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DragCardTypeNormal,
    DragCardTypeSelected,
    DragCardTypeMain,
    DragCardTypeMove,
    DragCardTypeEdit,
    DragCardTypeDraging,
} DragCardType;

typedef void(^cardViewLongPressBlock)(NSInteger tag);
typedef void(^cardViewDragBlock)(__weak id cardView, CGPoint location, UILongPressGestureRecognizer *gesture);
typedef void(^cardViewDeleteBlock)(NSInteger tag);

@interface DragCardView : UIView

@property (nonatomic, strong) UIButton* fullViewButton;
@property (nonatomic, strong) UIView    *backDragView;
@property (nonatomic,copy) cardViewLongPressBlock cardLongPressBlock;
@property (nonatomic, copy) cardViewDragBlock cardDragBlock;
@property (nonatomic, copy) cardViewDeleteBlock cardDeleteBlock;

-(void) updateWithData:(id) data;
-(void) updateWithType:(DragCardType) type;

@end
