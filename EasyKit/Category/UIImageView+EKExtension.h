//
//  UIImageView+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2018/1/19.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (EKExtension)

/**
 通过CoreGraphic添加带圆角的图片，主要应用于列表性能优化

 @param image 要设置圆角的图片
 @param cornerRaduis 圆角
 @param viewSize 视图size
 */
- (void)ek_setImage:(UIImage *)image byCornerRaduis:(CGFloat)cornerRaduis byViewSize:(CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
