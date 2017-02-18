//
//  Topic.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class Member;
@class Node;
@interface Topic : JSONModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *content_rendered;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, assign) NSTimeInterval last_modified;
@property (nonatomic, assign) NSTimeInterval last_touched;
@property (nonatomic, strong) Node *node;
@property (nonatomic, strong) Member *member;

@end
