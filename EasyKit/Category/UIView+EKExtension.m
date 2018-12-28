//
//  UIView+EKExtension.m
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/17.
//  Copyright © 2017年 EK. All rights reserved.
//

#import "UIView+EKExtension.h"
#import <objc/runtime.h>

@interface EKKeyboardHooker : NSObject
@property (nonatomic, weak) id<EKKeyborderHook> object;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat cha;
@property (nonatomic, weak) UIView *view;
@end
@implementation EKKeyboardHooker
@end

const void *ekKeyborderHookerKey = "ekKeyborderHookerKey";
@implementation UIView (EKExtension)

- (UIViewController *)ek_viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (NSLayoutConstraint *)ek_constraintWithAttribute:(NSLayoutAttribute)attribute {
    NSMutableArray<NSLayoutConstraint *> *constraintstmp;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        constraintstmp = self.constraints.mutableCopy;
    } else {
        constraintstmp = self.superview.constraints.mutableCopy;
    }
    if (constraintstmp.count == 0) { return nil; }
    for (NSLayoutConstraint *item in constraintstmp) {
        if (item.firstItem == self && item.firstAttribute == attribute) {
            return item;
        } else if (item.secondItem == self && item.secondAttribute == attribute) {
            return item;
        }
    }
    return nil;
}

- (void)ek_removeKeyBorderHooker {
    objc_setAssociatedObject(self, ekKeyborderHookerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)ek_addKeyBorderHooker:(id<EKKeyborderHook>)delegate {
    [self ek_addKeyBorderHooker:delegate cha:0];
}
- (void)ek_addKeyBorderHooker:(id<EKKeyborderHook>)delegate cha:(CGFloat)cha {
    if (!delegate) {
        return;
    }
    id tmp = objc_getAssociatedObject(self, ekKeyborderHookerKey);
    if (tmp) {
        return;
    }
    EKKeyboardHooker *hooker = [[EKKeyboardHooker alloc] init];
    hooker.object = delegate;
    hooker.cha = cha;
    hooker.view = self;
    objc_setAssociatedObject(self, ekKeyborderHookerKey, hooker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyborderChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyborderChangeFrame:(NSNotification *)noti {
    EKKeyboardHooker *hooker = objc_getAssociatedObject(self, ekKeyborderHookerKey);
    if (!hooker) {
        return;
    }
    if (![hooker.object respondsToSelector:@selector(ekKeyborderHookDidMaskByView:offset:)]) {
        return;
    }
    
    NSDictionary *userinfo = noti.userInfo;
    CGRect beginFrame = [userinfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGSize windowSize = window.bounds.size;
    BOOL keyborderShow = windowSize.height == beginFrame.origin.y;
    BOOL keyborderSizeChange = beginFrame.size.height != endFrame.size.height;
    
    UIView *view = self;
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    CGFloat viewMaxY = CGRectGetMaxY(viewRect) + hooker.cha;
    
    CGFloat offset = 0; //视图需要位移的距离
    if (keyborderShow) { //键盘显示
        CGFloat tmp = CGRectGetMinY(endFrame) - viewMaxY;
        if (tmp < 0) {
            offset = tmp;
        }
        hooker.offset = offset;
    } else if (keyborderSizeChange) { //键盘高度改变
        CGFloat tmp = CGRectGetMinY(endFrame) - viewMaxY;
        if (tmp < 0) {
            offset = - CGRectGetHeight(endFrame) + CGRectGetHeight(beginFrame);
        }
        hooker.offset += offset;
    } else { //键盘隐藏
        //复原
        offset = -hooker.offset;
        hooker.offset = 0;
    }
    
    [hooker.object ekKeyborderHookDidMaskByView:view offset:offset];
}

@end
