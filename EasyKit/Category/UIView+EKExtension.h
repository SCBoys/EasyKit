//
//  UIView+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EKExtension)

- (nullable UIViewController *)ek_viewController;

- (void)ek_showIndicatorView;

- (void)ek_dismissIndicatorView;

@end

NS_ASSUME_NONNULL_END
