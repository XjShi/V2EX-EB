//
//  Topic.m
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "Topic.h"
#import "EBError.h"
#import "HTMLParser.h"

@implementation Topic

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}

@end

@implementation Topic (Request)

+ (NSURLSessionDataTask *)queryTopicUnderHotNodeType:(V2HotNodeType)nodeType {
    const NSString *nodeText = [V2HardcodedData getHotNodeText:nodeType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:nodeText forKey:@"tab"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET" urlString:kV2exURLString parameters:params successHandler:^(NSString *msg, id result) {
        /* 不爬取网页来解析了，开放了什么接口就用什么，这个不管了
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:result error:&error];
        if (error) {
            DDLogError(@"解析主题列表出错: %@", error.localizedDescription);
            return ;
        }
        HTMLNode *bodyNode = [parser body];
        NSArray<HTMLNode *> *cellItems = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"cell item" allowPartial:YES];
        NSMutableArray<Topic *> *resultArray = [self topicArrayWithCapacity:cellItems.count];
        for (NSInteger i = 0; i< cellItems.count; i++) {
            HTMLNode *node = cellItems[i];
            Topic *topic = resultArray[i];
            HTMLNode *tmpNode = [node findChildOfClass:@"avatar"];
            topic.member.avatar_normal = [tmpNode getAttributeNamed:@"src"];
            tmpNode = [node findChildOfClass:@"item_title"];
            tmpNode = [tmpNode findChildTag:@"a"];
            DDLogInfo(@"title: %@", tmpNode.contents);
            DDLogInfo(@"topicId: %@", [tmpNode getAttributeNamed:@"href"]);
        }
        */
    } failedHandler:^(NSInteger errorCode, NSString *msg) {
        
    }];
    [task resume];
    return task;
}

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

+ (NSMutableArray *)topicArrayWithCapacity:(NSInteger)capacity {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        Topic *topic = [Topic new];
        [result addObject:topic];
    }
    return result;
}

@end
