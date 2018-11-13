//
//  CXPLoginViewController.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/12.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPLoginViewController.h"
#import "CXPRegisterViewController.h"

@interface CXPLoginViewController ()

/** <#注释#> */
@property (nonatomic,strong) UILabel *userNameLab;
/** <#注释#> */
@property (nonatomic,strong) UITextField *userNameTextField;
/** <#注释#> */
@property (nonatomic,strong) UILabel *passwordLabel;
/** <#注释#> */
@property (nonatomic,strong) UITextField *passwordTextField;
/** <#注释#> */
@property (nonatomic,strong) UIButton *loginBtn;



@end

@implementation CXPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
   
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
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor greenColor];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@30);
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(jumpRegister)];
}

- (void)loginAction
{
    
    
}
- (void)jumpRegister
{
    CXPRegisterViewController *registerVC = [[CXPRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
