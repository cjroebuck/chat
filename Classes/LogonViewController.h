//
//  ChatApplicationViewController.h
//  ChatApplication
//
//  Created by Ankur Gurha on 22/01/2011.
//  Copyright 2011 Credit-Suisse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogonViewController : UIViewController {
	UITextField *userName;
}

@property (nonatomic,retain) IBOutlet UITextField *userName;
-(IBAction) buttonPress;
-(void)sendJoinRequest;
@end

