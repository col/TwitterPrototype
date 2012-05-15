//
//  TwitterFollowButton.m
//  TwitterPrototype
//
//  Created by Colin Harris on 17/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "TwitterFollowButton.h"

@interface TwitterFollowButton ()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
- (void)showActivity;
- (void)hideActivityWithTitle:(NSString *)title;
@end

NSString * const Follow = @"Follow";
NSString * const Unfollow = @"Unfollow";

@implementation TwitterFollowButton

@synthesize twitterManager, username;
@synthesize activityIndicator;
@synthesize viewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (void)configureButton
{
    // Background
    UIImage *bgImage = [[UIImage imageNamed:@"btn-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    // Selected Background
    UIImage *selectedBgImage = [[UIImage imageNamed:@"btn-bg-selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self setBackgroundImage:selectedBgImage forState:UIControlStateHighlighted];    
    
    // Twitter Image
    [self setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    
    // Activity Indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20, 20);
    [self addSubview:activityIndicator];
    
    // Button Actions
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUsername:(NSString *)aUsername
{
    username = [aUsername retain];
    
    // If we already have access granted, check if the user is already following.
    if( self.twitterManager.accessGranted )
    {
//        [self showActivity];
        [self.twitterManager isFollowing:username usingBlock:^(BOOL following) {
            [self hideActivityWithTitle:following ? Unfollow : Follow];
        }];
    }
}

- (void)showActivity
{
    // TODO: can probably do better than this hack to layout the button!
    [self setTitle:@"            " forState:UIControlStateNormal];
    [self.activityIndicator startAnimating];    
}

- (void)hideActivityWithTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self.activityIndicator stopAnimating];    
}

- (void)buttonClicked:(id)sender
{
    NSString *title = [self titleForState:UIControlStateNormal];
    if( [title isEqualToString:Follow] ) 
    {   
        [self.twitterManager requestAccessFromController:self.viewController usingBlock:^(BOOL success) {
            if( success ) {
                [self showActivity];        
                [self.twitterManager followUser:self.username usingBlock:^(BOOL success) {
                    [self hideActivityWithTitle:success ? Unfollow : Follow];
                }];            
            }
        }];
    }
    else if( [title isEqualToString:Unfollow] ) 
    {
        [self.twitterManager requestAccessFromController:self.viewController usingBlock:^(BOOL success) {
            if( success ) {
                [self showActivity];        
                [self.twitterManager unfollowUser:self.username usingBlock:^(BOOL success) {
                    [self hideActivityWithTitle:success ? Follow : Unfollow];
                }];        
            }
        }];
    }
}

@end
