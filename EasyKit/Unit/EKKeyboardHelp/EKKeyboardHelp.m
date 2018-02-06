//
//  EKKeyboardHelp.m
//  RoadHome
//
//  Created by TF14975 on 2018/2/5.
//  Copyright © 2018年 Transfar. All rights reserved.
//

#import "EKKeyboardHelp.h"

@implementation EKKeyboardHelp

+ (CGFloat)overlappingHeightByView:(UIView *)adjustView keyboardFrameChangedNotification:(NSNotification *)notification {
    CGRect adjustViewFrameInWindow = [adjustView convertRect:adjustView.bounds toView:nil];
    CGFloat contentMaxY = CGRectGetMaxY(adjustViewFrameInWindow);
    
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardEndOriginY = keyboardEndFrame.origin.y;
    CGFloat cha = keyboardEndOriginY - contentMaxY;
    return cha;
}

@end
