//
//  Reply.h
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Member.h"

@interface Reply : JSONModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, assign) NSUInteger thanks;
@property (nonatomic, assign) NSTimeInterval created;
@property (nonatomic, assign) NSTimeInterval last_modified;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *content_rendered;
@property (nonatomic, strong) Member *member;

@end
