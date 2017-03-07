//
//  Topic.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "EBNetworkCore.h"
#import "Reply.h"
#import "V2HardcodedData.h"

@class Member;
@class Node;
@interface Topic : JSONModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *content_rendered;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, assign) NSTimeInterval last_modified;
@property (nonatomic, assign) NSTimeInterval last_touched;
@property (nonatomic, strong) Node *node;
@property (nonatomic, strong) Member *member;

@end

typedef void(^TopicNetworkSuccessBlock)(NSArray<Topic *> *result);

@interface Topic (Request)

+ (NSURLSessionDataTask *)queryTopicUnderHotNodeType:(V2HotNodeType)nodeType;

/**
 最热主题：相当于首页右侧10大每天的内容
 */
+ (NSURLSessionDataTask *)queryHotTopicWithSuccess:(TopicNetworkSuccessBlock)success
                                            failed:(EBNetworkFailedBlock)failed;


/**
 最新主题：挡挡雨首页“全部”这个tab下的最新内容
 */
+ (NSURLSessionDataTask *)queryLatestTopicWithSuccess:(TopicNetworkSuccessBlock)success
                                               failed:(EBNetworkFailedBlock)failed;


/**
 根据主题id取主题信息
 */
+ (NSURLSessionDataTask *)queryTopciWithID:(NSUInteger)ID
                                   success:(TopicNetworkSuccessBlock)success
                                    failed:(EBNetworkFailedBlock)failed;


/**
 根据节点的nodename取节点下的所有主题
 */
+ (NSURLSessionDataTask *)queryTopicsWithNodeName:(NSString *)nodename
                                          success:(TopicNetworkSuccessBlock)success
                                           failed:(EBNetworkFailedBlock)failed;

/**
 根据节点id取节点下的所有主题
 */
+ (NSURLSessionDataTask *)queryTopicsWithNodeID:(NSUInteger)nodeID
                                        success:(TopicNetworkSuccessBlock)success
                                         failed:(EBNetworkFailedBlock)failed;

/**
 根据用户名取该用户所发表的主题
 */
+ (NSURLSessionDataTask *)queryTopicsWithUsername:(NSString *)username
                                          success:(TopicNetworkSuccessBlock)success
                                           failed:(EBNetworkFailedBlock)failed;

+ (NSURLSessionDataTask *)queryTopicsWithParameters:(NSDictionary *)params
                                            success:(TopicNetworkSuccessBlock)success
                                             failed:(EBNetworkFailedBlock)failed;

@end
