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


@end