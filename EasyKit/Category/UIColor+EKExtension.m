//
//  UIColor+EKExtension.m
//  EasyKitDemo
//
//  Created by TF14975 on 2018/6/12.
//  Copyright © 2018年 EK. All rights reserved.
//

#import "UIColor+EKExtension.h"

@implementation UIColor (EKExtension)

+ (UIColor *)ek_colorWithHex:(NSString *)hexStr {
    return [UIColor ek_colorWithHex:hexStr alpha:1.0];
}


+ (UIColor *)ek_colorWithHex:(NSString *)hexStr alpha:(CGFloat)alpha {
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexInt & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexInt & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexInt & 0xFF))/255
                    alpha:alpha > 1.0 ? 1.0 : alpha];
    
    return color;
}
@end
