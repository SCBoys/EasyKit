//
//  UIImage+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EKExtension)

+ (UIImage *)ek_imageWithColor:(UIColor*)color;
+ (UIImage *)ek_imageWithColor:(UIColor*)color andSize:(CGSize)size;
/**
 生成图片
 
 @param color 颜色
 @param size 尺寸
 @param cornerRaduis 圆角
 */
+ (UIImage *)ek_imageWithColor:(UIColor*)color andSize:(CGSize)size andCornerRaduis:(CGFloat)cornerRaduis;


/**
 缩放图片
 @param maxSize 允许的最大尺寸，（width或height）
 */
- (UIImage *)ek_scaleImageWithMaxSize:(CGFloat)maxSize;

/**
 压缩图片
 
 @param bytes 不超过bytes
 @return 压缩后的图片
 */
- (NSData *)ek_compressImageUnderBytes:(NSUInteger)bytes;


/**
 截取图片

 @param rectRatio 截取的区域比例
 */
- (UIImage *)ek_captureWithRectRatio:(CGRect)rectRatio;


/**
 截取图片

 @param rect 截取的区域
 */
- (UIImage *)ek_captureWithRect:(CGRect)rect;


/**
 给图片添加圆角

 @param raduisRatio 圆角比例
 @return 返回带圆角的图片
 */
- (UIImage *)ek_addCornerRaduisRatio:(CGSize)raduisRatio;

/**
 给图片添加圆角

 @param raduis 圆角值
 @return 返回带圆角的图片
 */
- (UIImage *)ek_addCornerRaduis:(CGSize)raduis;

@end
