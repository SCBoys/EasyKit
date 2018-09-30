//
//  UIView+EKExtension.m
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import "UIView+EKExtension.h"

#define kIndicatorTag 100202031

@implementation UIView (EKExtension)

- (UIViewController *)ek_viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)ek_showIndicatorView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.tag = kIndicatorTag;
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:indicator];
    
    //layout
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:indicator attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:indicator attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [indicator startAnimating];
}

- (void)ek_dismissIndicatorView {
    [[self viewWithTag:kIndicatorTag] removeFromSuperview];
}

@end
