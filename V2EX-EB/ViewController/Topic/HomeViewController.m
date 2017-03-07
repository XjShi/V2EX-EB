//
//  ViewController.m
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "HomeViewController.h"
#import "TopicListTableViewController.h"
#import "TopicDetailViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "Topic.h"
#import "Masonry.h"
#import "TopicListTableViewCell.h"
#import "NodeCollectionViewCell.h"
#import "NodeCollectionSupplemntaryView.h"
#import "SYNavigationDropdownMenu.h"
#import "Node.h"
#import "Member.h"
#import "Topic.h"
#import "UIButton+WebCache.h"
#import "V2URLHelper.h"
#import "AppDelegate.h"
#import "EBAccountManager.h"

static NSString *const kTopicCellIdentifier = @"kTopicCellIdentifier";
static NSString *const kNodeCellIdentifier = @"kNodeCellIdentifier";
static NSString *const kNodeSupplementaryIdentifier = @"kNodeSupplementaryIdentifier";

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TopicListTableViewCellDelegate,
SYNavigationDropdownMenuDelegate, SYNavigationDropdownMenuDataSource>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *nodeCollectionView;
@property (nonatomic, strong) NSMutableArray<Topic *> *topicDataSource;
@property (nonatomic, strong) NSArray *nodeSections;
@property (nonatomic, strong) NSArray<NSArray *> *nodeDataSource;
@property (nonatomic, strong) UIButton *profileButton;

@end

@implementation HomeViewController

//- (void)loadView {
//    [self prepareNodeData];
//    self.view = self.nodeCollectionView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationItem];
    [self prepareNodeData];
    [self setupSubviews];
    self.topicDataSource = [NSMutableArray array];
    [self queryLatestTopics];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:kAccountManagerCurrentLoginMemberChangedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAccountManagerCurrentLoginMemberChangedNotification
                                                  object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTopicCellIdentifier];
    cell.delegate = self;
    Topic *topic = self.topicDataSource[indexPath.row];
    [cell setTopic:topic];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailViewController *vc = [[TopicDetailViewController alloc] init];
    Topic *topic = self.topicDataSource[indexPath.row];
    vc.topicID = topic.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self nodeDataForSection:section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [self nodeDataForSection:indexPath.section];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNodeCellIdentifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[NodeCollectionViewCell class]]) {
        [((NodeCollectionViewCell *)cell) setNodeInfo:arr[indexPath.item]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MIN(self.nodeSections.count, self.nodeDataSource.count);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        withReuseIdentifier:kNodeSupplementaryIdentifier
                                                                               forIndexPath:indexPath];
    if ([view isKindOfClass:[NodeCollectionSupplemntaryView class]]) {
        [((NodeCollectionSupplemntaryView *)view) setTitle:[self nodeSectionTitleForSection:indexPath.section]];
    }
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(300, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [self nodeDataForSection:indexPath.section];
    NSDictionary *nodeInfo = arr[indexPath.item];
    DDLogDebug(@"go/%@", nodeInfo[@"title"]);
    [self queryTopicsByNodename:nodeInfo[@"title"]];
    [self transition];
}

#pragma mark - TopicListTableViewCellDelegate
- (void)topicListTableViewCell:(TopicListTableViewCell *)cell nodenameClicked:(Node *)node {
    DDLogDebug(@"%@", node.name);
    NSDictionary *condition = @{@"node_name": node.name};
    TopicListTableViewController *vc = [TopicListTableViewController new];
    vc.title = node.title;
    vc.queryCondition = condition;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)topicListTableViewCell:(TopicListTableViewCell *)cell memberNameClicked:(Member *)member {
    DDLogDebug(@"%@", member.username);
    ProfileViewController *vc = [ProfileViewController new];
    vc.username = member.username;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SYNavigationDropdownMenuDelegate / SYNavigationDropdownMenuDataSource
- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return @[@"1", @"2", @"3", @"4"];
}

- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index {
    
}

- (CGFloat)arrowPaddingForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return 8.0;
}

- (UIImage *)arrowImageForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return [UIImage imageNamed:@"Dropdown_Arrow"];
}

