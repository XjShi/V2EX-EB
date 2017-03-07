//
//  V2HardcodedData.m
//  V2EX-EB
//
//  Created by xjshi on 06/03/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "V2HardcodedData.h"

@implementation V2HardcodedData

static const NSString *V2HotNodeTypes[] = {
    [V2HotNodeTypeR2] = @"r2",
    [V2HotNodeTypeAll] = @"all",
    [V2HotNodeTypeApple] = @"apple",
    [V2HotNodeTypeQna] = @"qna",
    [V2HotNodeTypeCity] = @"city",
    [V2HotNodeTypeCreative] = @"creative",
    [V2HotNodeTypePlay] = @"play",
    [V2HotNodeTypeJobs] = @"jobs",
    [V2HotNodeTypeDeals] = @"deals",
    [V2HotNodeTypeHot] = @"hot",
    [V2HotNodeTypeMembers] = @"members",
    [V2HotNodeTypeTech] = @"tech"
};

+ (const NSString *)getHotNodeText:(V2HotNodeType)nodeType {
    return V2HotNodeTypes[nodeType];
}

@end
