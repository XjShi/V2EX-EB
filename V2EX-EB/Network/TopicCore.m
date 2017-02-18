//
//  TopicCore.m
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "TopicCore.h"
#import "Topic.h"
#import "EBError.h"
#import "Reply.h"

@implementation TopicCore

+ (NSURLSessionDataTask *)queryHotTopicWithSuccess:(void (^)(NSArray<Topic *> *))success
                                            failed:(EBNetworkFailedBlock)failed {
    NSString *url = [EBNetworkCore contactURLString:@"topics/hot.json"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET"
                                                urlString:url
                                               parameters:nil
                                           successHandler:^(NSString *msg, id result) {
                                               [self handleResult:result withSuccess:success failed:failed];
                                           } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                               failed(errorCode, msg);
                                           }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)queryLatestTopicWithSuccess:(TopicNetworkSuccessBlock)success
                                               failed:(EBNetworkFailedBlock)failed {
    NSString *url = [EBNetworkCore contactURLString:@"topics/latest.json"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET"
                                                urlString:url
                                               parameters:nil
                                           successHandler:^(NSString *msg, id result) {
                                               [self handleResult:result withSuccess:success failed:failed];
                                           } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                               failed(errorCode, msg);
                                           }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)queryTopciWithID:(NSUInteger)ID
                                   success:(TopicNetworkSuccessBlock)success
                                    failed:(EBNetworkFailedBlock)failed {
    NSDictionary *params = @{@"id": @(ID)};
    NSURLSessionDataTask *task = [self queryTopicsWithParameters:params success:success failed:failed];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)queryTopicsWithNodeName:(NSString *)nodename
                                          success:(TopicNetworkSuccessBlock)success
                                           failed:(EBNetworkFailedBlock)failed {
    if (!nodename || nodename.length == 0) {
        return nil;
    }
    NSDictionary *params = @{@"node_name": nodename};
    NSURLSessionDataTask *task = [self queryTopicsWithParameters:params success:success failed:failed];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)queryTopicsWithNodeID:(NSUInteger)nodeID
                                        success:(TopicNetworkSuccessBlock)success
                                         failed:(EBNetworkFailedBlock)failed {
    NSDictionary *params = @{@"node_id": @(nodeID)};
    NSURLSessionDataTask *task = [self queryTopicsWithParameters:params success:success failed:failed];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)queryTopicsWithUsername:(NSString *)username
                                          success:(TopicNetworkSuccessBlock)success
                                           failed:(EBNetworkFailedBlock)failed {
    NSDictionary *params = @{@"username": username};
    NSURLSessionDataTask *task = [self queryTopicsWithParameters:params success:success failed:failed];
    [task resume];
    return task;
}

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

#pragma mark - Private Method
+ (void)handleResult:(id)result withSuccess:(TopicNetworkSuccessBlock)success failed:(EBNetworkFailedBlock)failed {
    NSError *error = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:result
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    if (error) {
        failed(EBErrorCodeUndefined, error.localizedDescription);
        return ;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *dict in arr) {
        error = nil;
        Topic *topic = [[Topic alloc] initWithDictionary:dict error:&error];
        if (topic) {
            [resultArray addObject:topic];
        }
    }
    success(resultArray);
}

+ (NSURLSessionDataTask *)queryTopicsWithParameters:(NSDictionary *)params
                                            success:(TopicNetworkSuccessBlock)success
                                             failed:(EBNetworkFailedBlock)failed {
    NSString *url = [EBNetworkCore contactURLString:@"topics/show.json"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET"
                                                urlString:url
                                               parameters:params
                                           successHandler:^(NSString *msg, id result) {
                                               [self handleResult:result withSuccess:success failed:failed];
                                           } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                               failed(errorCode, msg);
                                           }];
    return task;
}

@end