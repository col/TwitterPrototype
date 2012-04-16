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

- (void)requestAccessUsingBlock:(TwitterManagerSuccessHandler)handler
{
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        self.accessGranted = granted;
        if( granted )
            self.accounts = [accountStore accountsWithAccountType:accountType];
        if( handler ) handler(granted);        
        
    }];
}

- (void)followUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{  
    if( !self.selectedAccount ) {
        NSLog(@"No account selected!");
        return;
    }        
    
    [self followUser:username withAccount:self.selectedAccount usingBlock:handler];
}

- (void)followUser:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler
{
    NSLog(@"followUser:'%@' withAccount:'%@' usingBlock:", username, account.username);
    
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
            handler(YES);
        }
        else 
        {
            // Error
            NSLog(@"Status = %d", urlResponse.statusCode); 
            NSLog(@"Localized Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Error = %@", [error localizedDescription]);                     
            NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);        
            handler(NO);
        }
        
    }];
}

- (void)unfollowUser:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{   
    if( !self.selectedAccount ) {
        NSLog(@"No account selected!");
        return;
    }        
    
    [self unfollowUser:username withAccount:self.selectedAccount usingBlock:handler];
}

- (void)unfollowUser:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler
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
           handler(YES);
        }
        else 
        {
            // Error
            NSLog(@"Status = %d", urlResponse.statusCode); 
            NSLog(@"Localized Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Error = %@", [error localizedDescription]);                     
            NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);        
            handler(NO);           
        }
        
    }];
}

- (void)isFollowing:(NSString *)username usingBlock:(TwitterManagerSuccessHandler)handler
{   
    if( !self.selectedAccount ) {
        NSLog(@"No account selected!");
        return;
    }        
    
    [self isFollowing:username withAccount:self.selectedAccount usingBlock:handler];    
}

- (void)isFollowing:(NSString *)username withAccount:(ACAccount *)account usingBlock:(TwitterManagerSuccessHandler)handler
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
            BOOL result = NO;
            
            //  Use the NSJSONSerialization class to parse the returned JSON
            NSError *jsonError;
            NSArray *followStatuses = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                options:NSJSONReadingMutableLeaves 
                                                                  error:&jsonError];            
            if( [followStatuses count] == 1 ) 
            {
                NSDictionary *dictionary = [followStatuses objectAtIndex:0];
                NSArray *connections = [dictionary valueForKey:@"connections"];
                if( [connections count] == 1 )
                {
                    NSString *connection = [connections objectAtIndex:0];
                    result = [connection isEqualToString:@"following"];
                }
            }
            
            // Success
            handler(result);
        }
        else 
        {
            // Error
            NSLog(@"Status = %d", urlResponse.statusCode); 
            NSLog(@"Localized Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Error = %@", [error localizedDescription]);                     
            NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);        
            handler(NO);
        }
        
    }];    
}

- (BOOL)hasAccount
{
    if( self.accounts == nil )
        [self requestAccessUsingBlock:nil];
    
    return [accounts count] > 0;        
}

- (BOOL)hasMultipleAccounts
{
    if( self.accounts == nil )
        [self requestAccessUsingBlock:nil];
    
    return [accounts count] > 1;    
}

- (NSArray *)accounts
{
    if( !accounts )
        [self requestAccessUsingBlock:nil];
    return accounts;
}

- (ACAccount *)selectedAccount
{
    if( !selectedAccount && self.accounts && [self.accounts count] > 0 )
        self.selectedAccount = [self.accounts objectAtIndex:0];
    
    return selectedAccount;
}

@end
