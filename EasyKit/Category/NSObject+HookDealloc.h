//
//  NSObject+HookDealloc.h
//  EasyKitDemo
//
//  Created by TF14975 on 2018/5/4.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HookDealloc)


/**
 hook当前当前的delloc方法

 @param callback 当改对象被释放的时候，调用。
 */
- (void)addObserverWhenThisObjectDidDelloced:(void(^)(void))callback;


/**
 hook当前当前的delloc方法

 @param observer observer不能为当前对象，否则无法回调，应该当前对象已被释放
 @param selector 方法回调
 */
- (void)addObserverWhenThisObjectDidDelloced:(id)observer selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
