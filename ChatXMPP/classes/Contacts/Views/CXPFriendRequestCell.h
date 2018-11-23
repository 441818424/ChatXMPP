//
//  CXPFriendRequestCell.h
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/23.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPContactModel.h"

NS_ASSUME_NONNULL_BEGIN
@class CXPFriendRequestCell;
@protocol CXPFriendRequestCellDelegate <NSObject>

- (void)agreeBtnDidClick:(UITableViewCell *)cell user:(NSString *)user;

- (void)disagreeBtnDidClick:(UITableViewCell *)cell user:(NSString *)user;

@end

@interface CXPFriendRequestCell : UITableViewCell
/** <#注释#> */
@property (nonatomic,strong) CXPContactModel *contactModel;
/** <#注释#> */
@property (nonatomic,weak) id<CXPFriendRequestCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
