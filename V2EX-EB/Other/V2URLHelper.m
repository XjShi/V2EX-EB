//
//  V2URLHelper.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "V2URLHelper.h"

@implementation V2URLHelper

+ (NSURL *)getHTTPSLink:(NSString *)str {
    NSString *tmp = [NSString stringWithFormat:@"https:%@", str];
    return [NSURL URLWithString:tmp];
}

+ (BOOL)isHTTPURL:(NSURL *)url {
    NSString *scheme = url.scheme;
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isMailURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"mailto"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
