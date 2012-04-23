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

    // Create a twitter manager
    // If on iOS <= 4.3 this will return TwitterManageriOS4
    // If on iOS >= 5.0 this will return TwitterManageriOS5
    twitterManager = [TwitterManager twitterManager];          
        
    self.followToggleButton.twitterManager = twitterManager;    
    [self updateUI];
}

- (void)updateUI 
{
    if( self.twitterManager.accessGranted )
    {                                           
        // Follow / Unfollow Button
        self.followToggleButton.hidden = NO;        
        self.followToggleButton.username = @"AppStore";        
        
        [self.view setNeedsDisplay];
    }
    else 
    {        
        // Hide Button
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
    [self.twitterManager requestAccessFromController:self usingBlock:^(BOOL granted) {
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];       
    }];
}

- (IBAction)createTweet:(id)sender
{
    NSLog(@"createTweet:");
    
}

@end
