//
//  User.h
//  V2EX-EB
//
//  Created by xjshi on 09/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Member : JSONModel

@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSString *psn;
@property (nonatomic, copy) NSString *github;
@property (nonatomic, copy) NSString *btc;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *tagline;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *avatar_mini;
@property (nonatomic, copy) NSString *avatar_normal;
@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic, assign) NSTimeInterval created;

@end
