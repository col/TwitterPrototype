//
//  TwitterManager.h
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// Completion block for performRequestWithHandler. 
typedef void(^TwitterManagerSuccessHandler)(BOOL success);

@interface TwitterManager : NSObject

@property (nonatomic, assign) BOOL accessGranted;

+ (TwitterManager *)twitterManager;

//- (void)requestAccessUsingBlock:(TwitterManagerSuccessHandler)handler;
- (void)requestAccessFromController:(UIViewController *)controller usingBlock:(TwitterManagerSuccessHandler)handler;

- (void)followUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)unfollowUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler;
- (void)isFollowing:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler;

@end
