//
//  ChatApplicationAppDelegate.h
//  ChatApplication
//
//  Created by Ankur Gurha on 22/01/2011.
//  Copyright 2011 Credit-Suisse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatApplicationViewController;

@interface ChatApplicationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end

