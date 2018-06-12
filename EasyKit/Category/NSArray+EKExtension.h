//
//  NSArray+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (EKExtension)

/**
 排序
 */
- (NSArray *)ek_sortWithKeyPath:(nullable NSString *)keyPath ascending:(BOOL)asc;

/**
 分组， 支持字符串和值类型
 
 @param groupKeyPath 分组字段
 */
- (void)ek_groupsWithKeyPath:(NSString *)groupKeyPath grouped:(void(^)(NSArray *grouped, id groupedKey))grouped;


/**
 过滤
 @param keyPath keyPath
 @param value NSString 或者 NSNumber
 */
- (nullable NSArray *)ek_filterWithKeyPath:(NSString *)keyPath withValue:(id)value;


@end

NS_ASSUME_NONNULL_END
