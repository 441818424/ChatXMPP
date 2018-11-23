//
//  CXPXMPPManager.h
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/13.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef void(^SuccessBlock)(void);
typedef void(^FailureBlock)(NSError *error);
#define DOMAINNAME @"local.host"
#define RESOURCE @"iOS"

@interface CXPXMPPManager : NSObject
/** <#注释#> */
@property (nonatomic,strong) XMPPRoster *xmppRoster;

+ (instancetype)sharedXMPPManager;
//登录
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password successHandle:(SuccessBlock)successHandle failureHandle:(FailureBlock)failureHandle;
//注册
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password successHandle:(SuccessBlock)successHandle failureHandle:(FailureBlock)failureHandle;
//登出
- (void)logout;

@end
