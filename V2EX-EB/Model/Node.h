//
//  Node.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "EBError.h"
#import "EBNetworkCore.h"

@interface Node : JSONModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_alternative;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSUInteger stars;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, assign) NSTimeInterval created;
@property (nonatomic, copy) NSString *avatar_mini;
@property (nonatomic, copy) NSString *avatar_normal;
@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic, assign) NSUInteger topics;

@end

@interface Node (Request)

+ (NSURLSessionDataTask *)queryNodeWithName:(NSString *)name
                                    success:(void(^)(Node *node))success
                                     failed:(EBNetworkFailedBlock)failed;

@end
