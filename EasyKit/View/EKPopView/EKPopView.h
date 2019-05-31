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

NS_ASSUME_NONNULL_BEGIN

@class EKPopView;
@protocol EKPopViewDelegate <NSObject>
@optional
//遮罩层视图点击事件
- (void)ekPopViewClickOnMaskView:(EKPopView *)view;
@end
@interface EKPopView : UIControl

@property (nonatomic, weak, nullable) id<EKPopViewDelegate> popViewDelegate;
//setting
///弹窗最大高度，默认高度是屏幕高度的1/2
@property (nonatomic, assign) CGFloat maxContentHeight;
///用于动态设置dataView的高度，实际高度不会超过maxContentHeight，默认-1，表示不采用动态高度
@property (nonatomic, assign) CGFloat dynamticDataViewHeight;
///用于限制dataView的最小高度，实际dataView 的高度不会低于这个高度，默认0
@property (nonatomic, assign) CGFloat dynamticDataViewMinimumHeight;
///内容视图的圆角, 默认为0
@property (nonatomic, assign) CGFloat cornerRadius;


//ui control
///默认nil,如果设置topView，需要设置topViewHeight
@property (nonatomic, strong, nullable) UIView *topView;
@property (nonatomic, assign) CGFloat topViewHeight;
///数据视图
@property (nonatomic, strong, nullable) UIView *dataView;
///默认nil,如果设置bottomView，需要设置bottomViewHeight
@property (nonatomic, strong, nullable) UIView *bottomView;
@property (nonatomic, assign) CGFloat bottomViewHeight;

///当只有是rootPopView的时候，该属性才不为nil
@property (nonatomic, strong, readonly) NSMutableArray<EKPopView *> *popViews;
@property (nonatomic, weak) EKPopView *rootPopView;

- (void)showInWindow;
- (void)showInView:(UIView *)view;

- (void)showInView:(UIView *)view fromDirection:(EKPopViewDirection)direction;

//can override
- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewDidDisappear;

//push到下一个视图
- (void)pushView:(EKPopView *)view;
//pop到上一个视图
- (nullable EKPopView *)popToPreviousView;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
