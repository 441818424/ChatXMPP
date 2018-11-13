//
//  CXPCommonUITool.h
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/12.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPCommonUITool : NSObject
+ (UILabel *)createLabelWithText:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

+ (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder font:(CGFloat)font textColor:(UIColor *)textColor;
@end
