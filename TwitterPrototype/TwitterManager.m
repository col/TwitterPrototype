//
//  TwitterManager.m
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "TwitterManager.h"
#import "TwitterManageriOS5.h"
#import "TwitterManageriOS4.h"

@implementation TwitterManager

@synthesize accessGranted;

+ (TwitterManager *)twitterManager
{
    if( NSClassFromString(@"TWRequest") )
    {
        // >= iOS 5
        TwitterManager *twitterManager5 = [[TwitterManageriOS5 alloc] init];
        return twitterManager5;    
    }
    else
    {
        // <= iOS 4
        TwitterManager *twitterManager4 = [[TwitterManageriOS4 alloc] init];
        return twitterManager4;        
    }
}

- (void)requestAccessFromController:(UIViewController *)controller usingBlock:(TwitterManagerSuccessHandler)handler
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)followUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)unfollowUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)isFollowing:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
