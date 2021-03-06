//
//  EBNetworkCore.m
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "EBNetworkCore.h"

static NSString *const kBaseUrlString = @"https://www.v2ex.com/api";
NSString *const kV2exURLString = @"https://www.v2ex.com/";
NSString *const kV2UserAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/602.4.8 (KHTML, like Gecko) Version/10.0.3 Safari/602.4.8";

@interface EBNetworkCore ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, copy) NSString *baseURLString;

@end

@implementation EBNetworkCore

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static EBNetworkCore *core = nil;
    dispatch_once(&onceToken, ^{
        core = [[EBNetworkCore alloc] init];
    });
    return core;
}

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        NSString *userAgentMobile = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [self.sessionManager.requestSerializer setValue:userAgentMobile forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method
                                   urlString:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                              successHandler:(EBNetworkSuccessBlock)successHandler
                               failedHandler:(EBNetworkFailedBlock)failedHandler {
    NSError *error = nil;
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method
                                                                          URLString:URLString
                                                                         parameters:parameters
                                                                              error:&error];
    NSAssert(!error, @"构造Request失败: %@", URLString);
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request
                                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                if (error) {
                                                                    failedHandler(error.code, error.localizedDescription);
                                                                } else {
                                                                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                                        successHandler(nil, responseObject);
                                                                    }
                                                                }
                                                            }];
    return dataTask;
}
/*
 header:
 "Content-Encoding" = gzip;
 "Content-Type" = "application/json;charset=UTF-8";
 Date = "Thu, 09 Feb 2017 14:43:41 GMT";
 Etag = "W/\"06a03db6c312cfc55692469964c7a1b10bb4d2e1\"";
 Expires = "-1";
 Server = "Galaxy/3.9.7.5";
 "Strict-Transport-Security" = "max-age=10886400";
 Vary = "Accept-Encoding";
 google = XY;
 "x-orca-accelerator" = "MISS from 093.chn.fuo01.cn.krill.c3edge.net";
 "x-rate-limit-limit" = 120;
 "x-rate-limit-remaining" = 113;
 "x-rate-limit-reset" = 1486652400;
 */

+ (NSString *)contactURLString:(NSString *)str {
    return [kBaseUrlString stringByAppendingPathComponent:str];
}

@end
