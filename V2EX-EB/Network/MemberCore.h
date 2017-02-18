//
//  UserCore.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBNetworkCore.h"

@class Member;

typedef void(^MemberNetworkSuccessBlock)(Member *user);

@interface MemberCore : NSObject

+ (NSURLSessionDataTask *)queryMemberInfoByName:(NSString *)name
                                         succss:(MemberNetworkSuccessBlock)success
                                         failed:(EBNetworkFailedBlock)failed;

@end
