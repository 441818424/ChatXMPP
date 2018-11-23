//
//  CXPBaseTabbarController.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/21.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPBaseTabbarController.h"
#import "CXPMessageViewController.h"
#import "CXPContactsViewController.h"
#import "CXPMeViewController.h"

@interface CXPBaseTabbarController ()

@end

@implementation CXPBaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViewController];
}

- (void)creatSubViewController
{
    CXPMessageViewController *msgVC = [[CXPMessageViewController alloc] init];
    [self setupSubController:msgVC title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
   
    CXPContactsViewController *contactVC = [[CXPContactsViewController alloc] init];
    [self setupSubController:contactVC title:@"联系人" imageName:@"tabbar_contacts" selectedImageName:@"tabbar_contactsHL"];
    
    CXPMeViewController *meVC = [[CXPMeViewController alloc] init];
    [self setupSubController:meVC title:@"我" imageName:@"tabbar_me" selectedImageName:@"tabbar_meHL"];
}


- (void)setupSubController:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:naviVC];
    
    
}

@end