#pragma mark - accessor
- (UIButton *)profileButton {
    if (!_profileButton) {
        _profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _profileButton.frame = CGRectMake(0, 0, 30, 30);
        _profileButton.layer.cornerRadius = 15;
        _profileButton.layer.masksToBounds = YES;
        [_profileButton addTarget:self action:@selector(showProfile) forControlEvents:UIControlEventTouchUpInside];
    }
    Member *member = [AppDelegate appDelegate].currentLoginMember;
    NSURL *url = [V2URLHelper getHTTPSLink:member.avatar_normal];
    [_profileButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    return _profileButton;
}

#pragma mark - Private Method
- (void)queryLatestTopics {
    __weak typeof(self) weakSelf = self;
    //    [TopicCore queryHotTopicWithSuccess:^(NSArray<Topic *> *result) {
    //        weakSelf.topicDataSource = [result mutableCopy];
    //        [self.tableView reloadData];
    //    } failed:^(NSInteger errorCode, NSString *msg) {
    //        NSLog(@"%@", msg);
    //    }];
    [self showLoadingWithText:nil];
    [Topic queryLatestTopicWithSuccess:^(NSArray<Topic *> *result) {
        [self hideLoading];
        weakSelf.topicDataSource = [result mutableCopy];
        [self.tableView reloadData];
    } failed:^(NSInteger errorCode, NSString *msg) {
        [self hideLoading];
        DDLogError(@"%@", msg);
    }];
}

- (void)queryTopicsByNodename:(NSString *)nodename {
    __weak typeof(self) weakSelf = self;
    [self showLoadingWithText:nil];
    [Topic queryTopicsWithNodeName:nodename success:^(NSArray<Topic *> *result) {
        [self hideLoading];
        weakSelf.topicDataSource = [result mutableCopy];
        [self.tableView reloadData];
    } failed:^(NSInteger errorCode, NSString *msg) {
        [self hideLoading];
        DDLogError(@"%@", msg);
    }];
}

- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"节点"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(changeView)];
    BOOL loginStatus = [EBAccountManager hasLoginMember];
    self.navigationItem.leftBarButtonItem = [self profileBarButtonItemWithLoginStatus:loginStatus];
}

- (UIBarButtonItem *)profileBarButtonItemWithLoginStatus:(BOOL)login {
    if (login) {
        return [[UIBarButtonItem alloc] initWithCustomView:self.profileButton];
    } else {
        return [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(login)];
    }
}

- (void)changeView {
    [self transition];
}

- (void)loginStatusChanged:(NSNotification *)notification {
    BOOL isLogin = notification.userInfo ? YES : NO;
    self.navigationItem.leftBarButtonItem = [self profileBarButtonItemWithLoginStatus:isLogin];
}

- (void)showProfile {
    ProfileViewController *vc = [ProfileViewController new];
    vc.isCurrentLoginMember = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)login {
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transition {
    static BOOL flag = false;
    UIView *from = flag ? self.nodeCollectionView : self.tableView;
    UIView *to = flag ? self.tableView : self.nodeCollectionView;
    self.navigationItem.rightBarButtonItem.title = flag ? @"节点" : @"主题";
//    UIViewAnimationOptions option = flag ? UIViewAnimationOptionTransitionCurlDown : UIViewAnimationOptionTransitionCurlUp;
    UIViewAnimationOptions option = UIViewAnimationOptionCurveLinear;
    [UIView transitionFromView:from
                        toView:to
                      duration:0.5
                       options:option
                    completion:^(BOOL finished) {
                        if (finished) {
                            flag = !flag;
                        }
                    }];
    [UIView commitAnimations];
}

- (void)setupSubviews {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)];
    [self.view addSubview:self.containerView];
    [self setupTopicTableView];
    [self setupNodeCollectionView];
    //    [self setupDropdownMenu];
}

- (void)setupTopicTableView {
    [self.containerView addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"TopicListTableViewCell" bundle:[NSBundle mainBundle]];
        [_tableView registerNib:nib forCellReuseIdentifier:kTopicCellIdentifier];
        _tableView.estimatedRowHeight = 70.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (void)setupNodeCollectionView {
    [self.containerView insertSubview:self.nodeCollectionView atIndex:0];
}

- (void)setupDropdownMenu {
    SYNavigationDropdownMenu *menu = [[SYNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController];
    menu.dataSource = self;
    menu.delegate = self;
    self.navigationItem.titleView = menu;
}

- (UICollectionView *)nodeCollectionView {
    if (!_nodeCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 15;
        layout.estimatedItemSize = CGSizeMake(50, 30);
        layout.sectionInset = UIEdgeInsetsMake(5, 8, 5, 8);
        
        _nodeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)
                                                 collectionViewLayout:layout];
        _nodeCollectionView.delegate = self;
        _nodeCollectionView.dataSource = self;
        _nodeCollectionView.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UINib nibWithNibName:@"NodeCollectionViewCell" bundle:[NSBundle mainBundle]];
        [_nodeCollectionView registerNib:nib forCellWithReuseIdentifier:kNodeCellIdentifier];
        UINib *supNib = [UINib nibWithNibName:@"NodeCollectionSupplemntaryView" bundle:[NSBundle mainBundle]];
        [_nodeCollectionView registerNib:supNib
              forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                     withReuseIdentifier:kNodeSupplementaryIdentifier];
    }
    return _nodeCollectionView;
}

- (void)prepareNodeData {
    self.nodeSections = @[@"分享与探索", @"V2EX", @"iOS", @"Geek", @"游戏",
                          @"Apple", @"生活", @"Internet", @"城市", @"品牌"];
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"NodesList" withExtension:@"plist"];
    self.nodeDataSource = [NSArray arrayWithContentsOfURL:path];
    
}

- (NSString *)nodeSectionTitleForSection:(NSInteger)section {
    return self.nodeSections[section];
}

- (NSArray *)nodeDataForSection:(NSInteger)section {
    return self.nodeDataSource[section];
}

@end
