//
//  CXPXMPPFriendsManager.h
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/23.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef  void(^ReceiveFriendsListCompleteBlock)(NSArray *list);

@interface CXPXMPPFriendsManager : NSObject



//获取好友列表
- (void)receiveFriendsListComplete:(ReceiveFriendsListCompleteBlock)block;
//获取好友请求列表
- (void)receiveFriendsRequestListComplete:(ReceiveFriendsListCompleteBlock)block;
//同意添加好友
- (void)agreeAddFriendWithUser:(NSString *)user;
//拒绝添加好友
- (void)refuseAddFriendWithUser:(NSString *)user;
//发送订阅请求，添加好友
- (void)addFriendWithUser:(NSString *)user;

@end

NS_ASSUME_NONNULL_END
