//
//  TTTAttributedLabel+DetectUsername.m
//  V2EX-EB
//
//  Created by xjshi on 17/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "TTTAttributedLabel+DetectUsername.h"

@implementation TTTAttributedLabel (DetectUsername)

- (void)detectUsernameAndAddLink {
    NSString *str = self.text;
    NSError *error = nil;
    NSString *regex = @"@[A-Z0-9a-z]+";
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:regex
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error];
    [regularExpression enumerateMatchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        DDLogDebug(@"%@, %llu", NSStringFromRange(result.range), result.resultType);
        if (result) {
            NSRange range = NSMakeRange(result.range.location+1, result.range.length-1);
            NSString *username = [str substringWithRange:range];
            [self addLinkToURL:[NSURL URLWithString:username] withRange:range];
        }
    }];
}

@end
