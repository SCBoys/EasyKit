//
//  EKAlertView.m
//  RoadHome
//
//  Created by xiaofeishen on 2017/3/1.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKAlertView.h"
#import "UIAlertView+EKBlock.h"
#import "UIActionSheet+EKBlock.h"

@interface EKAlertView ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) EKAlertViewStyle preferredStyle;

@property (nonatomic, strong) NSMutableArray<EKAlertAction *> *actions;
@end
@implementation EKAlertView

#pragma mark - public method
+ (instancetype)alertWithTitle:(NSString *)title
                      messsage:(NSString *)message
                preferredStyle:(EKAlertViewStyle)preferredStyle {
    EKAlertView *alert = [[EKAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    alert.preferredStyle = preferredStyle;
    return alert;
}

- (void)addAction:(EKAlertAction *)action {
    [self addActions:@[action]];
}

- (void)addActions:(NSArray<EKAlertAction *> *)actions {
    [self.actions addObjectsFromArray:actions];
}

- (void)showOnController:(UIViewController *)viewController {
    if (@available(iOS 8.0, *)) {
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        if (self.preferredStyle == EKAlertViewStyleActionSheet) {
            style = UIAlertControllerStyleActionSheet;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:style];
        for (EKAlertAction *tfAction in self.actions) {
            UIAlertAction *action = [self alertActionWithEKAlertAction:tfAction];
            [alert addAction:action];
        }
        [viewController presentViewController:alert animated:YES completion:nil];
    } else {
        //兼容ios8 以前
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        EKAlertAction *cancelAction = [self actionWithStyle:EKAlertActionStyleCancel];
        if (self.preferredStyle == EKAlertViewStyleAlert) {
            //alert
            UIAlertView *alert = [UIAlertView alertWithTitle:self.title message:self.message clicked:^(NSString *title, NSInteger buttonIndex) {
                EKAlertAction *action = self.actions[buttonIndex];
                if (action.handler) {
                    action.handler(action);
                    action.handler = nil;
                }
            }];
            
            for (EKAlertAction *action in self.actions) {
                [alert addButtonWithTitle:action.title];
            }
            alert.cancelButtonIndex = [self.actions indexOfObject:cancelAction];
            
            [alert show];
        } else {
            EKAlertAction *destAction = [self actionWithStyle:EKAlertActionStyleDestructive];
            //action sheet
            UIActionSheet *sheet = [UIActionSheet actionSheetWithTitle:self.title message:self.message clicked:^(NSString *title, NSInteger buttonIndex) {
                EKAlertAction *action = self.actions[buttonIndex];
                if (action.handler) {
                    action.handler(action);
                    action.handler = nil;
                }
            }];
            for (EKAlertAction *action in self.actions) {
                [sheet addButtonWithTitle:action.title];
            }
            sheet.cancelButtonIndex = [self.actions indexOfObject:cancelAction];
            sheet.destructiveButtonIndex = [self.actions indexOfObject:destAction];
            
            [sheet showInView:viewController.view];
        }
#endif
    }
}

#pragma mark - private method
- (UIAlertAction *)alertActionWithEKAlertAction:(EKAlertAction *)tfAction __AVAILABILITY_INTERNAL__IPHONE_8_0 {
    UIAlertActionStyle style;
    switch (tfAction.actionStyle) {
        case EKAlertActionStyleDefault:
            style = UIAlertActionStyleDefault;
            break;
        case EKAlertActionStyleCancel:
            style = UIAlertActionStyleCancel;
            break;
        case EKAlertActionStyleDestructive:
            style = UIAlertActionStyleDestructive;
            break;
        default:
            break;
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:tfAction.title style:style handler:^(UIAlertAction * _Nonnull action) {
        if (tfAction.handler) {
            tfAction.handler(tfAction);
            //broken cycle
            tfAction.handler = nil;
        }
    }];
    return action;
}

- (EKAlertAction *)actionWithStyle:(EKAlertActionStyle)style {
    for (EKAlertAction *action in self.actions) {
        if (action.actionStyle == style) {
            return action;
        }
    }
    return nil;
}

#pragma mark - Getter
- (NSMutableArray<EKAlertAction *> *)actions {
    if (!_actions) {
        _actions = @[].mutableCopy;
    }
    return _actions;
}

@end
