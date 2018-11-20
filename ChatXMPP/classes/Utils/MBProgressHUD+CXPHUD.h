//
//  MBProgressHUD+CXPHUD.h
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/20.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (CXPHUD)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
