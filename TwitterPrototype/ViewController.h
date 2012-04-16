//
//  ViewController.h
//  TwitterPrototype
//
//  Created by Colin Harris on 16/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterManager.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *hasAccountLabel;
@property (nonatomic, retain) IBOutlet UILabel *hasMultipleAccountsLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountsLabel;

@property (nonatomic, retain) IBOutlet UIButton *followToggleButton;

- (IBAction)requestAccess:(id)sender;

- (IBAction)createTweet:(id)sender;
- (IBAction)followAppStore:(id)sender;
- (IBAction)unfollowAppStore:(id)sender;

@property (nonatomic, retain) TwitterManager *twitterManager;

@end
