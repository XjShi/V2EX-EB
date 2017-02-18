//
//  EBNetworkCore.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EBNetworkSuccessBlock)(NSString *msg, id result);
typedef void(^EBNetworkFailedBlock)(NSInteger errorCode, NSString *msg);

@interface EBNetworkCore : NSObject

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method
                                   urlString:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                              successHandler:(EBNetworkSuccessBlock)successHandler
                               failedHandler:(EBNetworkFailedBlock)failedHandler;

+ (NSString *)contactURLString:(NSString *)str;

@end
