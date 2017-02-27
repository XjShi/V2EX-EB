//
//  Reply.m
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "Reply.h"

@implementation Reply

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}

@end

@implementation Reply (Request)

+ (NSURLSessionDataTask *)queryReplyWithTopicID:(NSInteger)topicID
                                           page:(NSInteger)page
                                      page_size:(NSInteger)page_size
                                        success:(void (^)(NSArray<Reply *> *))success
                                         failed:(EBNetworkFailedBlock)failed {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(topicID), @"topic_id", nil];
    if (page > 0) {
        params[@"page"] = @(page);
    }
    if (page_size > 0) {
        params[@"page_size"] = @(page_size);
    }
    NSString *url = [EBNetworkCore contactURLString:@"replies/show.json"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET" urlString:url parameters:params successHandler:^(NSString *msg, id result) {
        NSError *error = nil;
        NSArray *array = [Reply arrayOfModelsFromData:result error:&error];
        if (!array) {
            failed(error.code, error.localizedDescription);
            return ;
        }
        success(array);
    } failedHandler:^(NSInteger errorCode, NSString *msg) {
        failed(errorCode, msg);
    }];
    [task resume];
    return task;
}

@end
