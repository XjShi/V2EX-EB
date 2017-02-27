//
//  EBAccountManager.h
//  V2EX-EB
//
//  Created by xjshi on 18/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kAccountManagerCurrentLoginMemberChangedNotification;

@interface EBAccountManager : NSObject

+ (instancetype)sharedManager;
- (BOOL)saveAccount:(NSString *)account password:(NSString *)password;
- (NSString *)passwordForAccount:(NSString *)account;
- (BOOL)deleteAccount:(NSString *)account;
- (NSArray *)getAllAccounts;

@end

@class Member;
@interface EBAccountManager (CurrentLoginMember)

+ (BOOL)saveMember:(Member *)member;
+ (Member *)fetchMember;
+ (BOOL)clear;
+ (BOOL)hasLoginMember;

@end
