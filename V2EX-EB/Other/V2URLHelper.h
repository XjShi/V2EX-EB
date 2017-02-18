//
//  V2URLHelper.h
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface V2URLHelper : NSObject

+ (NSURL *)getHTTPSLink:(NSString *)str;
+ (BOOL)isHTTPURL:(NSURL *)url;
+ (BOOL)isMailURL:(NSURL *)url;

@end
