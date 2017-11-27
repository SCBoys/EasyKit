//
//  EKBottomPopView.h
//  RoadHome
//
//  Created by TF14975 on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EKBottomPopView;
@protocol EKBottomPopViewDelegate <NSObject>
@optional
//遮罩层视图点击事件
- (void)ekBottomPopViewClickOnMaskView:(EKBottomPopView *)view;
@end
@interface EKBottomPopView : UIControl

@property (nonatomic, weak) id<EKBottomPopViewDelegate> popViewDelegate;
//setting
///弹窗最大高度，默认高度是屏幕高度的1/2
@property (nonatomic, assign) CGFloat maxContentHeight;
///用于动态设置tableView的高度，实际高度不会超过maxContentHeight，默认-1，表示不采用动态高度
@property (nonatomic, assign) CGFloat dynamticDataViewHeight;
///用于限制tableView的最小高度，实际tableView 的高度不会低于这个高度，默认0
@property (nonatomic, assign) CGFloat dynamticDataViewMinimumHeight;

//ui control
///有默认为高度44的操作栏， 可以自定义
@property (nonatomic, strong) UIView *topView;
///topView 的高度，值为44。
@property (nonatomic, assign) CGFloat topViewHeight;
///数据视图，默认是tableView
@property (nonatomic, strong) UIView *dataView;
///默认nil,如果设置bottomView，需要设置bottomViewHeight
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat bottomViewHeight;

@property (nonatomic, weak, readonly) UILabel *titleLabel;
//默认title="取消"
@property (nonatomic, weak, readonly) UIButton *leftTopBarButton;
//默认title="确定"
@property (nonatomic, weak, readonly) UIButton *rightTopBarButton;
//需要自定义数据源和委托对象,如果dataView被设置了其他视图，该值为nil
@property (nonatomic, weak, readonly) UITableView *tableView;

- (void)showInWindow;
- (void)showInView:(UIView *)view;

//push到下一个视图
- (void)pushView:(EKBottomPopView *)view;
//pop到上一个视图
- (EKBottomPopView *)popToPreviousView;

- (void)dismiss;

@end
