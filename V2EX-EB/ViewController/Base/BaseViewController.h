//
//  BaseViewController.h
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong, readonly) MBProgressHUD *hud;

- (void)hideLoading;
- (void)showLoadingWithText:(NSString *)text;
- (void)promptWithText:(NSString *)text;

- (void)alertUserToOpenURLInSafari:(NSURL *)url;
- (void)alertUserToCallOrSendSMSWithPhoneNumber:(NSString *)phoneNumber;
- (void)alertUserToSendMailWithURL:(NSURL *)url;

@end
