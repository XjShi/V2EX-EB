//
//  MemberReply.h
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBNetworkCore.h"

@interface MemberReply : NSObject

@property (nonatomic, copy) NSString *replyDescription;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *topicURL;

@property (nonatomic, assign, readonly) NSUInteger topicID;

@end

@interface MemberReply (Request)
+ (NSURLSessionDataTask *)queryRepliesWithUsername:(NSString *)username
                                           success:(void (^)(NSArray<MemberReply *> *))success
                                            failed:(EBNetworkFailedBlock)failed;
@end
