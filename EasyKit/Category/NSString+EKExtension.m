//
//  NSString+EKExtension.m
//  EasyKitDemo
//
//  Created by John TSai on 2018/1/18.
//  Copyright © 2018年 EK. All rights reserved.
//

#import "NSString+EKExtension.h"

@implementation NSString (EKExtension)

- (BOOL)ek_isNotEmptyString {
    NSString *string = self;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return (![string isEqual:[NSNull null]] && ![string isEqualToString:@""]);
}

- (BOOL)ek_containsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         //单个字符长度大于等于判断为emoji表情
         if (substring.length >= 2) {
             returnValue = YES;
             *stop = YES;
         }
     }];
    
    return returnValue;
}

@end

@implementation NSString (CalculateSize)

- (CGSize)ek_textSizeWithFont:(UIFont *)font {
    CGSize textSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    textSize = CGSizeMake((int)ceil(textSize.width), (int)ceil(textSize.height));
    return textSize;
}

- (CGSize)ek_textSizeWithFont:(UIFont *)font
             numberOfLines:(NSInteger)numberOfLines
               lineSpacing:(CGFloat)lineSpacing
          constrainedWidth:(CGFloat)constrainedWidth
          isLimitedToLines:(BOOL *)isLimitedToLines {
    
    if (self.length == 0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(constrainedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数
    if (numberOfLines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
        }
    }else{
        if (rows > numberOfLines) {
            rows = numberOfLines;
            if (isLimitedToLines) {
                *isLimitedToLines = YES;  //被限制
            }
        }
        realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
    }
    
    return CGSizeMake(ceil(constrainedWidth),ceil(realHeight));
}

@end
