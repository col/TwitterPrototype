//
//  ViewController.m
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "ViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Twitter Actions

- (IBAction)createTweet:(id)sender
{
    NSLog(@"createTweet:");
    
}

- (IBAction)followAppStore:(id)sender
{
    NSLog(@"followAppStore:");    
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        NSLog(@"Granted = %@", granted ? @"YES" : @"NO");
        NSLog(@"Error = %@", [error localizedDescription]);
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"AppStore" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.json"] 
                                                             parameters:tempDict 
                                                          requestMethod:TWRequestMethodPOST];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output); 
                    NSLog(@"Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
                    NSLog(@"Error = %@", [error localizedDescription]);                     
                    NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);                    
                }];
            }
        }
    }];
}

- (IBAction)unfollowAppStore:(id)sender
{
    NSLog(@"unfollowAppStore:"); 
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        NSLog(@"Granted = %@", granted ? @"YES" : @"NO");
        NSLog(@"Error = %@", [error localizedDescription]);
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"AppStore" forKey:@"screen_name"];
                [tempDict setValue:@"false" forKey:@"follow"];
                
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friendships/destroy.json"] 
                                                             parameters:tempDict 
                                                          requestMethod:TWRequestMethodPOST];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output); 
                    NSLog(@"Status = %@", [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
                    NSLog(@"Error = %@", [error localizedDescription]);                     
                    NSLog(@"Response Data String = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);                    
                }];
            }
        }
    }];    
}


@end
