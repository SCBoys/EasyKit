//
//  NSMutableAttributedString+EKExtension.h
//  RoadHome
//
//  Created by TF14975 on 2017/6/14.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (EKExtension)

- (void)ek_appendString:(NSString *)attrString withFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor;

- (void)ek_appendString:(NSString *)attrString withFont:(UIFont *)font andTextColor:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
