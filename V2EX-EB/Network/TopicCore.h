//
//  TopicCore.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBNetworkCore.h"

@class Topic;
@class Reply;

typedef void(^TopicNetworkSuccessBlock)(NSArray<Topic *> *result);

@interface TopicCore : NSObject

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

+ (NSURLSessionDataTask *)queryReplyWithTopicID:(NSInteger)topicID
                                           page:(NSInteger)page
                                      page_size:(NSInteger)page_size
                                        success:(void(^)(NSArray<Reply *> *replies))success
                                         failed:(EBNetworkFailedBlock)failed;
@end
