//
//  NSObject+HookDealloc.m
//  EasyKitDemo
//
//  Created by TF14975 on 2018/5/4.
//  Copyright © 2018年 EK. All rights reserved.
//

#import "NSObject+HookDealloc.h"
#import <objc/runtime.h>

const void *monitorKey = "monitorKey";

@interface EKDellocMonitor:NSObject
@property (nonatomic, copy) void(^callback)(void) ;

@property (nonatomic, weak) id observer;
@property (nonatomic, assign) SEL seletor;
@end
@implementation EKDellocMonitor

- (instancetype)initWithBlock:(void(^)(void))block
{
    self = [super init];
    if (self) {
        self.callback = block;
    }
    return self;
}

- (instancetype)initWithObserver:(id)observer selector:(SEL)selector {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.seletor = selector;
    }
    return self;
}

- (void)dealloc
{
    if (self.observer && [self.observer respondsToSelector:self.seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.observer performSelector:self.seletor];
#pragma clang diagnostic pop
    } else {
        if (self.callback) {
            self.callback();
            self.callback = nil;
        }
    }
}

@end

@implementation NSObject (HookDealloc)

- (void)addObserverWhenThisObjectDidDelloced:(void(^)(void))callback {
    EKDellocMonitor *monitor = [[EKDellocMonitor alloc] initWithBlock:callback];
    objc_setAssociatedObject(self, monitorKey, monitor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addObserverWhenThisObjectDidDelloced:(id)observer selector:(SEL)selector {
    EKDellocMonitor *monitor = [[EKDellocMonitor alloc] initWithObserver:observer selector:selector];
    objc_setAssociatedObject(self, monitorKey, monitor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
