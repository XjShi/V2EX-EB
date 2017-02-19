//
//  ProfileViewController.h
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController

@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BOOL isCurrentLoginMember;

@end
