//
//  UIViewController+EKExtension.h
//  EasyKit
//
//  Created by TF14975 on 2018/9/30.
//  Copyright © 2018年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (EKExtension)

- (void)ek_removeCurrentController;

- (void)ek_removeControllers:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
