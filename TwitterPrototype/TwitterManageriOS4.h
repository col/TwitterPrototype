//
//  TwitterManageriOS4.h
//  TwitterPrototype
//
//  Created by Colin Harris on 18/04/12.
//  Copyright (c) 2012 Lambda Software. All rights reserved.
//

#import "TwitterManager.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface TwitterManageriOS4 : TwitterManager <SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate>
{
    BOOL accessGranted;
}

@property (nonatomic, assign) BOOL accessGranted;

@end
