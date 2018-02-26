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
