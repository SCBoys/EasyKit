//
//  UIImageView+EKExtension.m
//  EasyKitDemo
//
//  Created by TF14975 on 2018/1/19.
//  Copyright © 2018年 EK. All rights reserved.
//

#import "UIImageView+EKExtension.h"
#import "UIImage+EKExtension.h"

@implementation UIImageView (EKExtension)

- (void)ek_setImage:(UIImage *)image byCornerRaduis:(CGFloat)cornerRaduis byViewSize:(CGSize)viewSize {
    image = [image ek_addCornerRaduisRatio:(CGSize){cornerRaduis / viewSize.width,cornerRaduis / viewSize.height}];
    self.image = image;
}

@end
