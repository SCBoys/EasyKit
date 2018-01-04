//
//  UIAlertView+EKBlock.h
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertCallBack)(NSString *title, NSInteger buttonIndex);

@interface UIAlertView (TFBlock)

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message clicked:(nullable AlertCallBack)clicked;

@end


NS_ASSUME_NONNULL_END
