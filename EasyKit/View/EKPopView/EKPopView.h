//
//  EKPopView.h
//  RoadHome
//
//  Created by TF14975 on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EKPopViewDirectionBottom = 0,
    EKPopViewDirectionTop
} EKPopViewDirection;

@class EKPopView;
@protocol EKPopViewDelegate <NSObject>
@optional
//遮罩层视图点击事件
- (void)ekPopViewClickOnMaskView:(EKPopView *)view;
@end
@interface EKPopView : UIControl

@property (nonatomic, weak) id<EKPopViewDelegate> popViewDelegate;
//setting
///弹窗最大高度，默认高度是屏幕高度的1/2
@property (nonatomic, assign) CGFloat maxContentHeight;
///用于动态设置dataView的高度，实际高度不会超过maxContentHeight，默认-1，表示不采用动态高度
@property (nonatomic, assign) CGFloat dynamticDataViewHeight;
///用于限制dataView的最小高度，实际dataView 的高度不会低于这个高度，默认0
@property (nonatomic, assign) CGFloat dynamticDataViewMinimumHeight;

//ui control
///默认nil,如果设置topView，需要设置topViewHeight
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) CGFloat topViewHeight;
///数据视图，默认是tableView
@property (nonatomic, strong) UIView *dataView;
///默认nil,如果设置bottomView，需要设置bottomViewHeight
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat bottomViewHeight;

- (void)showInWindow;
- (void)showInView:(UIView *)view;

- (void)showInView:(UIView *)view fromDirection:(EKPopViewDirection)direction;

//push到下一个视图
- (void)pushView:(EKPopView *)view;
//pop到上一个视图
- (EKPopView *)popToPreviousView;

- (void)dismiss;

@end
