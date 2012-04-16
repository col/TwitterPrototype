//
//  TwitterManager.h
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

// Completion block for performRequestWithHandler. 
typedef void(^TwitterManagerSuccessHandler)(BOOL success);

@interface TwitterManager : NSObject

@property (nonatomic, readonly) NSArray *accounts;
@property (nonatomic, retain) ACAccount *selectedAccount;
@property (nonatomic, assign) BOOL accessGranted;

- (void)requestAccessUsingBlock:(TwitterManagerSuccessHandler)handler;

- (void)followUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)followUser:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler;

- (void)unfollowUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)unfollowUser:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler;

- (void)isFollowing:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)isFollowing:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler;

- (BOOL)hasAccount;
- (BOOL)hasMultipleAccounts;
- (NSArray *)accounts;

@end
