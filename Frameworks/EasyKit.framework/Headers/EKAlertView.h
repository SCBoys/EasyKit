//
//  EKAlertView.h
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKAlertAction.h"

typedef enum : NSUInteger {
    EKAlertViewStyleAlert,
    EKAlertViewStyleActionSheet
} EKAlertViewStyle;

NS_ASSUME_NONNULL_BEGIN

@interface EKAlertView : NSObject

+ (instancetype)alertWithTitle:(nullable NSString *)title
                      messsage:(nullable NSString *)message
                preferredStyle:(EKAlertViewStyle)preferredStyle;

- (void)addAction:(EKAlertAction *)action;
- (void)addActions:(NSArray<EKAlertAction *> *)actions;

- (void)showOnController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
