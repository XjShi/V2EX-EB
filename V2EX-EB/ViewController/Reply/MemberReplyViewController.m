//
//  MemberReplyViewController.m
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "MemberReplyViewController.h"
#import "TopicDetailViewController.h"
#import "MemberReplyTableViewCell.h"
#import "MemberReply.h"

static NSString *const kCellIdentifier = @"MemberReplyTableViewCell";
@interface MemberReplyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MemberReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self queryRelies];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.reply = self.dataSource[indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberReply *reply = self.dataSource[indexPath.row];
    TopicDetailViewController *vc = [TopicDetailViewController new];
    vc.topicID = reply.topicID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MemberReplyTableViewCell" bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
        _tableView.estimatedRowHeight = 60.F;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)queryRelies {
    [self showLoadingWithText:nil];
    [MemberReply queryRepliesWithUsername:_username success:^(NSArray<MemberReply *> *replies) {
        [self hideLoading];
        if (replies.count == 0) {
            self.noMoreDataText = @"高冷，你还没有回复过别人~";
            return ;
        }
        self.dataSource = [replies mutableCopy];
        [_tableView reloadData];
    } failed:^(NSInteger errorCode, NSString *msg) {
        [self hideLoading];
        DDLogError(msg);
    }];
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
