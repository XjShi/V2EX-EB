//
//  Node.m
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "Node.h"

@implementation Node

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"ID"]) {
        return NO;
    } else {
        return YES;
    }
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}

@end

@implementation Node (Request)

+ (NSURLSessionDataTask *)queryNodeWithName:(NSString *)name success:(void(^)(Node *node))success failed:(EBNetworkFailedBlock)failed {
    if (!name && name.length == 0) {
        failed(EBErrorCodeInvalidArguments, @"查询的节点不存在");
        return nil;
    }
    NSString *url = [EBNetworkCore contactURLString:@"nodes/show.json"];
    NSDictionary *params = @{@"name": name};
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET"
                                                urlString:url
                                               parameters:params
                                           successHandler:^(NSString *msg, id result) {
                                               NSError *error = nil;
                                               Node *node = [[Node alloc] initWithData:result error:&error];
                                               if (node) {
                                                   success(node);
                                               } else {
                                                   failed(error.code, error.localizedDescription);
                                               }
                                           } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                               failed(errorCode, msg);
                                           }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)queryAllNodeWithSuccess:(void(^)(NSArray<Node *> *array))success failed:(EBNetworkFailedBlock)failed {
    NSString *url = [EBNetworkCore contactURLString:@"nodes/all.json"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET"
                                                urlString:url
                                               parameters:nil
                                           successHandler:^(NSString *msg, id result) {
                                               NSError *error = nil;
                                               NSArray *arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
                                               if (error) {
                                                   failed(error.code, error.localizedDescription);
                                                   return ;
                                               }
                                               NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:arr.count];
                                               for (NSDictionary *dict in arr) {
                                                   error = nil;
                                                   Node *node = [[Node alloc] initWithDictionary:dict error:&error];
                                                   if (node) {
                                                       [resultArray addObject:node];
                                                   }
                                               }
                                               success(resultArray);
                                           } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                               failed(errorCode, msg);
                                           }];
    [task resume];
    return task;
}

@end
