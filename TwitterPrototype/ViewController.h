//
//  ViewController.h
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterManager.h"
#import "TwitterFollowButton.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) TwitterManager *twitterManager;
@property (nonatomic, retain) IBOutlet TwitterFollowButton *followToggleButton;

// iOS 5 Only
@property (nonatomic, retain) IBOutlet UILabel *hasAccountLabel;
@property (nonatomic, retain) IBOutlet UILabel *hasMultipleAccountsLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountsLabel;


- (IBAction)requestAccess:(id)sender;
- (IBAction)createTweet:(id)sender;

@end
