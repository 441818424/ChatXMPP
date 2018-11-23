//
//  CXPXMPPManager.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/13.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPXMPPManager.h"
typedef NS_ENUM(NSUInteger,CXPConnectType) {
    CXPConnectTypeLogin,
    CXPConnectTypeRegister
};

@interface CXPXMPPManager()<XMPPStreamDelegate,XMPPRosterDelegate>
/** <#注释#> */
@property (nonatomic,strong) XMPPStream *xmppStream;
/** <#注释#> */
@property (nonatomic,strong) XMPPReconnect *xmppReconnect;

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
/** <#注释#> */
@property (nonatomic,assign) BOOL customCertEvaluation;
/** <#注释#> */
@property (nonatomic,assign) BOOL bypassTLS;
/** <#注释#> */
@property (nonatomic,assign) BOOL isXmppConnected;


/** <#注释#> */
@property (nonatomic,copy) NSString *password;
/** <#注释#> */
@property (nonatomic,strong) SuccessBlock succesHandle;
/** <#注释#> */
@property (nonatomic,strong) FailureBlock failureHandle;
/** <#注释#> */
@property (nonatomic,assign) CXPConnectType connectType;


@end
@implementation CXPXMPPManager

#pragma mark -- 初始化
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
#if !TARGET_IPHONE_SIMULATOR
     self.xmppStream.enableBackgroundingOnSocket = YES;
#endif
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    //roster
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    
    self.xmppRoster.autoFetchRoster = YES;
    self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    //vCard
    self.xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    
    self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    //capabilities
    self.xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    self.xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    
    self.xmppCapabilities.autoFetchHashedCapabilities = YES;
    self.xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    //Activate xmpp modules
    [self.xmppReconnect activate:_xmppStream];
    [self.xmppRoster activate:_xmppStream];
    [self.xmppvCardTempModule activate:_xmppStream];
    [self.xmppvCardAvatarModule activate:_xmppStream];
    [self.xmppCapabilities activate:_xmppStream];
    
    //Add delegate
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    [self.xmppStream setHostName:@"192.168.112.235"];
    [self.xmppStream setHostPort:5222];
    
    self.customCertEvaluation = YES;
    
}

- (void)teardownStream
{
    [self.xmppStream removeDelegate:self];
    [self.xmppRoster removeDelegate:self];
    
    [self.xmppReconnect deactivate];
    [self.xmppRoster deactivate];
    [self.xmppvCardTempModule deactivate];
    [self.xmppvCardAvatarModule deactivate];
    [self.xmppCapabilities deactivate];
    
    [self.xmppStream disconnect];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
    self.xmppRoster = nil;
    self.xmppRosterStorage = nil;
    self.xmppvCardStorage = nil;
    self.xmppvCardTempModule = nil;
    self.xmppvCardAvatarModule = nil;
    self.xmppCapabilitiesStorage = nil;
    self.xmppCapabilities = nil;
    
}

#pragma mark --- 连接/断开连接
- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    //NSString *domain = [self.xmppStream.myJID domain];
    
    NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
    [presence addChild:priority];
    
    [self.xmppStream sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [self.xmppStream sendElement:presence];
}


- (void)connecToServer
{
    if (![self.xmppStream isDisconnected]) {
        [self disconnect];
    }
   
    NSError *error = nil;
    if ([self.xmppStream connectWithTimeout:10.0 error:&error]) {
        NSLog(@"xmpp连接失败");
    }
}

- (void)disconnect
{
    [self goOffline];
    [self.xmppStream disconnect];
}
#pragma mark ---- 登录注册
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password successHandle:(SuccessBlock)successHandle failureHandle:(FailureBlock)failureHandle
{
    self.connectType = CXPConnectTypeLogin;
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:DOMAINNAME resource:RESOURCE];
    self.xmppStream.myJID = jid;
    self.password = password;
    self.succesHandle = successHandle;
    self.failureHandle = failureHandle;
    [self connecToServer];
}

- (void)registerWithUserName:(NSString *)userName password:(NSString *)password successHandle:(SuccessBlock)successHandle failureHandle:(FailureBlock)failureHandle
{
    self.connectType = CXPConnectTypeRegister;
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:DOMAINNAME resource:RESOURCE];
    self.xmppStream.myJID = jid;
    self.password = password;
    self.succesHandle = successHandle;
    self.failureHandle = failureHandle;
    [self connecToServer];
}
- (void)logout
{
    [self disconnect];
}

#pragma mark -- Core Data
- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [self.xmppRosterStorage mainThreadManagedObjectContext];
}
- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [self.xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

#pragma mark --  XMPPStream Delegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary<NSString *,NSObject *> *)settings
{
    NSString *expectedCertName = [self.xmppStream.myJID domain];
    if (expectedCertName) {
        settings[(NSString *)kCFStreamSSLPeerName] = expectedCertName;
    }
    if (self.customCertEvaluation) {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL))completionHandler
{
    if (self.bypassTLS) {
        completionHandler(YES);
        return;
    }
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }else{
            completionHandler(NO);
        }
    });
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"与服务器连接失败");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    self.isXmppConnected = YES;
    NSError *error = nil;
    //登录授权
    if (self.connectType == CXPConnectTypeLogin) {
        if (![sender authenticateWithPassword:self.password error:&error]) {
            NSLog(@"xmpp授权出错");
          
        }
    }else{  //注册
        if (![sender registerWithPassword:self.password error:&error]) {
            NSLog(@"注册错误");
        }
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    self.succesHandle();
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
   
    self.failureHandle(nil);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
    self.succesHandle();
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"xmpp未授权");
    self.failureHandle(nil);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSLog(@"方法：didReceiveIQ");
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([message isChatMessageWithBody]) {
        XMPPUserCoreDataStorageObject *user = [self.xmppRosterStorage userForJID:[message from] xmppStream:self.xmppStream managedObjectContext:[self managedObjectContext_roster]];
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [user displayName];
        NSLog(@"用户：%@，消息：%@",displayName,body);
        
    }
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"方法：didReceivePresence");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error
{
    NSLog(@"方法：didReceiveError");
}


#pragma mark --- XMPPRosterdelegate



@end
