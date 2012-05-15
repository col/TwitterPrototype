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

static TwitterManager *sharedTwitterManager = nil;

+ (TwitterManager *)twitterManager
{
    if( sharedTwitterManager )
        return sharedTwitterManager;
    
    if( NSClassFromString(@"TWRequest") )
    {
        // >= iOS 5
        sharedTwitterManager = [[TwitterManageriOS5 alloc] init];
    }
    else
    {
        // <= iOS 4
        sharedTwitterManager = [[TwitterManageriOS4 alloc] init];
    }
    return sharedTwitterManager;        
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

- (BOOL)accessGranted
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];    
}

- (void)setAaccessGranted:(BOOL)value
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];    
}

@end
