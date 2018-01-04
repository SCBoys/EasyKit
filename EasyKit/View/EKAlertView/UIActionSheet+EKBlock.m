//
//  UIActionSheet+EKBlock.m
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "UIActionSheet+EKBlock.h"
#import <objc/runtime.h>

const void *kSheetBlockKey;

@interface UIActionSheet ()<UIActionSheetDelegate>

@end
@implementation UIActionSheet (TFBlock)

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message clicked:(SheetCallBack)clicked {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    sheet.delegate = sheet;
    
    if (clicked) {
        objc_setAssociatedObject(sheet, kSheetBlockKey, clicked, OBJC_ASSOCIATION_COPY);
    }
    return sheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SheetCallBack callback = objc_getAssociatedObject(actionSheet, kSheetBlockKey);
    if (callback) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        callback(buttonTitle,buttonIndex);
        objc_removeAssociatedObjects(actionSheet);
    }
}

@end
