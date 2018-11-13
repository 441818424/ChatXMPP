//
//  CXPXMPPManager.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/13.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPXMPPManager.h"
@interface CXPXMPPManager()
/** <#注释#> */
@property (nonatomic,strong) XMPPStream *xmppStream;
/** <#注释#> */
@property (nonatomic,strong) XMPPReconnect *xmppReconnect;
/** <#注释#> */
@property (nonatomic,strong) XMPPRoster *xmppRoster;
/** <#注释#> */
@property (nonatomic,strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
/** <#注释#> */
@property (nonatomic,strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
/** <#注释#> */
@property (nonatomic,strong) XMPPvCardTempModule *xmppvCardTempModule;
/** <#注释#> */
@property (nonatomic,strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
/** <#注释#> */
@property (nonatomic,strong) XMPPCapabilities *xmppCapabilities;
/** <#注释#> */
@property (nonatomic,strong) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@end
@implementation CXPXMPPManager

+ (instancetype)sharedXMPPManager
{
    static CXPXMPPManager *_xmppManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _xmppManager = [[CXPXMPPManager alloc] init];
        [_xmppManager setupStream];
    });
    return _xmppManager;
}

- (void)setupStream
{
    self.xmppStream = [[XMPPStream alloc] init];
    
}




@end
