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

@protocol TwitterManagerDelegate <NSObject>

- (void)accessGranted;
- (void)accessDenied;

- (void)followUserDidSucceed;
- (void)followUserDidFailWithError:(NSError *)error;

- (void)unfollowUserDidSucceed;
- (void)unfollowUserDidFailWithError:(NSError *)error;

- (void)isFollowingUser:(NSString *)username result:(BOOL)result;
- (void)isFollowingUserDidFailWithError:(NSError *)error;

@end

@interface TwitterManager : NSObject

@property (nonatomic, assign) id<TwitterManagerDelegate> delegate;
@property (nonatomic, readonly) NSArray *accounts;
@property (nonatomic, retain) ACAccount *selectedAccount;
@property (nonatomic, assign) BOOL accessGranted;

- (void)requestAccess;

- (void)followUser:(NSString *)username;
- (void)followUser:(NSString *)username withAccount:(ACAccount *)account;

- (void)unfollowUser:(NSString *)username;
- (void)unfollowUser:(NSString *)username withAccount:(ACAccount *)account;

- (void)isFollowing:(NSString *)username;
- (void)isFollowing:(NSString *)username withAccount:(ACAccount *)account;

- (BOOL)hasAccount;
- (BOOL)hasMultipleAccounts;
- (NSArray *)accounts;

@end
