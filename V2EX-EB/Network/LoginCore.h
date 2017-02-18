//
//  LoginCore.h
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBNetworkCore.h"

@interface LoginCore : NSObject

+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void(^)(NSString *username))success
                   failed:(EBNetworkFailedBlock)failed;

@end
