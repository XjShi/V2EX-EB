//
//  LoginCore.m
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "LoginCore.h"
#import "HTMLParser.h"
#import "EBError.h"

static NSString *const kOnceKey = @"once";
static NSString *const kNextKey = @"next";

@implementation LoginCore

+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void(^)(NSString *username))success
                   failed:(EBNetworkFailedBlock)failed {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [self hackSecurityLoginInformationWithSuccess:^(NSDictionary *dict) {
        NSDictionary *params = @{kOnceKey: dict[kOnceKey],
                                 kNextKey: dict[kNextKey],
                                 dict[@"username"]: username,
                                 dict[@"password"]: password};
        EBNetworkCore *core = [EBNetworkCore sharedInstance];
        NSString *url = @"https://www.v2ex.com/signin";
        NSURLSessionDataTask *task = [core dataTaskWithMethod:@"POST"
                                                    urlString:url
                                                   parameters:params
                                               successHandler:^(NSString *msg, id result) {
                                                   NSString *str = [[NSString alloc] initWithData:result encoding:4];
                                                   NSRange range = [str rangeOfString:@"adsbygoogle"];
                                                   if (range.location != NSNotFound) {
                                                       success(username);
                                                   } else {
                                                       failed(EBErrorCodeUndefined, @"好像没有登录成功");
                                                   }
                                               } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                                   failed(errorCode, msg);
                                               }];
        [task resume];
    } failed:^{
        failed(EBErrorCodeHackSecurityInformationError, @"好像出了问题");
    }];
}

+ (NSURLSessionDataTask *)hackSecurityLoginInformationWithSuccess:(void(^)(NSDictionary *dict))success
                                                           failed:(void(^)())failed {
    NSString *url = @"https://www.v2ex.com/signin";
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *task = [core dataTaskWithMethod:@"GET"
                                                urlString:url
                                               parameters:nil
                                           successHandler:^(NSString *msg, id result) {
                                               NSDictionary *dict = [self getSecurityDictionary:result];
                                               success(dict);
                                           } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                               failed();
                                           }];
    [task resume];
    return task;
}

+ (NSDictionary *)getSecurityDictionary:(NSData *)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    @autoreleasepool {
        NSString *html = [[NSString alloc] initWithData:result encoding:4];
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        HTMLNode *bodyNode = [parser body];
        NSArray *inputNodes = [bodyNode findChildTags:@"input"];
        [inputNodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HTMLNode class]]) {
                HTMLNode *node = (HTMLNode *)obj;
                if ([[node getAttributeNamed:@"name"] isEqualToString:kOnceKey]) {
                    dict[kOnceKey] = [node getAttributeNamed:@"value"];
                }
                if ([[node getAttributeNamed:@"name"] isEqualToString:kNextKey]) {
                    dict[kNextKey] = [node getAttributeNamed:@"value"];
                }
                if ([[node getAttributeNamed:@"type"] isEqualToString:@"text"]) {
                    dict[@"username"] = [node getAttributeNamed:@"name"];
                }
                if ([[node getAttributeNamed:@"type"] isEqualToString:@"password"]) {
                    dict[@"password"] = [node getAttributeNamed:@"name"];
                }
            }
        }];
    }
    return dict;
}

@end
