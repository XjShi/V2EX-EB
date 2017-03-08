//
//  BaseViewController.h
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong, readonly) MBProgressHUD *hud;

@property (nonatomic, copy) NSString *noMoreDataText;
@property (nonatomic, copy) NSString *networkErrorText;

@end

@interface BaseViewController (Refresh)

- (MJRefreshNormalHeader *)mjHeaderWithSelector:(SEL)seletor;

@end

@interface BaseViewController (Loading)

- (void)hideLoading;
- (void)showLoadingWithText:(NSString *)text;
- (void)promptWithText:(NSString *)text;

@end

@interface BaseViewController (Alert)

- (void)alertUserToOpenURLInSafari:(NSURL *)url;
- (void)alertUserToCallOrSendSMSWithPhoneNumber:(NSString *)phoneNumber;
- (void)alertUserToSendMailWithURL:(NSURL *)url;

@end
