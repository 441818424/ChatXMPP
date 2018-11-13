//
//  CXPCommonUITool.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/12.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPCommonUITool.h"

@implementation CXPCommonUITool

+ (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    return label;
}

+ (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder font:(CGFloat)font textColor:(UIColor *)textColor
{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:font];
    textField.textColor = textColor;
    return textField;
}
@end
