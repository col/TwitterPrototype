//
//  TwitterManageriOS5.h
//  TwitterPrototype
//
//  Created by Colin Harris on 18/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "TwitterManager.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterManageriOS5 : TwitterManager

@property (nonatomic, readonly, retain) NSArray *accounts;
@property (nonatomic, retain) ACAccount *selectedAccount;

- (BOOL)hasAccount;
- (BOOL)hasMultipleAccounts;
- (NSArray *)accounts;

- (void)followUser:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)unfollowUser:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)isFollowing:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler;

@end
