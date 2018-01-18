//
//  NSString+EKExtension.h
//  EasyKitDemo
//
//  Created by John TSai on 2018/1/18.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EKExtension)

/**
 check string instance if is a empty string

 @return string is empty string return NO, otherwise YES.
 */
- (BOOL)ek_isNotEmptyString;

@end
