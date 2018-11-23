//
//  CXPRegisterViewController.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/12.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPRegisterViewController.h"
#import "CXPXMPPManager.h"


@interface CXPRegisterViewController ()

/** <#注释#> */
@property (nonatomic,strong) UILabel *userNameLab;
/** <#注释#> */
@property (nonatomic,strong) UITextField *userNameTextField;
/** <#注释#> */
@property (nonatomic,strong) UILabel *passwordLabel;
/** <#注释#> */
@property (nonatomic,strong) UITextField *passwordTextField;
/** <#注释#> */
@property (nonatomic,strong) UIButton *registerBtn;
@end

@implementation CXPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册";
   
    self.userNameLab = [CXPCommonUITool createLabelWithText:@"用户名" font:14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(94);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    self.userNameTextField = [CXPCommonUITool createTextFieldWithPlaceholder:@"请输入用户名" font:14 textColor:[UIColor blackColor]];
    [self.view addSubview:_userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(94);
        make.left.equalTo(self.userNameLab.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@30);
    }];
    
    self.passwordLabel = [CXPCommonUITool createLabelWithText:@"密码" font:14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    self.passwordTextField = [CXPCommonUITool createTextFieldWithPlaceholder:@"请输入密码" font:14 textColor:[UIColor blackColor]];
    [self.view addSubview:_passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(10);
        make.left.equalTo(self.passwordLabel.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@30);
    }];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.registerBtn.backgroundColor = [UIColor greenColor];
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@30);
    }];
}

- (void)registerAction
{
    [[CXPXMPPManager sharedXMPPManager] registerWithUserName:_userNameTextField.text password:_passwordTextField.text successHandle:^{
        NSLog(@"注册成功");
        [MBProgressHUD showSuccess:@"注册成功，请登录"];
        [self.navigationController popViewControllerAnimated:YES];
    } failureHandle:^(NSError *error) {
        [MBProgressHUD showError:@"注册失败"];
        NSLog(@"注册失败");
    }];
    
}


@end
