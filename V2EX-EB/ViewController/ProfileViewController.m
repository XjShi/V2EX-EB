//
//  ProfileViewController.m
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "ProfileViewController.h"
#import "MemberCore.h"
#import "Member.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.username;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)queryMemberInfo {
    [MemberCore queryMemberInfoByName:self.username succss:^(Member *member) {
        
    } failed:^(NSInteger errorCode, NSString *msg) {
        
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
