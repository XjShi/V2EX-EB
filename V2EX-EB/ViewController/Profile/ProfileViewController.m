//
//  ProfileViewController.m
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "ProfileViewController.h"
#import "TopicListTableViewController.h"
#import "Member.h"
#import "AppDelegate.h"
#import "EBAccountManager.h"
#import "Topic.h"
#import "ProfileHeaderView.h"
#import <SafariServices/SafariServices.h>
#import "MemberReplyViewController.h"
#import "AccountViewController.h"

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Member *member;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) ProfileHeaderView *headerView;
@property (nonatomic) NSArray *titles;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.username;
    self.titles = @[@"主题", @"回复"];
    [self.view addSubview:self.tableView];
    if (self.isCurrentLoginMember) {
        self.member = [AppDelegate appDelegate].currentLoginMember;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账户管理"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(logout)];
        self.headerView.member = self.member;
    } else {
        [self queryMemberInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            TopicListTableViewController *vc = [[TopicListTableViewController alloc] init];
            vc.queryCondition = @{@"username": self.member.username};
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            MemberReplyViewController *vc = [[MemberReplyViewController alloc] init];
            vc.username = self.member.username;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private
- (void)queryMemberInfo {
    [self showLoadingWithText:nil];
    [Member queryMemberInfoByName:self.username succss:^(Member *member) {
        self.member = member;
        self.headerView.member = member;
        [self hideLoading];
    } failed:^(NSInteger errorCode, NSString *msg) {
        [self hideLoading];
        DDLogError(msg);
    }];
}

- (void)logout {
    AccountViewController *vc = [AccountViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self profileHeaderView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (ProfileHeaderView *)profileHeaderView {
    if (!_headerView) {
        _headerView = [[ProfileHeaderView alloc] init];
    }
    return _headerView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
