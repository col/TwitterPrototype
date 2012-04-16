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
@end

@implementation ViewController

@synthesize twitterManager;
@synthesize hasAccountLabel, hasMultipleAccountsLabel, accountsLabel;
@synthesize followToggleButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a twitter manager
    twitterManager = [[TwitterManager alloc] init];
    
    [self updateUI];
}

- (void)updateUI 
{
    if( self.twitterManager.accessGranted )
    {
        // Show Labels
        self.hasAccountLabel.hidden = self.hasMultipleAccountsLabel.hidden = self.accountsLabel.hidden = NO;
        
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
        
        // Follow / Unfollow Button
        self.followToggleButton.hidden = YES;
        UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        spinner.frame = self.followToggleButton.frame;
        [spinner startAnimating];
        [self.view addSubview:spinner];
        [self.twitterManager isFollowing:@"AppStore" usingBlock:^(BOOL following) {
            if( following ) {
                [self.followToggleButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                [self.followToggleButton removeTarget:self action:@selector(followAppStore:) forControlEvents:UIControlEventTouchUpInside];
                [self.followToggleButton addTarget:self action:@selector(unfollowAppStore:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.followToggleButton setTitle:@"Follow" forState:UIControlStateNormal];                
                [self.followToggleButton removeTarget:self action:@selector(unfollowAppStore:) forControlEvents:UIControlEventTouchUpInside];                
                [self.followToggleButton addTarget:self action:@selector(followAppStore:) forControlEvents:UIControlEventTouchUpInside];                
            }
            self.followToggleButton.hidden = NO;
            [spinner removeFromSuperview];
        }];
        
        
        [self.view setNeedsDisplay];
    }
    else 
    {
        // Hide Labels
        self.hasAccountLabel.hidden = self.hasMultipleAccountsLabel.hidden = self.accountsLabel.hidden = YES;
        
        // Hide Buttons
        self.followToggleButton.hidden = YES;
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
    [self.twitterManager requestAccessUsingBlock:^(BOOL granted) {
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];       
    }];
}

- (IBAction)createTweet:(id)sender
{
    NSLog(@"createTweet:");
    
}

- (IBAction)followAppStore:(id)sender
{
    NSLog(@"followAppStore:");    
    [self.twitterManager followUser:@"AppStore" usingBlock:^(BOOL success) {
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    }];
}

- (IBAction)unfollowAppStore:(id)sender
{
    NSLog(@"unfollowAppStore:"); 
    [self.twitterManager unfollowUser:@"AppStore" usingBlock:^(BOOL success) {    
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];        
    }];
}

@end
