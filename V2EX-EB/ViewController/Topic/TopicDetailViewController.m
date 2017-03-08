//
//  TopicDetailViewController.m
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "ProfileViewController.h"
#import "ReplyTableViewCell.h"
#import "TopicDetailView.h"
#import "Topic.h"
#import "V2URLHelper.h"

static NSString *const kCellIdeintifier = @"ReplyTableViewCell";

@interface TopicDetailViewController ()<UITableViewDelegate, UITableViewDataSource, TopicDetailViewDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *replies;
@property (nonatomic, strong) Topic *topic;

@end

@implementation TopicDetailViewController

- (void)loadView {
    [super loadView];
    self.view = self.tableView;
}

//test:323650
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessor
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 70.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        
        UINib *nib = [UINib nibWithNibName:@"ReplyTableViewCell" bundle:[NSBundle mainBundle]];
        [_tableView registerNib:nib forCellReuseIdentifier:kCellIdeintifier];
        _tableView.mj_header = [self mjHeaderWithSelector:@selector(queryTopicDetail)];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.replies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdeintifier];
    cell.tttDelegate = self;
    [cell setReply:self.replies[indexPath.row]];
    [cell setFloor:indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

#pragma mark - TopicDetailViewDelegate
- (void)clickedUsername:(NSString *)username inTopicDetailView:(TopicDetailView *)view {
    DDLogDebug(@"%@", username);
    ProfileViewController *vc = [ProfileViewController new];
    vc.username = username;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    DDLogDebug(@"%@", phoneNumber);
    [self alertUserToCallOrSendSMSWithPhoneNumber:phoneNumber];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    DDLogDebug(@"note:\t%@", url);
    if ([V2URLHelper isHTTPURL:url]) {
        [self alertUserToOpenURLInSafari:url];
    } else if ([V2URLHelper isMailURL:url]) {
        [self alertUserToSendMailWithURL:url];
    } else {
        ProfileViewController *vc = [[ProfileViewController alloc] init];
        vc.username = url.absoluteString;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Private
- (TopicDetailView *)topicDetailView {
    TopicDetailView *header = [[TopicDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) topic:self.topic];
    header.delegate = self;
    header.tttDelegate = self;
    return header;
}

- (void)queryTopicDetail {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self showLoadingWithText:nil];
    [Topic queryTopciWithID:self.topicID success:^(NSArray<Topic *> *result) {
        self.topic = result.firstObject;
        self.tableView.tableHeaderView = [self topicDetailView];
        dispatch_group_leave(group);
    } failed:^(NSInteger errorCode, NSString *msg) {
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [Reply queryReplyWithTopicID:self.topicID page:0 page_size:0 success:^(NSArray<Reply *> *replies) {
        self.replies = replies;
        [self.tableView reloadData];
        dispatch_group_leave(group);
    } failed:^(NSInteger errorCode, NSString *msg) {
        DDLogDebug(@"%@", msg);
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self hideLoading];
        [_tableView.mj_header endRefreshing];
    });
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
