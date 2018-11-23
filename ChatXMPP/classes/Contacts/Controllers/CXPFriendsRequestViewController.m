//
//  CXPFriendsRequestViewController.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/23.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPFriendsRequestViewController.h"
#import "CXPXMPPFriendsManager.h"
#import "CXPFriendRequestCell.h"

@interface CXPFriendsRequestViewController ()<UITableViewDataSource,UITableViewDelegate,CXPFriendRequestCellDelegate>
/** 好友请求列表 */
@property (nonatomic,strong) NSMutableArray *friendsRequestList;
/** <#注释#> */
@property (nonatomic,strong) UITableView *tableView;
@end

static NSString *reuseIdentifier = @"friendRequestCell";

@implementation CXPFriendsRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadData];
    [self setNavigationBar];
}
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
    [self.tableView registerClass:[CXPFriendRequestCell class] forCellReuseIdentifier:reuseIdentifier];
}
- (void)loadData
{
    CXPXMPPFriendsManager *friendManager = [[CXPXMPPFriendsManager alloc] init];
    [friendManager receiveFriendsRequestListComplete:^(NSArray * _Nonnull list) {
        self.friendsRequestList = [list mutableCopy];
        [self.tableView reloadData];
    }];
}
- (void)setNavigationBar
{
    self.navigationItem.title = @"好友申请列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
}
- (void)addFriend
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入账号";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = [alert.textFields lastObject];
        CXPXMPPFriendsManager *friendManager = [[CXPXMPPFriendsManager alloc] init];
        [friendManager addFriendWithUser:textField.text];
        [alert dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showSuccess:@"好友请求发送成功"];
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsRequestList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CXPFriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    CXPContactModel *contact = self.friendsRequestList[indexPath.row];
    cell.contactModel = contact;
    return cell;
}


#pragma mark -- CXPFriendRequestCellDelegate
- (void)agreeBtnDidClick:(UITableViewCell *)cell user:(nonnull NSString *)user
{
    CXPXMPPFriendsManager *friendManager = [[CXPXMPPFriendsManager alloc] init];
    [friendManager agreeAddFriendWithUser:user];
    for (CXPContactModel *contact in self.friendsRequestList) {
        if ([contact.userName isEqualToString:user]) {
            [self.friendsRequestList removeObject:contact];
        }
    }
    [self.tableView reloadData];
}

- (void)disagreeBtnDidClick:(UITableViewCell *)cell user:(nonnull NSString *)user
{
    CXPXMPPFriendsManager *friendManager = [[CXPXMPPFriendsManager alloc] init];
    [friendManager refuseAddFriendWithUser:user];
    for (CXPContactModel *contact in self.friendsRequestList) {
        if ([contact.userName isEqualToString:user]) {
            [self.friendsRequestList removeObject:contact];
        }
    }
    [self.tableView reloadData];
}


@end
