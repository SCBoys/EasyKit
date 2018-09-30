//
//  UIViewController+EKExtension.m
//  EasyKit
//
//  Created by TF14975 on 2018/9/30.
//  Copyright © 2018年 EK. All rights reserved.
//

#import "UIViewController+EKExtension.h"

@implementation UIViewController (EKExtension)

- (void)ek_removeCurrentController {
    [self ek_removeControllers:1];
}

- (void)ek_removeControllers:(NSUInteger)count {
    UINavigationController *nav;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self;
    } else {
        nav = self.navigationController;
    }
    NSMutableArray *vcs = nav.viewControllers.mutableCopy;
    NSInteger index = 1 + count;
    if (vcs.count > index) {
        [vcs removeObjectsInRange:NSMakeRange(vcs.count - index, count)];
    }
    nav.viewControllers = vcs.copy;
}


@end
