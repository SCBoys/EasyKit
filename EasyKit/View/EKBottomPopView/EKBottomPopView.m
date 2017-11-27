//
//  EKBottomPopView.m
//  RoadHome
//
//  Created by TF14975 on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKBottomPopView.h"

@interface EKBottomPopView ()
@property (nonatomic, weak) UITableView *tableView;

//用于过渡动画的view，只有是rootPopView的时候才不为nil
@property (nonatomic, strong) UIView *transitionView;
//只有是rootPopView的时候才不为nil
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topViewContainer;

@property (nonatomic, strong) UIView *separateLine;
@property (nonatomic, strong) UIView *dataViewConntainer;

@property (nonatomic, strong) UIView *bottomViewContainer;
@property (nonatomic, strong) NSLayoutConstraint *bottomViewContainer_h;
@property (nonatomic, strong) NSLayoutConstraint *contentView_h;
@property (nonatomic, strong) NSLayoutConstraint *animate_layout;
@property (nonatomic, strong) NSLayoutConstraint *dataView_h;
@property (nonatomic, strong) NSLayoutConstraint *topViewContainer_h;

//默认视图
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *leftTopBarButton;
@property (nonatomic, weak) UIButton *rightTopBarButton;

///当只有是rootPopView的时候，该属性才不为nil
@property (nonatomic, strong) NSMutableArray<EKBottomPopView *> *popViews;
@property (nonatomic, weak) EKBottomPopView *rootPopView;
@end

@implementation EKBottomPopView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setInterface];
    }
    return self;
}

#pragma mark - Delegate & DataSource

#pragma mark - event response
- (void)tapOnMaskView:(id)sender {
    if ([self.popViewDelegate respondsToSelector:@selector(ekBottomPopViewClickOnMaskView:)]) {
        [self.popViewDelegate ekBottomPopViewClickOnMaskView:self];
    }
} 

#pragma mark - public method
- (void)showInWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    if (view == nil) {
        return;
    }
    self.popViews = @[self].mutableCopy;
    self.rootPopView = self;
    [self initShowView];
    [view addSubview:self];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:views]];
    
    CGFloat dataViewHeight = self.maxContentHeight - self.bottomViewHeight - self.topViewHeight;
    if (self.dynamticDataViewHeight == -1) {
        //不做处理
    } else {
        dataViewHeight = MIN(dataViewHeight, self.dynamticDataViewHeight);
    }
    
    if (self.dynamticDataViewMinimumHeight < self.maxContentHeight - self.bottomViewHeight - self.topViewHeight) {
        dataViewHeight = MAX(dataViewHeight, self.dynamticDataViewMinimumHeight);
    }
    
    self.dataView_h.constant = dataViewHeight;
    
    CGFloat contentHeight = dataViewHeight + self.topViewHeight + self.bottomViewHeight;
    self.contentView_h.constant = contentHeight;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.animate_layout.constant = contentHeight;
        [self layoutIfNeeded];
    }];
}

- (void)pushView:(EKBottomPopView *)view {
    view.rootPopView = self.rootPopView;
    [self.rootPopView.popViews addObject:view];
    view.dataView_h.constant = self.rootPopView.dataView_h.constant;
    
    UIView *transitionView = self.rootPopView.transitionView;
    [transitionView addSubview:view.contentView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view.contentView);
    [view.contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view.contentView]|" options:0 metrics:nil views:views]];
    [view.contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view.contentView]|" options:0 metrics:nil views:views]];
    
    [self.contentView layoutIfNeeded];
    [self beginTransitionWithAnimateView:transitionView isPushed:YES];
}

- (EKBottomPopView *)popToPreviousView {
    EKBottomPopView *root = self.rootPopView;
    if (root.popViews.count <= 1) {
        return nil;
    }
    EKBottomPopView *view = [root.popViews lastObject];
    [view.contentView removeFromSuperview];
    [root.popViews removeLastObject];
    
    [self beginTransitionWithAnimateView:root.transitionView isPushed:NO];
    return view;
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.animate_layout.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //清除约束
        [self removeConstraint:self.animate_layout];
        [self.contentView removeConstraint:self.contentView_h];
        self.animate_layout = nil;
        self.contentView_h = nil;
        ///清除视图
        [self.popViews removeAllObjects];
        self.popViews = nil;
        self.rootPopView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - private method
- (void)initShowView {
    [self addTarget:self action:@selector(tapOnMaskView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.transitionView = [[UIView alloc] init];
    self.transitionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.container = [[UIView alloc] init];
    self.container.translatesAutoresizingMaskIntoConstraints = NO;
    self.container.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.container];
    [self.container addSubview:self.transitionView];
    [self.transitionView addSubview:self.contentView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_container,_transitionView,_contentView);
    [_container.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_container]|" options:0 metrics:nil views:views]];
    
    [_transitionView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_transitionView]|" options:0 metrics:nil views:views]];
    [_transitionView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_transitionView]|" options:0 metrics:nil views:views]];
    
    [_contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:views]];
    [_contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:views]];
    
    self.contentView_h = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    self.animate_layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraints:@[self.animate_layout]];
    [self.contentView addConstraint:self.contentView_h];
}

