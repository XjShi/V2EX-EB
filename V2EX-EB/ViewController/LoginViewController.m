//
//  LoginViewController.m
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCore.h"
#import "MemberCore.h"
#import "OnePasswordExtension.h"
#import "EBAccountManager.h"
#import "Member.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIButton *onepasswordButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configOnePasswordExtension];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0) {
        return;
    }
    if (password.length == 0) {
        return;
    }
    [self showLoadingWithText:@"正在登录"];
    [LoginCore loginWithUsername:_usernameTextField.text
                        password:_passwordTextField.text
                         success:^(NSString *username) {
                             [self hideLoading];
                             [self queryMemberInfo:username];
                             [self saveAccount:username password:password];
                             [self.navigationController popViewControllerAnimated:YES];
                         } failed:^(NSInteger errorCode, NSString *msg) {
                             NSLog(@"登录失败：%ld, %@", (long)errorCode, msg);
                         }];
}

- (void)onepasswordButtonClicked:(UIButton *)sender {
    [[OnePasswordExtension sharedExtension] findLoginForURLString:@"https://www.v2ex.com" forViewController:self sender:sender completion:^(NSDictionary * _Nullable loginDictionary, NSError * _Nullable error) {
        if (0 == loginDictionary.count) {
            if (error.code != AppExtensionErrorCodeCancelledByUser) {
                NSLog(@"onepassword extension: %@", error);
            }
            return ;
        }
        self.usernameTextField.text = loginDictionary[AppExtensionUsernameKey];
        self.passwordTextField.text = loginDictionary[AppExtensionPasswordKey];
        [self loginButtonClicked:nil];
    }];
    
}

- (void)queryMemberInfo:(NSString *)username {
    [MemberCore queryMemberInfoByName:username succss:^(Member *user) {
        [EBAccountManager saveMember:user];
    } failed:^(NSInteger errorCode, NSString *msg) {
        
    }];
}

- (void)configOnePasswordExtension {
    if ([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        self.onepasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.onepasswordButton.frame = CGRectMake(0, 0, 30, 30);
        [self.onepasswordButton setImage:[UIImage imageNamed:@"onepassword-button"] forState:UIControlStateNormal];
        [self.onepasswordButton addTarget:self action:@selector(onepasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.passwordTextField.rightView = self.onepasswordButton;
        self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)saveAccount:(NSString *)account password:(NSString *)password {
    [[EBAccountManager sharedManager] saveAccount:account password:password];
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
