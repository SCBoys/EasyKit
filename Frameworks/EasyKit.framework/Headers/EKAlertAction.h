//
//  EKAlertAction.h
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EKAlertActionStyle) {
    EKAlertActionStyleDefault = 0,
    EKAlertActionStyleCancel,
    EKAlertActionStyleDestructive
};

NS_ASSUME_NONNULL_BEGIN

@interface EKAlertAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) EKAlertActionStyle actionStyle;
/**
 在点击按钮之后，会被EKAlertView处理成nil。所以不用担心循环引用
 */
@property (nonatomic, copy, nullable) void(^handler)(EKAlertAction *);

+ (instancetype)actionWithTitle:(nullable NSString *)title
                    actionStyle:(EKAlertActionStyle)actionStyle
                        handler:(nullable void(^)(EKAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
