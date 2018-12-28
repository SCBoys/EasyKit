//
//  UIView+EKExtension.h
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EKKeyborderHook<NSObject>

/**
 返回键盘和视图的距离
 
 @param view 被指定的view
 @param offset offet < 0 的时候表示view 需要向上移动
 */
- (void)ekKeyborderHookDidMaskByView:(UIView *)view offset:(CGFloat)offset;
@end

@interface UIView (EKExtension)

- (UIViewController *)ek_viewController;

- (nullable NSLayoutConstraint *)ek_constraintWithAttribute:(NSLayoutAttribute)attribute;

- (void)ek_addKeyBorderHooker:(id<EKKeyborderHook>)delegate;
/**
 设置键盘事件的hooker
 @param cha 视图离键盘的距离，取大于0的数值
 */
- (void)ek_addKeyBorderHooker:(id<EKKeyborderHook>)delegate cha:(CGFloat)cha;
//移除
- (void)ek_removeKeyBorderHooker;
@end

NS_ASSUME_NONNULL_END
