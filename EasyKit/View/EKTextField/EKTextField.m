//
//  EKTextField.m
//  RoadHome
//
//  Created by TF14975 on 2017/6/22.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKTextField.h"

NS_ASSUME_NONNULL_BEGIN

@class EKTextField;
@interface EKTextFieldProxy : NSObject<UITextFieldDelegate>
@property (nonatomic, weak) EKTextField *textfield;
@end

NS_ASSUME_NONNULL_END

@implementation EKTextFieldProxy

#pragma mark - Delegate & DataSource
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.textfield.tf_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.textfield.tf_delegate textFieldShouldBeginEditing:self.textfield];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.textfield.tf_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.textfield.tf_delegate textFieldShouldEndEditing:self.textfield];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.textfield.tf_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.textfield.tf_delegate textFieldShouldReturn:self.textfield];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.textfield.tf_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.textfield.tf_delegate textFieldDidBeginEditing:self.textfield];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.textfield isDecimalMode]) {
        [self.textfield dealDecimalplace:textField.text];
    }
    if ([self.textfield.tf_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.textfield.tf_delegate textFieldDidEndEditing:self.textfield];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.textfield.disableEmoji && [self.textfield ek_containsEmoji:string]) {
        return NO;
    }
    if (self.textfield.disableSpecialCharacter && [self.textfield ek_containsSpecialCharacter:string]) {
        return NO;
    }
    
    if (string.length < range.length) {
        //删除字符
        return [self.textfield rhTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    ///改变后的字符串
    NSMutableString *changedText  = textField.text.mutableCopy;
    [changedText replaceCharactersInRange:range withString:string];
    if (self.textfield.isNumberValue) {
        if ([textField.text isEqual:@"0"] && ![string isEqual:@"."]) {
            return NO;
        }
    }
    
    //总长度超出限制
    NSInteger remainlength = ((NSInteger)self.textfield.limitLength) - ((NSInteger)textField.text.length);
    if (self.textfield.limitLength != 0 && (remainlength == 0 || (remainlength > 0 && remainlength < string.length))) {
        if (remainlength > 0 && remainlength < string.length) { //其他情况，比如粘贴的字符串大于剩余的，作截取
            NSUInteger toIndex = remainlength;
            NSString *remainedString = [string substringToIndex:toIndex];
            [self.textfield insertText:remainedString];
        }
        return NO;
    }
    
    if ([self.textfield isNumberMode] || [self.textfield isDecimalMode]) {
        if (![self.textfield validateMaxNumber:changedText]) {
            return NO;
        }
    }
    if ([self.textfield isDecimalMode]) {
        if ([string isEqualToString:@"."]) {
            if ([textField.text rangeOfString:@"."].length != 0) {
                //已存在
                return NO;
            } else if (self.textfield.text.length == 0) {
                //未输入
                return NO;
            }
        } else {
            NSArray *comps = [changedText componentsSeparatedByString:@"."];
            if (comps.count > 0 &&
                //整数长度校验
                ![self.textfield validateIntegerLength:comps[0]]) {
                return NO;
            }
            if (comps.count == 2 &&
                //小数长度校验
                ![self.textfield validateDecimalLength:comps[1]]) {
                return NO;
            }
        }
    }
    
    return [self.textfield rhTextField:textField shouldChangeCharactersInRange:range replacementString:string];
}
@end

@interface EKTextField()<UITextFieldDelegate>
@property (nonatomic, strong) EKTextFieldProxy *proxy;

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
    self.proxy = [[EKTextFieldProxy alloc] init];
    self.proxy.textfield = self;
    self.delegate = self.proxy;
}

- (BOOL)rhTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.tf_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.tf_delegate textField:(EKTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

#pragma mark - event response

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

- (NSString *)cutIntegerWithDecimal:(NSString *)decimal {
    if (decimal == nil) {
        return @"";
    }
    return [decimal componentsSeparatedByString:@"."][0];
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
            [self sendActionsForControlEvents:UIControlEventEditingChanged];
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
            [self sendActionsForControlEvents:UIControlEventEditingChanged];
        }
    }
    
    if ([self.text hasPrefix:@"."]) {
        self.text = [NSString stringWithFormat:@"0%@",self.text];
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
    }
}

- (BOOL)isNumberMode {
    return self.keyboardType == UIKeyboardTypeNumberPad;
}

- (BOOL)isDecimalMode {
    return self.keyboardType == UIKeyboardTypeDecimalPad;
}


#pragma mark - getters and setters
- (BOOL)ek_containsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         //单个字符长度大于等于判断为emoji表情
         if (substring.length >= 2) {
             returnValue = YES;
             *stop = YES;
         }
     }];
    
    return returnValue;
}

- (BOOL)ek_containsSpecialCharacter:(NSString *)string
{
    NSString *characterRegex = @"[`~!@#$^&*()=|{}':;',\\[\\].<>/?！@￥……&*（）—|{}【】\\-‘；：“”'。\\\\，、？+•%_\\£\\€\\x22]";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",characterRegex];
    return [pre evaluateWithObject:string];
}

@end
