//
//  TopicListTableViewController.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "TopicListTableViewController.h"
#import "TopicDetailViewController.h"
#import "TopicListTableViewCell.h"
#import "TopicCore.h"
#import "Topic.h"
#import "Node.h"
#import "Member.h"
#import "MJRefresh.h"

static NSString *const kTopicCellIdentifier = @"kTopicCellIdentifier";

@interface TopicListTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<Topic *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self queryTopics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopicCellIdentifier forIndexPath:indexPath];
    [((TopicListTableViewCell *)cell) setTopic:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    TopicDetailViewController *vc = [[TopicDetailViewController alloc] init];
    Topic *topic = self.dataSource[indexPath.row];
    vc.topic = topic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"TopicListTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:kTopicCellIdentifier];
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)queryTopics {
    if (!_queryCondition) {
        return;
    }
    NSURLSessionDataTask *task = [TopicCore queryTopicsWithParameters:_queryCondition success:^(NSArray<Topic *> *result) {
        self.dataSource = result;
        if (result.count == 0) {
            self.noMoreDataText = @"还没有发布过主题";
            return ;
        }
        [self.tableView reloadData];
    } failed:^(NSInteger errorCode, NSString *msg) {
        DDLogDebug(@"%@", msg);
    }];
    [task resume];
}

@end
