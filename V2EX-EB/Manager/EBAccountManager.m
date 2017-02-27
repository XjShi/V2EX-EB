//
//  EBAccountManager.m
//  V2EX-EB
//
//  Created by xjshi on 18/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "EBAccountManager.h"
#import "SAMKeychain.h"
#import "Member.h"

NSString *const kAccountManagerCurrentLoginMemberChangedNotification = @"kAccountManagerCurrentLoginMemberChangedNotification";

@implementation EBAccountManager
{
    NSString *_serviceName;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static EBAccountManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        _serviceName = [NSString stringWithFormat:@"%@.login", bundle];
    }
    return self;
}

- (BOOL)saveAccount:(NSString *)account password:(NSString *)password {
    NSError *error = nil;
    BOOL success = [SAMKeychain setPassword:password forService:_serviceName account:account error:&error];
    if (!success) {
        NSInteger errorCode = error.code;
        if (errorCode == errSecItemNotFound) {
            DDLogDebug(@"not found account：%@", account);
        } else {
            DDLogDebug(@"set account：%@", error.localizedDescription);
        }
    }
    return success;
}

- (BOOL)deleteAccount:(NSString *)account {
    NSError *error = nil;
    BOOL success = [SAMKeychain deletePasswordForService:_serviceName account:account error:&error];
    if (!success) {
        NSInteger errorCode = error.code;
        if (errorCode == errSecItemNotFound) {
            DDLogDebug(@"not found account: %@", account);
        } else {
            DDLogDebug(@"set account: %@", error.localizedDescription);
        }
    }
    return success;
}

- (NSString *)passwordForAccount:(NSString *)account {
    NSError *error = nil;
    NSString *password = [SAMKeychain passwordForService:_serviceName account:account error:&error];
    if (!password) {
        DDLogError(@"查找密码出错：%@", error.localizedDescription);
    }
    return password;
}

- (NSArray *)getAllAccounts {
    NSArray *accounts = [SAMKeychain accountsForService:_serviceName];
    return accounts;
}

@end

@implementation EBAccountManager (CurrentLoginMember)

+ (BOOL)saveMember:(Member *)member {
    NSData *data = [member toJSONData];
    BOOL success = [data writeToFile:[self memberInfoPath] atomically:YES];
    if (!success) {
        DDLogDebug(@"write current member info to file failed");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kAccountManagerCurrentLoginMemberChangedNotification
                                                        object:self
                                                      userInfo:@{@"member": member}];
    return success;
}

+ (Member *)fetchMember {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self memberInfoPath]];
    if (data.length == 0) {
        return nil;
    }
    NSError *error = nil;
    Member *member = [[Member alloc] initWithData:data error:&error];
    if (error.code != 0) {
        DDLogError(@"fetch current member: %@", error.localizedDescription);
    }
    return member;
}

+ (BOOL)clear {
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[self memberInfoPath] error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAccountManagerCurrentLoginMemberChangedNotification
                                                        object:self
                                                      userInfo:nil];
    return success;
}

+ (NSString *)memberInfoPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"user.dat"];
    return path;
}

+ (BOOL)hasLoginMember {
    Member *member = [self fetchMember];
    if (member) {
        return YES;
    }
    return NO;
}

@end
