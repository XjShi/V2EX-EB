//
//  NodeCore.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBNetworkCore.h"

@class Node;
@interface NodeCore : NSObject

+ (NSURLSessionDataTask *)queryNodeWithName:(NSString *)name
                                    success:(void(^)(Node *node))success
                                     failed:(EBNetworkFailedBlock)failed;

@end
