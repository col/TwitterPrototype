//
//  TwitterFollowButton.h
//  TwitterPrototype
//
//  Created by Colin Harris on 17/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterManager.h"

@interface TwitterFollowButton : UIButton

@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) TwitterManager *twitterManager;
@property (nonatomic, retain) NSString *username;

@end
