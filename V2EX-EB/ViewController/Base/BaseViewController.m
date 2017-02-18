//
//  BaseViewController.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingWithText:(NSString *)text {
    UIView *view = self.navigationController ? self.navigationController.view : self.view;
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (text && text.length != 0) {
        _hud.label.text = text;
    }
}

- (void)hideLoading {
    [_hud hideAnimated:YES];
}

- (void)promptWithText:(NSString *)text {
    UIView *view = self.navigationController ? self.navigationController.view : self.view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.offset = CGPointZero;
    [hud hideAnimated:YES afterDelay:1.f];
}

- (void)alertUserToOpenURLInSafari:(NSURL *)url {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:url.absoluteString
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"在Safari中打开"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self appOpenURL:url];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)alertUserToCallOrSendSMSWithPhoneNumber:(NSString *)phoneNumber {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:phoneNumber
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"打电话"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSString *str = [NSString stringWithFormat:@"tel://%@", phoneNumber];
                                                          [self appOpenURL:[NSURL URLWithString:str]];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"发短信"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSString *str = [NSString stringWithFormat:@"sms://%@", phoneNumber];
                                                          [self appOpenURL:[NSURL URLWithString:str]];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    [self presentedViewController];
}

- (void)alertUserToSendMailWithURL:(NSURL *)url {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:url.resourceSpecifier
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Mail"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self appOpenURL:url];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)appOpenURL:(NSURL *)url {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url
             options:@{UIApplicationOpenURLOptionsSourceApplicationKey: @NO}
   completionHandler:NULL];
    }
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
