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
- (void)updateUI;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
@end

@implementation ViewController

@synthesize twitterManager;
@synthesize hasAccountLabel, hasMultipleAccountsLabel, accountsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a twitter manager
    twitterManager = [[TwitterManager alloc] init];
    twitterManager.delegate = self;
    
    [self updateUI];
}

- (void)updateUI 
{
    if( self.twitterManager.accessGranted )
    {
        // Has Account
        self.hasAccountLabel.text = [NSString stringWithFormat:@"Has Account: %@", [twitterManager hasAccount] ? @"YES" : @"NO"];
        
        // Has Multiple Accounts
        self.hasMultipleAccountsLabel.text = [NSString stringWithFormat:@"Has Multiple Accounts: %@", [twitterManager hasMultipleAccounts] ? @"YES" : @"NO"];    
        
        // Accounts
        NSString *accountsString = @"Accounts: \n";
        for(ACAccount *account in [twitterManager accounts]) {
            accountsString = [accountsString stringByAppendingFormat:@"%@ \n", [account accountDescription]];
        }
        self.accountsLabel.text = accountsString;            
                
        [self.view setNeedsDisplay];
    }
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

- (IBAction)requestAccess:(id)sender
{
    NSLog(@"requestAccess:");
    [self.twitterManager requestAccess];
}

- (IBAction)createTweet:(id)sender
{
    NSLog(@"createTweet:");
    
}

- (IBAction)followAppStore:(id)sender
{
    NSLog(@"followAppStore:");    
    [self.twitterManager followUser:@"AppStore"];
}

- (IBAction)unfollowAppStore:(id)sender
{
    NSLog(@"unfollowAppStore:"); 
    [self.twitterManager unfollowUser:@"AppStore"];   
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - TwitterManagerDelegate methods

- (void)accessGranted
{
    NSLog(@"accessGranted");
    [self updateUI];
}

- (void)accessDenied 
{
    NSLog(@"accessDenied");
    [self updateUI];    
}

- (void)followUserDidSucceed
{
    NSLog(@"followUserDidSucceed");
    [self showAlertWithTitle:@"Follow" andMessage:@"Success!"];        
}

- (void)followUserDidFailWithError:(NSError *)error
{
    NSLog(@"followUserDidFailWithError: %@", [error localizedDescription]);    
    [self showAlertWithTitle:@"Follow Failed" andMessage:[error localizedDescription]];
}

- (void)unfollowUserDidSucceed
{
    NSLog(@"unfollowUserDidSucceed");
    [self showAlertWithTitle:@"Unfollow" andMessage:@"Success!"];    
}

- (void)unfollowUserDidFailWithError:(NSError *)error
{
    NSLog(@"unfollowUserDidFailWithError: %@", [error localizedDescription]);
    [self showAlertWithTitle:@"Unfollow Failed" andMessage:[error localizedDescription]];
}

- (void)isFollowingUser:(NSString *)username result:(BOOL)result
{
    NSLog(@"isFollowingUser:'%@' result:%@", username, result ? @"YES" : @"NO");    
}

- (void)isFollowingUserDidFailWithError:(NSError *)error
{
    [self showAlertWithTitle:@"Is Following? Failed" andMessage:[error localizedDescription]];    
}

@end
