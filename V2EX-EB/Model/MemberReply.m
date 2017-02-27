//
//  MemberReply.m
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "MemberReply.h"
#import "HTMLParser.h"

@implementation MemberReply

- (NSUInteger)topicID {
    NSString *ID = [self.topicURL substringWithRange:NSMakeRange(3, 6)];
    return ID.integerValue;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.time, self.replyDescription, self.topicTitle, self.content];
}

@end

@implementation MemberReply (Request)

+ (NSURLSessionDataTask *)queryRepliesWithUsername:(NSString *)username
                                           success:(void (^)(NSArray<MemberReply *> *))success
                                            failed:(EBNetworkFailedBlock)failed {
    
    NSString *str = [NSString stringWithFormat:@"https://www.v2ex.com/member/%@/replies", username];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET" urlString:str parameters:nil successHandler:^(NSString *msg, id result) {
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:result error:&error];
        if (error) {
            DDLogError(@"解析用户回复数据出错：%@", error.localizedDescription);
            return ;
        }
        HTMLNode *bodyNode = [parser body];
        NSArray<HTMLNode *> *tmp = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"reply_content" allowPartial:YES];
        NSMutableArray *resultArray = [self replyArrayWithCapacity:tmp.count];
        
        [tmp enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MemberReply *reply = resultArray[idx];
            reply.content = obj.allContents;
            
        }];
        
        tmp = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"fade" allowPartial:YES];
        [tmp enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != tmp.count - 1) {
                MemberReply *reply = resultArray[idx];
                reply.time = obj.contents;
            }
        }];
        
        tmp = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"gray" allowPartial:YES];
        [tmp enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray<HTMLNode *> *children = obj.children;
            if (children.count == 4) {
                MemberReply *reply = resultArray[idx - 1];
                reply.replyDescription = obj.contents;
                HTMLNode *node = children.lastObject;
                reply.topicTitle = node.contents;
                reply.topicURL = [node getAttributeNamed:@"href"];
            }
        }];
        success(resultArray);
    } failedHandler:^(NSInteger errorCode, NSString *msg) {
        failed(errorCode, msg);
    }];
    [task resume];
    return task;
}

+ (NSMutableArray *)replyArrayWithCapacity:(NSInteger)capacity {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        MemberReply *reply = [MemberReply new];
        [result addObject:reply];
    }
    return result;
}

@end
