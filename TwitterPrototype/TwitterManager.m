//
//  TwitterManager.m
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "TwitterManager.h"

@interface TwitterManager ()
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccountType *accountType;
@property (nonatomic, retain) NSArray *accounts;
@end

@implementation TwitterManager

@synthesize accountStore;
@synthesize accountType;
@synthesize accounts;
@synthesize selectedAccount;
@synthesize delegate;
@synthesize accessGranted;

- (id)init
{
    self = [super init];
    if( self ) {
        self.accountStore = [[[ACAccountStore alloc] init] autorelease];    
        self.accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return self;
}

- (void)dealloc
{
    self.accountStore = nil;
    self.accountType = nil;    
    [super dealloc];
}

- (void)followUser:(NSString *)username
{
    NSLog(@"followUser: %@", username);
    
    if( !self.selectedAccount ) {
        NSLog(@"No account selected!");
        return;
    }        
    
    [self followUser:username withAccount:self.selectedAccount];
}

- (void)followUser:(NSString *)username withAccount:(ACAccount *)account
{
    NSLog(@"followUser:'%@' withAccount:'%@'", username, account.username);
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setValue:username forKey:@"screen_name"];
    [paramsDict setValue:@"true" forKey:@"follow"];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.json"] 
                                                 parameters:paramsDict 
                                              requestMethod:TWRequestMethodPOST];
    
    [postRequest setAccount:account];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if( [urlResponse statusCode] == 200 )
        {
            // Success
            if( self.delegate && [self.delegate respondsToSelector:@selector(followUserDidSucceed)] )
                [self.delegate followUserDidSucceed];
        }
        else 
        {
            // Error
            NSLog(@"Status = %d", urlResponse.statusCode); 
            NSLog(@"Localized Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Error = %@", [error localizedDescription]);                     
            NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);        
            if( self.delegate && [self.delegate respondsToSelector:@selector(followUserDidFailWithError:)] )
                [self.delegate followUserDidFailWithError:error];            
        }
        
    }];
}

- (void)unfollowUser:(NSString *)username
{
    NSLog(@"unfollowUser: %@", username);
    
    if( !self.selectedAccount ) {
        NSLog(@"No account selected!");
        return;
    }        
    
    [self unfollowUser:username withAccount:self.selectedAccount];
}

- (void)unfollowUser:(NSString *)username withAccount:(ACAccount *)account
{
    NSLog(@"unfollowUser:'%@' withAccount:'%@'", username, account.username);
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setValue:username forKey:@"screen_name"];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friendships/destroy.json"] 
                                                 parameters:paramsDict 
                                              requestMethod:TWRequestMethodPOST];
    
    [postRequest setAccount:account];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if( [urlResponse statusCode] == 200 )
        {
            // Success
            if( self.delegate && [self.delegate respondsToSelector:@selector(followUserDidSucceed)] )
                [self.delegate unfollowUserDidSucceed];
        }
        else 
        {
            // Error
            NSLog(@"Status = %d", urlResponse.statusCode); 
            NSLog(@"Localized Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Error = %@", [error localizedDescription]);                     
            NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);        
            if( self.delegate && [self.delegate respondsToSelector:@selector(unfollowUserDidFailWithError:)] )
                [self.delegate unfollowUserDidFailWithError:error];            
        }
        
    }];
}

- (void)isFollowing:(NSString *)username
{
    NSLog(@"isFollowing: %@", username);
    
    if( !self.selectedAccount ) {
        NSLog(@"No account selected!");
        return;
    }        
    
    [self isFollowing:username withAccount:self.selectedAccount];    
}

- (void)isFollowing:(NSString *)username withAccount:(ACAccount *)account
{
    NSLog(@"isFollowing:'%@' withAccount:'%@'", username, account.username);
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setValue:username forKey:@"screen_name"];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friendships/lookup.json"] 
                                                 parameters:paramsDict 
                                              requestMethod:TWRequestMethodGET];
    
    [postRequest setAccount:account];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if( [urlResponse statusCode] == 200 )
        {
            // TODO: process the response!
            BOOL result = YES;
            
            // Success
            if( self.delegate && [self.delegate respondsToSelector:@selector(isFollowingUser:result:)] )
                [self.delegate isFollowingUser:username result:result];
        }
        else 
        {
            // Error
            NSLog(@"Status = %d", urlResponse.statusCode); 
            NSLog(@"Localized Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Error = %@", [error localizedDescription]);                     
            NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);        
            if( self.delegate && [self.delegate respondsToSelector:@selector(unfollowUserDidFailWithError:)] )
                [self.delegate isFollowingUserDidFailWithError:error];            
        }
        
    }];    
}

- (BOOL)hasAccount
{
    if( self.accounts == nil )
        [self requestAccess];
    
    return [accounts count] > 0;        
}

- (BOOL)hasMultipleAccounts
{
    if( self.accounts == nil )
        [self requestAccess];
    
    return [accounts count] > 1;    
}

- (NSArray *)accounts
{
    if( !accounts )
        [self requestAccess];
    return accounts;
}

- (ACAccount *)selectedAccount
{
    if( !selectedAccount && self.accounts && [self.accounts count] > 0 )
        self.selectedAccount = [self.accounts objectAtIndex:0];
    
    return selectedAccount;
}

- (void)requestAccess
{
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        NSLog(@"Access Granted = %@", granted ? @"YES" : @"NO");
        self.accessGranted = granted;
        if( granted )
        {
            self.accounts = [accountStore accountsWithAccountType:accountType];
            NSLog(@"# of accounts = %d", [self.accounts count]);
            if( self.delegate && [self.delegate respondsToSelector:@selector(accessGranted)] )
                [self.delegate accessGranted];
        }
        else 
        {
            NSLog(@"Error = %@", [error localizedDescription]);
            if( self.delegate && [self.delegate respondsToSelector:@selector(accessDenied)] )
                [self.delegate accessDenied];            
        }        
        
    }];
}

@end
