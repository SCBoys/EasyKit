//
//  EKPopView.m
//  RoadHome
//
//  Created by TF14975 on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKPopView.h"

@interface EKPopView ()<CAAnimationDelegate>
@property (nonatomic, assign) EKPopViewDirection direction;

//用于过渡动画的view，只有是rootPopView的时候才不为nil
@property (nonatomic, strong) UIView *transitionView;
//只有是rootPopView的时候才不为nil
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topViewContainer;

@property (nonatomic, strong) UIView *dataViewConntainer;

@property (nonatomic, strong) UIView *bottomViewContainer;
@property (nonatomic, strong) NSLayoutConstraint *bottomViewContainer_h;
@property (nonatomic, strong) NSLayoutConstraint *contentView_h;
@property (nonatomic, strong) NSLayoutConstraint *animate_layout;
@property (nonatomic, strong) NSLayoutConstraint *dataView_h;
@property (nonatomic, strong) NSLayoutConstraint *topViewContainer_h;

@property (nonatomic, strong) NSMutableArray<EKPopView *> *popViews;

@property (nonatomic, strong) CAShapeLayer *containerBackLayer;
@property (nonatomic, assign) BOOL isPush;
@end

@implementation EKPopView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setInterface];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerBackLayer.frame = self.container.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:(CGSize){self.cornerRadius,self.cornerRadius}];
    self.containerBackLayer.path = path.CGPath;
    self.containerBackLayer.fillColor = [[UIColor whiteColor] CGColor];
}

#pragma mark - Delegate & DataSource

#pragma mark - event response
- (void)tapOnMaskView:(id)sender {
    if ([self.popViewDelegate respondsToSelector:@selector(ekPopViewClickOnMaskView:)]) {
        [self.popViewDelegate ekPopViewClickOnMaskView:self];
    }
}

#pragma mark - public method
- (void)showInWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    [self showInView:view fromDirection:EKPopViewDirectionBottom];
}

- (void)showInView:(UIView *)view fromDirection:(EKPopViewDirection)direction {
    if (view == nil) {
        return;
    }
    self.direction = direction;
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
        self.animate_layout.constant = self.direction == EKPopViewDirectionBottom ? contentHeight:-contentHeight;
        [self layoutIfNeeded];
        [self viewWillAppear];
    } completion:^(BOOL finished) {
        [self viewDidAppear];
    }];
}

- (void)pushView:(EKPopView *)view {
    [self.rootPopView.popViews.lastObject.contentView endEditing:YES];
    view.rootPopView = self.rootPopView;
    [self.rootPopView.popViews addObject:view];
    view.dataView_h.constant = self.rootPopView.dataView_h.constant;
    
    UIView *transitionView = self.rootPopView.transitionView;
    [transitionView addSubview:view.contentView];
    
    NSDictionary *views = @{@"contentv":view.contentView};
    [view.contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentv]|" options:0 metrics:nil views:views]];
    [view.contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentv]|" options:0 metrics:nil views:views]];
    
    [view.contentView layoutIfNeeded];
    [self.rootPopView beginTransitionWithAnimateView:transitionView isPushed:YES];
}

- (EKPopView *)popToPreviousView {
    EKPopView *root = self.rootPopView;
    if (root.popViews.count <= 1) {
        return nil;
    }
    EKPopView *view = [root.popViews lastObject];
    [view.contentView removeFromSuperview];
    [root.popViews removeLastObject];
    
    [self.rootPopView beginTransitionWithAnimateView:root.transitionView isPushed:NO];
    return view;
}

- (void)dismiss {
    [self.contentView endEditing:YES];
    EKPopView *root = self.rootPopView;
    [UIView animateWithDuration:0.2 animations:^{
        root.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        root.animate_layout.constant = 0;
        [root layoutIfNeeded];
    } completion:^(BOOL finished) {
        //清除约束
        [root removeConstraint:self.animate_layout];
        [root.contentView removeConstraint:self.contentView_h];
        root.animate_layout = nil;
        root.contentView_h = nil;
        ///清除视图
        [root.popViews removeAllObjects];
        root.popViews = nil;
        root.rootPopView = nil;
        [root removeFromSuperview];
    }];
}

- (void)viewWillAppear {}
- (void)viewDidAppear {}
- (void)viewDidDisappear {}

