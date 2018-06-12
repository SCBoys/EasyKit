//
//  UIColor+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2018/6/12.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (EKExtension)

+ (UIColor *)ek_colorWithHex:(NSString *)hexStr;


+ (UIColor *)ek_colorWithHex:(NSString *)hexStr alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
