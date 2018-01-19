//
//  UIImage+EKExtension.m
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import "UIImage+EKExtension.h"

@implementation UIImage (EKExtension)

+ (UIImage *)ek_imageWithColor:(UIColor*)color
{
    return [self ek_imageWithColor:color andSize:CGSizeMake(1, 1)];
}

+ (UIImage *)ek_imageWithColor:(UIColor*)color andSize:(CGSize)size {
    return [self ek_imageWithColor:color andSize:size andCornerRaduis:0];
}

+ (UIImage *)ek_imageWithColor:(UIColor*)color andSize:(CGSize)size andCornerRaduis:(CGFloat)cornerRaduis {
    CGFloat scale = [UIScreen mainScreen].scale;
    cornerRaduis = cornerRaduis * scale;
    
    CGRect r = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, r, cornerRaduis, cornerRaduis);
    CGContextAddPath(context, path);
    
    CGPathRelease(path);
    
    CGContextFillPath(context);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)ek_scaleImageWithMaxSize:(CGFloat)maxSize {
    CGSize currentSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGFloat currentMax = MAX(currentSize.width, currentSize.height);
    if (currentMax <= maxSize) {
        return self;
    }
    //缩放
    CGFloat scale = maxSize / currentMax;
    CGSize scaledSize = CGSizeMake(scale * currentSize.width, scale * currentSize.height);
    
    UIGraphicsBeginImageContext(scaledSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //坐标系矫正
    CGContextTranslateCTM(context, 0, scaledSize.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    
    CGContextDrawImage(context, CGRectMake(0, 0, scaledSize.width, scaledSize.height), self.CGImage);
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:smallImage.CGImage scale:[UIScreen mainScreen].scale orientation:self.imageOrientation];
}

- (NSData *)ek_compressImageUnderBytes:(NSUInteger)bytes {
    CGFloat compress = 0.9;
    NSData *compressedData = UIImageJPEGRepresentation(self, compress);
    while (compressedData.length > bytes) {
        compress -= 0.2;
        if (compress < 0) {
            compress = 0.0;
        }
        compressedData = UIImageJPEGRepresentation(self, compress);
        if (compress == 0.0) {
            break;
        }
    }
    return compressedData;
}

- (UIImage *)ek_captureWithRectRatio:(CGRect)rectRatio {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGRect rect = CGRectMake(rectRatio.origin.x * width, rectRatio.origin.y * height, rectRatio.size.width * width, rectRatio.size.height * height);
    return [self ek_captureWithRect:rect];
}

- (UIImage *)ek_captureWithRect:(CGRect)rect {
    CGImageRef imageRef = self.CGImage;
    CGRect finalRect = CGRectMake(CGRectGetMinY(rect)*self.scale, CGRectGetMinX(rect)*self.scale, CGRectGetHeight(rect)*self.scale, CGRectGetWidth(rect)*self.scale);
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, finalRect);
    UIImage * cropImage = [UIImage imageWithCGImage:imagePartRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imagePartRef);
    
    return cropImage;
}

- (UIImage *)ek_addCornerRaduisRatio:(CGSize)raduisRatio {
    CGSize raduis = CGSizeZero;
    raduis.width = self.size.width * raduisRatio.width;
    raduis.height = self.size.height * raduisRatio.height;
    return [self ek_addCornerRaduis:raduis];
}

- (UIImage *)ek_addCornerRaduis:(CGSize)raduis {
    CGRect rect = CGRectZero;
    rect.size = self.size;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){raduis.width,raduis.height}].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

@end
