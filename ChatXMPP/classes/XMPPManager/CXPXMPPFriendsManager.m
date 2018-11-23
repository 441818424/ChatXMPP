//
//  CXPXMPPFriendsManager.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/23.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPXMPPFriendsManager.h"
#import "CXPXMPPManager.h"
#import "CXPContactModel.h"

@interface CXPXMPPFriendsManager()<XMPPRosterDelegate>
/** 好友列表 */
@property (nonatomic,strong) NSMutableArray *friendsList;
/** 好友请求列表 */
@property (nonatomic,strong) NSMutableArray *friendsRequestList;

/** 接收好友列表请求回调 */
@property (nonatomic,strong) ReceiveFriendsListCompleteBlock friendsListBlock;
/** 接收好友请求列表请求回调 */
@property (nonatomic,strong) ReceiveFriendsListCompleteBlock friendsRequestListBlock;

@end
@implementation CXPXMPPFriendsManager

- (instancetype)init
{
    if (self = [super init]) {
        [[CXPXMPPManager sharedXMPPManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}
//公开方法
- (void)receiveFriendsListComplete:(ReceiveFriendsListCompleteBlock)block
{
    self.friendsListBlock = block;
    
}
- (void)receiveFriendsRequestListComplete:(ReceiveFriendsListCompleteBlock)block
{
    self.friendsRequestListBlock = block;
}
//同意添加好友
- (void)agreeAddFriendWithUser:(NSString *)user
{
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:DOMAINNAME resource:RESOURCE];
    XMPPRoster *xmppRoster = [CXPXMPPManager sharedXMPPManager].xmppRoster;
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}
//拒绝添加好友
- (void)refuseAddFriendWithUser:(NSString *)user
{
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:DOMAINNAME resource:RESOURCE];
    XMPPRoster *xmppRoster = [CXPXMPPManager sharedXMPPManager].xmppRoster;
    [xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
}
//发送订阅请求，添加好友
- (void)addFriendWithUser:(NSString *)user
{
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:DOMAINNAME resource:RESOURCE];
    XMPPRoster *xmppRoster = [CXPXMPPManager sharedXMPPManager].xmppRoster;
    [xmppRoster subscribePresenceToUser:jid];
}
#pragma mark ---- XMPPRosterDelegate
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender withVersion:(NSString *)version
{
    NSLog(@"开始接收好友列表");
}
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    NSLog(@"结束接收好友列表");
    self.friendsListBlock(self.friendsList);
    self.friendsRequestListBlock(self.friendsRequestList);
}
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSString *jid = [[item attributeForName:@"jid"] stringValue];
    XMPPJID *xmppjid = [XMPPJID jidWithString:jid resource:RESOURCE];
    
    for (CXPContactModel *contact in self.friendsList) {
        if ([contact.userName isEqualToString:xmppjid.user]) {
            return;
        }
    }
    CXPContactModel *contactModel = [[CXPContactModel alloc] init];
    XMPPvCardTemp *vCard = [[XMPPvCardTemp alloc] initWithName:xmppjid.user];
    contactModel.userName = xmppjid.user;
    contactModel.avatar = [UIImage imageWithData:vCard.photo];
    [self.friendsList addObject:contactModel];
}
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    XMPPJID *fromjid = presence.from;
    for (CXPContactModel *contact in self.friendsRequestList) {
        if ([contact.userName isEqualToString:fromjid.user]) {
            return;
        }
    }
    CXPContactModel *contactModel = [[CXPContactModel alloc] init];
    XMPPvCardTemp *vCard = [[XMPPvCardTemp alloc] initWithName:fromjid.user];
    contactModel.userName = fromjid.user;
    contactModel.avatar = [UIImage imageWithData:vCard.photo];
    [self.friendsList addObject:contactModel];
    [self.friendsRequestList addObject:vCard];
}

@end
