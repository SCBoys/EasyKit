//
//  EKTextField.h
//  RoadHome
//
//  Created by TF14975 on 2017/6/22.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EKTextField;
@protocol EKTextFieldDelegate <NSObject>
@optional
- (BOOL)ekTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)ekTextFieldDidBeginEditing:(EKTextField *)textfield;
- (void)ekTextFieldDidEndEditing:(EKTextField *)textfield;
- (void)ekTextFieldDidChanged:(EKTextField *)textfield;
@end
@interface EKTextField : UITextField

@property (nonatomic, weak) id<EKTextFieldDelegate> tf_delegate;
// 总长度限制  0表示不限制
@property (nonatomic, assign) NSUInteger limitLength;
// 数值限制， 0表示不限制 (该属性只对UIKeyboardTypeDecimalPad,UIKeyboardTypeNumberPad 有效)
@property (nonatomic, copy) NSString *maxNumber;
// 整数位限制， 0表示不限制 (该属性只对UIKeyboardTypeDecimalPad 有效)
@property (nonatomic, assign) NSUInteger limitIntegerLength;
// 小数位限制， 0表示不限制 (该属性只对UIKeyboardTypeDecimalPad 有效)
@property (nonatomic, assign) NSUInteger limitDicimalLength;
// 是否是数值类型，默认值是no。 值为yes的时候， 整数0后面只能输入小数点（.）,不能输入其他的。
@property (nonatomic, assign) BOOL isNumberValue;
// 小数点后面保留位数， 0表示不保留
@property (nonatomic, assign) NSUInteger decimalPlace;
// 小数键盘的时候，用这个取值
@property (nonatomic, copy, readonly) NSString *currentText;

// 禁用emoji表情输入， 默认NO
@property (nonatomic, assign) BOOL disableEmoji;

@end
