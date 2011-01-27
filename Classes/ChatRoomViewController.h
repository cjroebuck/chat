//
//  ChatRoomViewController.h
//  ChatApplication
//
//  Created by Ankur Gurha on 22/01/2011.
//  Copyright 2011 Credit-Suisse. All rights reserved.
//
#define kTableViewRowHeight 66

#import <UIKit/UIKit.h>
#import "User.h"
@class ASIHTTPRequest;

@interface ChatRoomViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	User *user;
	UITextField *messageText;
	UITableView *messageView;
	@private
		BOOL firstPoll;
		NSMutableArray *messages;
}

@property(nonatomic,retain) User *user;
@property(nonatomic,retain) IBOutlet UITextField *messageText;
@property(nonatomic,retain) IBOutlet UITableView *messageView;
@property(nonatomic,retain) NSMutableArray *messages;
-(IBAction) sendMessage;
@end
