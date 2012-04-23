//
//  TwitterManageriOS4.m
//  TwitterPrototype
//
//  Created by Colin Harris on 18/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "TwitterManageriOS4.h"
#import "SA_OAuthTwitterEngine.h"


/* Define the constants below with the Twitter 
 Key and Secret for your application. Create
 Twitter OAuth credentials by registering your
 application as an OAuth Client here: http://twitter.com/apps/new
 */

#define kOAuthConsumerKey				@"vH7MaCTvpscj3XmpZtqg"	    
#define kOAuthConsumerSecret			@"vsb9zRrdnmGmRxYH8gFEGFzBW9EyClGRmuwpm2TIc"

@interface TwitterManageriOS4 ()

@property (nonatomic, retain) SA_OAuthTwitterEngine *engine;

@property (nonatomic, copy) TwitterManagerSuccessHandler requestAccessHandler;

@property (nonatomic, copy) TwitterManagerSuccessHandler followUserHandler;
@property (nonatomic, retain) NSString * followUserIdentifier;

@property (nonatomic, copy) TwitterManagerSuccessHandler unfollowUserHandler;
@property (nonatomic, retain) NSString * unfollowUserIdentifier;

@property (nonatomic, copy) TwitterManagerSuccessHandler isFollowingHandler;
@property (nonatomic, retain) NSString * isFollowingIdentifier;

@end

@implementation TwitterManageriOS4

@synthesize engine;
@synthesize requestAccessHandler;
@synthesize followUserHandler, followUserIdentifier;
@synthesize unfollowUserHandler, unfollowUserIdentifier;
@synthesize isFollowingHandler, isFollowingIdentifier;

- (id)init
{
    self = [super init];
    if( self ) {
        engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		engine.consumerKey    = kOAuthConsumerKey;
		engine.consumerSecret = kOAuthConsumerSecret;	
        engine.usesSecureConnection = NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)requestAccessFromController:(UIViewController *)controller usingBlock:(TwitterManagerSuccessHandler)handler
{
	UIViewController *authController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:engine delegate:self];    
    
    if( authController )
    {
        self.requestAccessHandler = handler;
        [controller presentModalViewController:authController animated:YES];
    } 
    else 
    {
        self.accessGranted = YES;
        handler(YES);
    }
}

- (void)followUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    if( self.followUserHandler == nil )
    {
        self.followUserHandler = handler;    
        self.followUserIdentifier = [engine enableUpdatesFor:username];
    } 
    else 
    {
        NSLog(@"follow user request already in progress!");
        handler(NO);
    }
}

- (void)unfollowUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    if( self.unfollowUserHandler == nil )
    {
        self.unfollowUserHandler = handler;    
        self.unfollowUserIdentifier = [engine disableUpdatesFor:username];
    } 
    else 
    {
        NSLog(@"unfollow user request already in progress!");
        handler(NO);
    }    
}

- (void)isFollowing:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{
    if( self.isFollowingHandler == nil )
    {
        self.isFollowingHandler = handler;
        self.isFollowingIdentifier = [engine isUser:engine.username receivingUpdatesFor:username];        
    }
    else 
    {
        NSLog(@"is following user request already in progress!");
        handler(NO);        
    }
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username
{
    if( self.requestAccessHandler ) 
    {
        self.accessGranted = YES;        
        self.requestAccessHandler(YES);
        self.requestAccessHandler = nil;
    }        
}

- (void)OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller
{
    if( self.requestAccessHandler ) 
    {
        self.accessGranted = NO;        
        self.requestAccessHandler(NO);
        self.requestAccessHandler = nil;
    }            
}

- (void)OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller
{
    if( self.requestAccessHandler ) 
    {
        self.accessGranted = NO;                
        self.requestAccessHandler(NO);
        self.requestAccessHandler = nil;
    }            
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username 
{    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *) username 
{
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark - MGTwitterEngineDelegate
- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    if( [self.followUserIdentifier isEqualToString:connectionIdentifier] )
    {
        self.followUserHandler(YES);
        self.followUserHandler = nil;        
        self.followUserIdentifier = nil;
    }
    else if( [self.unfollowUserIdentifier isEqualToString:connectionIdentifier] )
    {
        self.unfollowUserHandler(YES);
        self.unfollowUserHandler = nil;        
        self.unfollowUserIdentifier = nil;     
    }
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    if( [self.followUserIdentifier isEqualToString:connectionIdentifier] )
    {
        self.followUserHandler(NO);
        self.followUserHandler = nil;  
        self.followUserIdentifier = nil;
    }
    else if( [self.unfollowUserIdentifier isEqualToString:connectionIdentifier] )
    {
        self.unfollowUserHandler(NO);
        self.unfollowUserHandler = nil;        
        self.unfollowUserIdentifier = nil;                
    }
    else if( [self.isFollowingIdentifier isEqualToString:connectionIdentifier] )
    {
        self.isFollowingHandler(NO);
        self.isFollowingHandler = nil;        
        self.isFollowingIdentifier = nil;             
    }    
}
  
- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
    if( [self.isFollowingIdentifier isEqualToString:connectionIdentifier] )
    {
        if( miscInfo && [miscInfo count] == 1 ) {
            
            NSString *friends = [(NSDictionary *)[miscInfo objectAtIndex:0] valueForKey:@"friends"];
            self.isFollowingHandler([friends isEqualToString:@"true"]);
            self.isFollowingHandler = nil;        
            self.isFollowingIdentifier = nil;                         
        }
    }
}

@end
