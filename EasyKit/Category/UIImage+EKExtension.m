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

@end
