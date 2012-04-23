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
//    #if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if( NSClassFromString(@"TWRequest") )
    {
        TwitterManager *twitterManager5 = [[TwitterManageriOS5 alloc] init];
        return twitterManager5;    
    }
    else
    {
        TwitterManager *twitterManager4 = [[TwitterManageriOS4 alloc] init];
        return twitterManager4;        
    }
}

- (void)requestAccessFromController:(UIViewController *)controller usingBlock:(TwitterManagerSuccessHandler)handler
{
    // TODO: throw exception here
    NSLog(@"Abstract Method!!");
}

- (void)followUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    // TODO: throw exception here
    NSLog(@"Abstract Method!!");    
}

- (void)unfollowUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    // TODO: throw exception here
    NSLog(@"Abstract Method!!");    
}

- (void)isFollowing:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    // TODO: throw exception here
    NSLog(@"Abstract Method!!");    
}

@end