- (void)setInterface {
    //const
    _topViewHeight = 44.f;
    _bottomViewHeight = 0;
    _dynamticDataViewMinimumHeight = 0;
    _maxContentHeight = [UIScreen mainScreen].bounds.size.height/2.f;
    _dynamticDataViewHeight = -1;
    //ui
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.topViewContainer = [[UIView alloc] init];
    self.topViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomViewContainer = [[UIView alloc] init];
    self.bottomViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomViewContainer.backgroundColor = [UIColor clearColor];
    self.dataViewConntainer = [[UIView alloc] init];
    self.dataViewConntainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.dataViewConntainer.backgroundColor = [UIColor clearColor];
    self.separateLine = [[UIView alloc] init];
    self.separateLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.separateLine.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1];
    
    [self.contentView addSubview:self.topViewContainer];
    [self.contentView addSubview:self.separateLine];
    [self.contentView addSubview:self.dataViewConntainer];
    [self.contentView addSubview:self.bottomViewContainer];
    //layout
    NSDictionary *views = NSDictionaryOfVariableBindings(_topViewContainer,_separateLine,_dataViewConntainer,_bottomViewContainer);
    NSNumber *lineHeight = @(1/[UIScreen mainScreen].scale);
    NSDictionary *metrics = NSDictionaryOfVariableBindings(lineHeight);
    [self.topViewContainer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topViewContainer]|" options:0 metrics:nil views:views]];
    self.topViewContainer_h = [NSLayoutConstraint constraintWithItem:self.topViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.topViewHeight];
    [self.topViewContainer addConstraint:self.topViewContainer_h];
    [self.separateLine.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_separateLine]|" options:0 metrics:nil views:views]];
    [self.dataViewConntainer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dataViewConntainer]|" options:0 metrics:nil views:views]];
    self.dataView_h = [NSLayoutConstraint constraintWithItem:self.dataViewConntainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.bottomViewContainer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomViewContainer]|" options:0 metrics:nil views:views]];
    self.bottomViewContainer_h = [NSLayoutConstraint constraintWithItem:self.bottomViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.contentView addConstraints:@[self.bottomViewContainer_h,self.dataView_h]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topViewContainer][_separateLine(lineHeight)][_dataViewConntainer][_bottomViewContainer]" options:0 metrics:metrics views:views]];
    
    //set defalut dataView
    self.dataView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = (UITableView *)self.dataView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    //set defalut topView
    UIView *topView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel = titleLabel;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.rightTopBarButton = rightButton;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.leftTopBarButton = leftButton;
    [topView addSubview:self.leftTopBarButton];
    [topView addSubview:self.titleLabel];
    [topView addSubview:self.rightTopBarButton];
    self.topView = topView;
    //layout
    NSDictionary *topSubViews = NSDictionaryOfVariableBindings(titleLabel,leftButton,rightButton);
    [titleLabel.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:nil views:topSubViews]];
    [titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [leftButton.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftButton]|" options:0 metrics:nil views:topSubViews]];
    [leftButton.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[leftButton(>=44)]" options:0 metrics:nil views:topSubViews]];
    
    [rightButton.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightButton]|" options:0 metrics:nil views:topSubViews]];
    [rightButton.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightButton(>=44)]-15-|" options:0 metrics:nil views:topSubViews]];
}

#pragma mark - transition animate
- (void)beginTransitionWithAnimateView:(UIView *)animateView isPushed:(BOOL)isPushed {
    CATransition *transitionAnimation = [CATransition animation];
    transitionAnimation.duration = 0.3f;
    transitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.type = kCATransitionPush;
    transitionAnimation.subtype = isPushed ? kCATransitionFromRight : kCATransitionFromLeft;
    [animateView.layer addAnimation:transitionAnimation forKey:@"transition"];
}

#pragma mark - getters and setters
- (void)setTopViewHeight:(CGFloat)topViewHeight {
    _topViewHeight = topViewHeight;
    self.topViewContainer_h.constant = topViewHeight;
}

- (void)setTopView:(UIView *)topView {
    if (_topView == topView) {
        return;
    }
    [_topView removeFromSuperview];
    _topView = topView;
    if (topView == nil) {
        return;
    }
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topViewContainer addSubview:_topView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_topView);
    [_topView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|" options:0 metrics:nil views:views]];
    [_topView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView]|" options:0 metrics:nil views:views]];
}

- (void)setDataView:(UIView *)dataView {
    if (_dataView == dataView) {
        return;
    }
    [_dataView removeFromSuperview];
    _dataView = dataView;
    if (dataView == nil) {
        return;
    }
    [self.dataViewConntainer addSubview:_dataView];
    _dataView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_dataView);
    [_dataView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dataView]|" options:0 metrics:nil views:views]];
    [_dataView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dataView]|" options:0 metrics:nil views:views]];
}

- (void)setBottomView:(UIView *)bottomView {
    if (_bottomView == bottomView) {
        return;
    }
    [_bottomView removeFromSuperview];
    _bottomView = bottomView;
    if (bottomView == nil) {
        return;
    }
    
    [self.bottomViewContainer addSubview:_bottomView];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_bottomView);
    [_bottomView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomView]|" options:0 metrics:nil views:views]];
    [_bottomView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bottomView]|" options:0 metrics:nil views:views]];
}

- (void)setBottomViewHeight:(CGFloat)bottomViewHeight{
    _bottomViewHeight = bottomViewHeight;
    self.bottomViewContainer_h.constant = bottomViewHeight;
}

@end
