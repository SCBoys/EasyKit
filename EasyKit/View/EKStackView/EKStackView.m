//
//  EKStackView.m
//  EndoscopyEvaluation
//
//  Created by xiaofeishen on 2018/12/28.
//  Copyright © 2018 xiaofeishen. All rights reserved.
//

#import "EKStackView.h"

@interface EKStackView()
@property (nonatomic, copy) NSArray<UIView *> *containers;
@end

@implementation EKStackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHorizontal = YES;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)setViews:(NSArray<UIView *> *)views {
    if (_views.count > 0) {
        for (UIView *view in self.containers) {
            [view removeFromSuperview];
        }
    }
    _views = views;
    NSMutableArray *superviews = @[].mutableCopy;
    NSArray<UIColor *> *colors = @[UIColor.greenColor,UIColor.purpleColor,UIColor.redColor];
    NSInteger cout = 0;
    for (UIView *view in _views) {
        UIView *superView = [[UIView alloc] init];
        superView.backgroundColor = colors[cout];
        cout++;
        superView.translatesAutoresizingMaskIntoConstraints = NO;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [superView addSubview:view];
        [self addSubview:superView];
        [superviews addObject:superView];
    }
    self.containers = superviews;
    [self setup];
}

- (void)setup {
    NSLayoutAttribute leading;
    NSLayoutAttribute tailing;
    NSLayoutAttribute top;
    NSLayoutAttribute bottom;
    NSLayoutAttribute width;
    if (_isHorizontal) {
        leading = NSLayoutAttributeLeft;
        tailing = NSLayoutAttributeRight;
        top = NSLayoutAttributeTop;
        bottom = NSLayoutAttributeBottom;
        width = NSLayoutAttributeWidth;
    } else {
        leading = NSLayoutAttributeTop;
        tailing = NSLayoutAttributeBottom;
        top = NSLayoutAttributeLeft;
        bottom = NSLayoutAttributeRight;
        width = NSLayoutAttributeHeight;
    }
    
    UIView *pre = self;
    for (int i = 0; i < self.containers.count; i++) {
        UIView *container = self.containers[i];
        UIView *subView = container.subviews.firstObject;
        //vertical
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:top relatedBy:NSLayoutRelationEqual toItem:container attribute:top multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:bottom relatedBy:NSLayoutRelationEqual toItem:container attribute:bottom multiplier:1 constant:0]];
        //horizontal
        if (i == 0) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:leading relatedBy:NSLayoutRelationEqual toItem:container attribute:leading multiplier:1 constant:0]];
        } else {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:pre attribute:tailing relatedBy:NSLayoutRelationEqual toItem:container attribute:leading multiplier:1 constant:0]];
        }
        if (self.containers.count - 1 == i) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:tailing relatedBy:NSLayoutRelationEqual toItem:container attribute:tailing multiplier:1 constant:0]];
        }
        if (pre != self) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:pre attribute:width relatedBy:NSLayoutRelationEqual toItem:container attribute:width multiplier:1 constant:0]];
        }
        pre = container;
        //
        [container addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [container addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
}

@end
