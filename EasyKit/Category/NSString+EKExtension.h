//
//  NSString+EKExtension.h
//  EasyKitDemo
//
//  Created by John TSai on 2018/1/18.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EKExtension)

/**
 check string instance if is a empty string

 @return string is empty string return NO, otherwise YES.
 */
- (BOOL)ek_isNotEmptyString;


/**
 check string is contain emoji

 @return yes, contained
 */
- (BOOL)ek_containsEmoji;

@end

NS_ASSUME_NONNULL_END

