//
//  V2HardcodedData.h
//  V2EX-EB
//
//  Created by xjshi on 06/03/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, V2HotNodeType) {
    V2HotNodeTypeCreative,
    V2HotNodeTypePlay,
    V2HotNodeTypeApple,
    V2HotNodeTypeJobs,
    V2HotNodeTypeDeals,
    V2HotNodeTypeCity,
    V2HotNodeTypeQna,
    V2HotNodeTypeHot,
    V2HotNodeTypeAll,
    V2HotNodeTypeR2,
    V2HotNodeTypeMembers,
    V2HotNodeTypeTech
};

@interface V2HardcodedData : NSObject

+ (const NSString *)getHotNodeText:(V2HotNodeType)nodeType;

@end
