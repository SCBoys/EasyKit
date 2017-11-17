//
//  NSArray+EKExtension.m
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import "NSArray+EKExtension.h"

@implementation NSArray (EKExtension)

- (NSArray *)ek_sortWithKeyPath:(NSString *)keyPath ascending:(BOOL)asc {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:keyPath ascending:asc];
    return [self sortedArrayUsingDescriptors:@[sort]];
}

- (void)ek_groupsWithKeyPath:(NSString *)groupKeyPath grouped:(void(^)(NSArray *grouped, id groupedKey))grouped {
    NSMutableArray *groupKeyValues = @[].mutableCopy;
    for (id element in self) {
        id groupKey_Value = [element valueForKeyPath:groupKeyPath];
        if (groupKey_Value == nil) {
            if (![groupKeyValues containsObject:[NSNull null]]) {
                [groupKeyValues addObject:[NSNull null]];
            }
        } else {
            if (![groupKeyValues containsObject:groupKey_Value]) {
                [groupKeyValues addObject:groupKey_Value];
            }
        }
    }
    for (id value in groupKeyValues) {
        NSArray *filterData = [self ek_filterWithKeyPath:groupKeyPath withValue:value];
        grouped(filterData,value);
    }
}

- (NSArray *)ek_filterWithKeyPath:(NSString *)keyPath withValue:(id)value {
    NSPredicate *pre;
    if ([value isKindOfClass:[NSNumber class]]) {
        pre = [NSPredicate predicateWithFormat:@"%K = %d",keyPath,[value integerValue]];
    } else {
        pre = [NSPredicate predicateWithFormat:@"%K = %@",keyPath,value];
    }
    
    NSArray *filter = [self filteredArrayUsingPredicate:pre];
    return filter;
}

@end
