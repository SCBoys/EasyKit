//
//  EKAlertAction.m
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKAlertAction.h"

@implementation EKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                    actionStyle:(EKAlertActionStyle)actionStyle
                       handler:(void(^)(EKAlertAction *action))handler {
    EKAlertAction *action = [[EKAlertAction alloc] init];
    action.title = title;
    action.actionStyle = actionStyle;
    action.handler = handler;
    return action;
}

@end
