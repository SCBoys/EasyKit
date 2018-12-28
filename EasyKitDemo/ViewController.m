//
//  ViewController.m
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/16.
//  Copyright © 2017年 EK. All rights reserved.
//

#import "ViewController.h"
#import "EKTextField.h"
#import "UIView+EKExtension.h"

@interface ViewController ()<EKTextFieldDelegate,EKKeyborderHook>
@property (nonatomic, strong) EKTextField *textfield1;
@property (nonatomic, strong) EKTextField *textfield2;
@property (nonatomic, strong) UIView *container;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.view.bounds.size;
    _container = [[UIView alloc] initWithFrame:(CGRect){20,size.height - 110 - 200,375,110}];
    _container.backgroundColor = UIColor.yellowColor;
    [_container ek_addKeyBorderHooker:self cha:0];
    [self.view addSubview:_container];
    
    _textfield1 = [[EKTextField alloc] initWithFrame:(CGRect){10,10,300,44}];
    _textfield1.backgroundColor = UIColor.greenColor;
//    _textfield1.autoAdjustKeyboard = YES;
    _textfield1.placeholder = @"输入手机号";
    _textfield1.tf_delegate = self;
//    _textfield1.cha = 30;
    [_container addSubview:_textfield1];
    
    
    _textfield2 = [[EKTextField alloc] initWithFrame:(CGRect){10,64,300,44}];
    _textfield2.backgroundColor = UIColor.greenColor;
//    _textfield2.autoAdjustKeyboard = YES;
    _textfield2.placeholder = @"输入验证码";
    _textfield2.tf_delegate = self;
//    _textfield2.cha = 30;
    [_container addSubview:_textfield2];
}

- (void)ekKeyborderHookDidMaskByView:(UIView *)view offset:(CGFloat)offset {
    _container.center = CGPointMake(_container.center.x, _container.center.y + offset);
}

- (BOOL)ekTextFieldShouldReturn:(EKTextField *)textfield {
    [textfield resignFirstResponder];
    return YES;
}

//- (void)ekTextFieldKeyboardFrameChange:(EKTextField *)textfield shouldMoveOffset:(CGFloat)offset {
//    _container.center = CGPointMake(_container.center.x, _container.center.y + offset);
//}

@end
