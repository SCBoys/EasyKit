//
//  EKTextField.m
//  RoadHome
//
//  Created by TF14975 on 2017/6/22.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKTextField.h"

@interface EKTextField()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL textChangeByPaste;

@property (nonatomic, copy) NSString *currentText;
@end
@implementation EKTextField

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initObject];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initObject];
    }
    return self;
}

- (void)initObject {
    self.isNumberValue = NO;
    self.textChangeByPaste = YES;
    self.delegate = self;
    [self addTarget:self action:@selector(tf_textDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Delegate & DataSource
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.tf_delegate respondsToSelector:@selector(ekTextFieldDidBeginEditing:)]) {
        [self.tf_delegate ekTextFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self isDecimalMode]) {
        [self dealDecimalplace:textField.text];
    }
    if ([self.tf_delegate respondsToSelector:@selector(ekTextFieldDidEndEditing:)]) {
        [self.tf_delegate ekTextFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.textChangeByPaste = NO;
    
    if (string.length < range.length) {
        //删除字符
        return [self rhTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    NSMutableString *changedText  = textField.text.mutableCopy;
    [changedText replaceCharactersInRange:range withString:string];
    if (self.isNumberValue) {
        if ([textField.text isEqual:@"0"] && ![string isEqual:@"."]) {
            return NO;
        }
    }
    
    //总长度限制
    if (![self validateLength:changedText]) {
        return NO;
    }
    
    if ([self isNumberMode] || [self isDecimalMode]) {
        if (![self validateMaxNumber:changedText]) {
            return NO;
        }
    }
    if ([self isDecimalMode]) {
        if ([string isEqualToString:@"."]) {
            if ([textField.text rangeOfString:@"."].length != 0) {
                //已存在
                return NO;
            } else if (self.text.length == 0) {
                //未输入
                return NO;
            }
        } else {
            NSArray *comps = [changedText componentsSeparatedByString:@"."];
            if (comps.count > 0 &&
                //整数长度校验
                ![self validateIntegerLength:comps[0]]) {
                return NO;
            }
            if (comps.count == 2 &&
                //小数长度校验
                ![self validateDecimalLength:comps[1]]) {
                return NO;
            }
        }
    }
    
    return [self rhTextField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)rhTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.tf_delegate respondsToSelector:@selector(ekTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.tf_delegate ekTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

#pragma mark - event response
- (void)tf_textDidChange:(id)sender {
    if (!self.textChangeByPaste) {
        self.textChangeByPaste = YES;
        [self resetText];
        return;
    }
    
    if (![self validateLength:self.text]) {
        self.text = self.currentText;
        return;
    }
    
    [self resetText];
}

#pragma mark - public method

#pragma mark - private method
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.keyboardType == UIKeyboardTypeNumberPad || [self isDecimalMode]) {
        //数字键盘禁用粘贴功能
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)hideKeyboard {
    [self resignFirstResponder];
}

- (void)resetText {
    if ([self isDecimalMode]) {
        if ([self.text hasSuffix:@"."]) {
            return;
        }
    }
    self.currentText = self.text;
    if ([self.tf_delegate respondsToSelector:@selector(ekTextFieldDidChanged:)]) {
        [self.tf_delegate ekTextFieldDidChanged:self];
    }
}

- (NSString *)cutIntegerWithDecimal:(NSString *)decimal {
    if (decimal == nil) {
        return @"";
    }
    return [decimal componentsSeparatedByString:@"."][0];
}

- (BOOL)validateLength:(NSString *)text {
    if (self.limitLength == 0 || text.length <= self.limitLength) {
        return YES;
    }
    return NO;
}

- (BOOL)validateMaxNumber:(NSString *)numberString {
    if (self.maxNumber == 0) {
        return YES;
    }
    
    NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:numberString];
    NSDecimalNumber *maxNumber = [[NSDecimalNumber alloc] initWithString:self.maxNumber];
    
    NSComparisonResult result = [number compare:maxNumber];
    if (result == NSOrderedAscending || result == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

- (BOOL)validateIntegerLength:(NSString *)integer {
    if (self.limitIntegerLength == 0 || integer.length <= self.limitIntegerLength) {
        return YES;
    }
    return NO;
}

- (BOOL)validateDecimalLength:(NSString *)decimal {
    if (self.limitDicimalLength == 0 || decimal.length <= self.limitDicimalLength) {
        return YES;
    }
    return NO;
}

- (void)dealDecimalplace:(NSString *)text {
    if (self.decimalPlace == 0) {
        if ([text hasSuffix:@"."]) {
            self.text = [self cutIntegerWithDecimal:text];
        }
    } else if (self.text.length > 0) {
        //小数点后面需要保留位数
        NSArray *comps = [text componentsSeparatedByString:@"."];
        NSMutableString *decimal = @"".mutableCopy;
        if (comps.count == 2) {
            [decimal appendString:comps[1]];
        }
        if (decimal.length < self.decimalPlace) {
            NSUInteger count = self.decimalPlace - decimal.length;
            for (int i = 0; i < count; i++) {
                [decimal appendString:@"0"];
            }
            NSString *integer = @"0";
            if (comps.count > 0 && [comps[0] length] > 0) {
                integer = comps[0];
            }
            self.text = [NSString stringWithFormat:@"%@.%@",integer,decimal];
        }
    }
    
    if ([self.text hasPrefix:@"."]) {
        self.text = [NSString stringWithFormat:@"0%@",self.text];
    }
    if (![self.currentText isEqualToString:self.text]) {
        self.currentText = self.text;
        if ([self.tf_delegate respondsToSelector:@selector(ekTextFieldDidChanged:)]) {
            [self.tf_delegate ekTextFieldDidChanged:self];
        }
    }
}

- (BOOL)isNumberMode {
    return self.keyboardType == UIKeyboardTypeNumberPad;
}

- (BOOL)isDecimalMode {
    return self.keyboardType == UIKeyboardTypeDecimalPad;
}

#pragma mark - getters and setters

@end
