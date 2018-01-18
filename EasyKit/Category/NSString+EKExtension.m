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

@end
