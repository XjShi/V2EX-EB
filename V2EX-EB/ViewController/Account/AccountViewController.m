//
//  AccountViewController.m
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "AccountViewController.h"
#import "EBAccountManager.h"
#import "AppDelegate.h"
#import "Member.h"
#import "LoginCore.h"
#import "Member.h"
#import "LogoutView.h"

static NSString *const kCellIdentifier = @"kCellIdentifier";

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self prepareData];
    [self setupNavigationitem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.dataSource[indexPath.row];;
    BOOL showCheckmark = [indexPath isEqual:_indexpath];
    cell.accessoryType = showCheckmark ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:_indexpath]) {
        return;
    }
    _indexpath = indexPath;
    [self.tableView reloadData];
    [self checkWhetherShouldSwitchLoginUser];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                title:@"删除"
                                              handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                  NSString *account = self.dataSource[indexPath.row];
                                                  BOOL sameUser = [[self currentLoginMemberUsername] isEqualToString:account];
                                                  if (sameUser) {
                                                      [[EBAccountManager sharedManager] deleteAccount:account];
                                                      [EBAccountManager clear];
                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                  } else {
                                                      [[EBAccountManager sharedManager] deleteAccount:account];
                                                      [self.dataSource removeObjectAtIndex:indexPath.row];
                                                      if (self.dataSource.count > 0) {
                                                          [self.tableView reloadData];
                                                      } else {
                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                      }
                                                  }
                                              }]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    LogoutView *view = [[LogoutView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80.0) handler:^{
        [EBAccountManager clear];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    return view;
}

#pragma mark - Private
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (void)prepareData {
    NSArray *accounts = [[EBAccountManager sharedManager] getAllAccounts];
    self.dataSource = [NSMutableArray arrayWithCapacity:accounts.count];
    [accounts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = obj;
        NSString *username = dict[@"acct"];
        if ([username isEqualToString:[self currentLoginMemberUsername]]) {
            _indexpath = [NSIndexPath indexPathForRow:idx inSection:0];
        }
        [self.dataSource addObject:username];
    }];
    
}

- (NSString *)currentLoginMemberUsername {
    return [AppDelegate appDelegate].currentLoginMember.username;
}

- (void)checkWhetherShouldSwitchLoginUser {
    NSString *selectUsername = self.dataSource[_indexpath.row];
    self.navigationItem.rightBarButtonItem.enabled = ![selectUsername isEqualToString:[self currentLoginMemberUsername]];
}

- (void)setupNavigationitem {
    if (self.dataSource.count > 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换用户"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(switchLoginUser)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)switchLoginUser {
    NSString *account = self.dataSource[_indexpath.row];
    NSString *password = [[EBAccountManager sharedManager] passwordForAccount:account];
    if (!password) {
        [self promptWithText:@"发生了一些错误，需要重新登录"];
        return ;
    }
    [self showLoadingWithText:nil];
    [LoginCore loginWithUsername:account password:password success:^(NSString *username) {
        [Member queryMemberInfoByName:username succss:^(Member *user) {
            [EBAccountManager saveMember:user];
            [self hideLoading];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failed:^(NSInteger errorCode, NSString *msg) {
            DDLogDebug(@"查询用户信息：%@", msg);
            [self hideLoading];
        }];
    } failed:^(NSInteger errorCode, NSString *msg) {
        DDLogDebug(@"登录出错：%@", msg);
        [self hideLoading];
    }];
}

@end
