//
//  CXPFriendRequestCell.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/23.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPFriendRequestCell.h"

@interface CXPFriendRequestCell()
/** <#注释#> */
@property (nonatomic,strong) UIImageView *avatarImageView;
/** <#注释#> */
@property (nonatomic,strong) UILabel *userLabel;
/** <#注释#> */
@property (nonatomic,strong) UIButton *agreeBtn;
/** <#注释#> */
@property (nonatomic,strong) UIButton *disagreeBtn;



@end
@implementation CXPFriendRequestCell
- (void)setContactModel:(CXPContactModel *)contactModel
{
    self.userLabel.text = contactModel.userName;
    self.avatarImageView.image = contactModel.avatar;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell
{
    self.avatarImageView = [[UIImageView alloc] init];
    [self addSubview:self.avatarImageView];
    
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.userLabel];
    
    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self addSubview:self.agreeBtn];
    
    self.disagreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [self.agreeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.disagreeBtn addTarget:self action:@selector(disagreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.agreeBtn];
     
     [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(self.avatarImageView.mas_height);
    }];
    [self.disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(self.disagreeBtn.mas_height);
    }];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.disagreeBtn).offset(-5);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(self.agreeBtn.mas_height);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.avatarImageView).offset(10);
        make.right.equalTo(self.agreeBtn).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)agreeBtnClick
{
    if (_delegate && [self.delegate respondsToSelector:@selector(agreeBtnDidClick:user:)]) {
        [self.delegate agreeBtnDidClick:self user:self.contactModel.userName];
    }
}

- (void)disagreeBtnClick
{
    if (_delegate && [self.delegate respondsToSelector:@selector(disagreeBtnDidClick:user:)]) {
        [self.delegate disagreeBtnDidClick:self user:self.contactModel.userName];
    }
}
@end
