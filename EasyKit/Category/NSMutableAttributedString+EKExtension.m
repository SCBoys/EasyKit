//
//  NSMutableAttributedString+EKExtension.m
//  RoadHome
//
//  Created by TF14975 on 2017/6/14.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "NSMutableAttributedString+EKExtension.h"

@implementation NSMutableAttributedString (EKExtension)

- (void)ek_appendString:(NSString *)attrString withFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor {
    [self ek_appendString:attrString withFont:[UIFont systemFontOfSize:fontSize] andTextColor:textColor];
}

- (void)ek_appendString:(NSString *)attrString withFont:(UIFont *)font andTextColor:(UIColor *)textColor {
    if (attrString.length == 0) {
        return;
    }
    NSAttributedString *attriText = [[NSAttributedString alloc] initWithString:attrString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    [self appendAttributedString:attriText];
}

@end
