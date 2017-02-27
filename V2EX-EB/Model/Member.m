//
//  User.m
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "Member.h"

@implementation Member

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

- (NSUInteger)hash {
    return _ID ^ [_username hash];
}

@end

@implementation Member (Request)

+ (NSURLSessionDataTask *)queryMemberInfoByID:(NSUInteger)ID
                                       succss:(MemberNetworkSuccessBlock)success
                                       failed:(EBNetworkFailedBlock)failed {
    NSDictionary *params = @{@"id": @(ID)};
    return [self queryMemberInfoWithParams:params succss:success failed:failed];
}

+ (NSURLSessionDataTask *)queryMemberInfoByName:(NSString *)name
                                         succss:(MemberNetworkSuccessBlock)success
                                         failed:(EBNetworkFailedBlock)failed {
    if (!name || name.length == 0) {
        failed(EBErrorCodeInvalidArguments, @"查询的用户名不正确");
        return nil;
    }
    NSDictionary *params = @{@"username": name};
    return [self queryMemberInfoWithParams:params succss:success failed:failed];
}

+ (NSURLSessionDataTask *)queryMemberInfoWithParams:(NSDictionary *)params
                                             succss:(MemberNetworkSuccessBlock)success
                                             failed:(EBNetworkFailedBlock)failed {
    NSString *url = [EBNetworkCore contactURLString:@"members/show.json"];
    EBNetworkCore *core = [EBNetworkCore sharedInstance];
    NSURLSessionDataTask *dataTask = [core dataTaskWithMethod:@"GET"
                                                    urlString:url
                                                   parameters:params
                                               successHandler:^(NSString *msg, id result) {
                                                   NSError *error = nil;
                                                   Member *m = [[Member alloc] initWithData:result error:&error];
                                                   if (error) {
                                                       failed(error.code, error.localizedDescription);
                                                       return ;
                                                   }
                                                   success(m);
                                               } failedHandler:^(NSInteger errorCode, NSString *msg) {
                                                   failed(errorCode, msg);
                                               }];
    [dataTask resume];
    return dataTask;
}

@end
