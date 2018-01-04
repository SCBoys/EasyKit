//
//  UIAlertView+EKBlock.m
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "UIAlertView+EKBlock.h"
#import <objc/runtime.h>

const void *kAlertBlockKey;

@interface UIAlertView ()<UIAlertViewDelegate>

@end
@implementation UIAlertView (TFBlock)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message clicked:(AlertCallBack)clicked {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    alert.delegate = alert;
    
    if (clicked) {
        objc_setAssociatedObject(alert, kAlertBlockKey, clicked, OBJC_ASSOCIATION_COPY);
    }
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AlertCallBack callback = objc_getAssociatedObject(alertView, kAlertBlockKey);
    if (callback) {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        callback(buttonTitle,buttonIndex);
        objc_removeAssociatedObjects(alertView);
    }
}

@end
