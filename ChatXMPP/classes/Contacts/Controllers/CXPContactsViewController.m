//
//  CXPContactsViewController.m
//  ChatXMPP
//
//  Created by PAD_Chenxiang_MAC on 2018/11/21.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "CXPContactsViewController.h"
#import "CXPXMPPFriendsManager.h"
#import "CXPContactModel.h"

@interface CXPContactsViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 好友列表 */
@property (nonatomic,strong) NSArray *friendsList;
/** 字母索引 */
@property (nonatomic,strong) NSMutableArray *indexTitles;

/** <#注释#> */
@property (nonatomic,strong) UITableView *tableView;


@end
static NSString *reuseIdentifier = @"contactCell";
@implementation CXPContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadData];
    
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
     self.tableView.dataSource = self;
     self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}
- (void)loadData
{
    CXPXMPPFriendsManager *friendManager = [[CXPXMPPFriendsManager alloc] init];
    [friendManager receiveFriendsListComplete:^(NSArray * _Nonnull list) {
        self.friendsList = list;
        [self.tableView reloadData];
    }];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    CXPContactModel *contactModel = self.friendsList[indexPath.row];
    cell.textLabel.text = contactModel.userName;
    cell.imageView.image = contactModel.avatar;
    
    return cell;
}

//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//
//}
#pragma mark --- 私有方法
//截取首字母并且大写
- (NSString *)transformFirstAlphabet:(NSString *)chineseStr
{
    if (chineseStr == nil || [chineseStr isEqualToString:@""]) {
        return @"#";
    }
    NSMutableString *pinyin = [chineseStr mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSString *subString = [[pinyin uppercaseString] substringWithRange:NSMakeRange(0, 1)];
   
    if ([self isPureInt:subString] || [self isPureFloat:subString]) {
        return @"#";
    }
    
    return subString;
}
//判断是否为整型
- (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点型
- (BOOL)isPureFloat:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float var;
    return [scan scanFloat:&var] && [scan isAtEnd];
}


//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//
//
//    //同意请求
//    [sender acceptPresenceSubscriptionRequestFrom:fromjid andAddToRoster:YES];
//    //拒绝请求
//    [sender rejectPresenceSubscriptionRequestFrom:fromjid];
//    //发起添加好友申请
//    [sender subscribePresenceToUser:jid];
//}
@end
