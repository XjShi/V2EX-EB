//
//  V2TimeHelper.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "V2TimeHelper.h"

static const NSInteger kSecondInOneMinute = 60.;
static const NSInteger kSecondInOneHour = 3600.;
static const NSInteger kSecondInOneDay = 86400.;   //3600*24

@implementation V2TimeHelper

+ (NSString *)getEarlyTimeDescriptionFromTimestamp:(NSTimeInterval)timestamp {
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
    if (ceil(nowTimestamp) < ceil(timestamp)) {
        return @"";
    }
    NSUInteger sub = ceil(nowTimestamp) - ceil(timestamp);
    if (sub < kSecondInOneMinute) {
        return [NSString stringWithFormat:@"%lu秒前", sub];
    } else if (sub >= kSecondInOneMinute && sub < kSecondInOneHour) {
        return [NSString stringWithFormat:@"%lu分钟前", sub / kSecondInOneMinute];
    } else if (sub >= kSecondInOneHour && sub < kSecondInOneDay) {
        return [NSString stringWithFormat:@"%lu小时前", sub / kSecondInOneHour];
    } else if (sub >= kSecondInOneDay) {
        return [NSString stringWithFormat:@"%lu天前", sub / kSecondInOneDay];
    }
    return @"";
}

@end
