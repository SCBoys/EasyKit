//
//  UIImage+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EKExtension)

+ (UIImage *)ek_imageWithColor:(UIColor *)color;
+ (UIImage *)ek_imageWithColor:(UIColor *)color andSize:(CGSize)size;
/**
 生成图片
 
 @param color 颜色
 @param size 尺寸
 @param cornerRaduis 圆角
 */
+ (UIImage *)ek_imageWithColor:(UIColor *)color andSize:(CGSize)size andCornerRaduis:(CGFloat)cornerRaduis;


/**
 缩放图片
 @param maxSize 允许的最大尺寸，（width或height）
 */
- (UIImage *)ek_scaleImageWithMaxSize:(CGFloat)maxSize;

/**
 自动压缩图片尺寸， size控制在1000， 0.6
 */
- (NSData *)ek_autoCompressImage;

/**
 压缩图片
 @param size 尺寸
 @param quality 压缩质量
 */
- (NSData *)ek_compressImage:(CGFloat)size compressionQuality:(CGFloat)quality;

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


/**
 将视图渲染成图片
 
 @param view 视图
 */
+ (UIImage *)ek_createImageWithView:(UIView *)view;

+ (UIImage *)ek_createImageWithView:(UIView *)view scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