#pragma mark - delegate
- (void)animationDidStart:(CAAnimation *)anim {
    if (self.isPush) {
        [self.popViews.lastObject viewWillAppear];
    } else {
        if (self.popViews.lastObject == nil) {
            [self viewWillAppear];
        } else {
            [self.popViews.lastObject viewWillAppear];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.popViews.lastObject viewDidAppear];
    if (self.isPush) {
        [self.popViews[self.popViews.count - 2] viewDidDisappear];
    }
}

#pragma mark - private method
- (void)initShowView {
    [self addTarget:self action:@selector(tapOnMaskView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.transitionView = [[UIView alloc] init];
    self.transitionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.container = [[UIView alloc] init];
    self.container.translatesAutoresizingMaskIntoConstraints = NO;
    self.container.backgroundColor = [UIColor clearColor];
    self.containerBackLayer = [CAShapeLayer layer];
    [self addSubview:self.container];
    [self.container.layer insertSublayer:self.containerBackLayer atIndex:0];
    [self.container addSubview:self.transitionView];
    [self.transitionView addSubview:self.contentView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_container,_transitionView,_contentView);
    [_container.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_container]|" options:0 metrics:nil views:views]];
    
    [_transitionView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_transitionView]|" options:0 metrics:nil views:views]];
    [_transitionView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_transitionView]|" options:0 metrics:nil views:views]];
    
    [_contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:views]];
    [_contentView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:views]];
    
    self.contentView_h = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    NSLayoutAttribute selfLayout = self.direction == EKPopViewDirectionBottom ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    NSLayoutAttribute containerLayout = self.direction == EKPopViewDirectionBottom ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
    self.animate_layout = [NSLayoutConstraint constraintWithItem:self attribute:selfLayout relatedBy:NSLayoutRelationEqual toItem:self.container attribute:containerLayout multiplier:1 constant:0];
    [self addConstraints:@[self.animate_layout]];
    [self.contentView addConstraint:self.contentView_h];
}

- (void)setInterface {
    //const
    _topViewHeight = 0.f;
    _bottomViewHeight = 0.f;
    _dynamticDataViewMinimumHeight = 0;
    _maxContentHeight = [UIScreen mainScreen].bounds.size.height/2.f;
    _dynamticDataViewHeight = -1;
    //ui
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.topViewContainer = [[UIView alloc] init];
    self.topViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomViewContainer = [[UIView alloc] init];
    self.bottomViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomViewContainer.backgroundColor = [UIColor clearColor];
    self.dataViewConntainer = [[UIView alloc] init];
    self.dataViewConntainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.dataViewConntainer.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.topViewContainer];
    [self.contentView addSubview:self.dataViewConntainer];
    [self.contentView addSubview:self.bottomViewContainer];
    //layout
    NSDictionary *views = NSDictionaryOfVariableBindings(_topViewContainer,_dataViewConntainer,_bottomViewContainer);
    [self.topViewContainer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topViewContainer]|" options:0 metrics:nil views:views]];
    self.topViewContainer_h = [NSLayoutConstraint constraintWithItem:self.topViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.topViewHeight];
    [self.topViewContainer addConstraint:self.topViewContainer_h];
    [self.dataViewConntainer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dataViewConntainer]|" options:0 metrics:nil views:views]];
    self.dataView_h = [NSLayoutConstraint constraintWithItem:self.dataViewConntainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.bottomViewContainer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomViewContainer]|" options:0 metrics:nil views:views]];
    self.bottomViewContainer_h = [NSLayoutConstraint constraintWithItem:self.bottomViewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.contentView addConstraints:@[self.bottomViewContainer_h,self.dataView_h]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topViewContainer][_dataViewConntainer][_bottomViewContainer]" options:0 metrics:nil views:views]];
}

#pragma mark - transition animate
- (void)beginTransitionWithAnimateView:(UIView *)animateView isPushed:(BOOL)isPushed {
    CATransition *transitionAnimation = [CATransition animation];
    transitionAnimation.duration = 0.3f;
    transitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.type = kCATransitionPush;
    transitionAnimation.subtype = isPushed ? kCATransitionFromRight : kCATransitionFromLeft;
    transitionAnimation.delegate = self;
    [animateView.layer addAnimation:transitionAnimation forKey:@"transition"];
    self.isPush = isPushed;
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
