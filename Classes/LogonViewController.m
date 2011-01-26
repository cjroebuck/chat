//
//  ChatApplicationViewController.m
//  ChatApplication
//
//  Created by Ankur Gurha on 22/01/2011.
//  Copyright 2011 Credit-Suisse. All rights reserved.
//

#define DEBUG_MODE

#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... ) 
#endif

#import "LogonViewController.h"
#import "ChatRoomViewController.h"
#import "User.h"
#import "ASIHTTPRequest.h"

#import <YAJL/YAJL.h>

@implementation LogonViewController
@synthesize userName;

-(IBAction) buttonPress
{
	[self sendJoinRequest];	
}

- (void)sendJoinRequest
{
    NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:8001/join?nick=%@", userName.text];
	NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        
        // Get the JSON response and convert to dictionary:
        NSString *responseString = [request responseString];
        NSDictionary *payload = [responseString yajl_JSON];

        int statusCode = [request responseStatusCode];
        if (statusCode != 200) {
            
            NSLog(@"Request failed with status code %d", statusCode);
            NSLog(@"Response = %@", payload);
                        
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error Joining Room :(" 
                                        message:[payload valueForKey:@"error"]
                                       delegate:nil
                              cancelButtonTitle:@"Try again.."
                              otherButtonTitles:nil];
            [alert show];
            [alert release];
        } 
        else {
            
            DebugLog(@"payload = %@", payload);
            DebugLog(@"nick: %@", [payload valueForKey:@"nick"]);
            DebugLog(@"id: %@", [payload valueForKey:@"id"]);
            
            // Create the user
            User *aUser = [[User alloc] initWithNick:[payload valueForKey:@"nick"]
                                               andId:[payload valueForKey:@"id"]];
            
            NSTimeInterval seconds = [[payload objectForKey:@"starttime"]doubleValue]/1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
            
            aUser.last_message_time = date;
            NSLog(@"user: %@",aUser.nick);
            
            // Now switch to the chat room view
            ChatRoomViewController *chatRoomViewController = [[ChatRoomViewController alloc] initWithNibName:@"ChatRoomViewController" bundle:nil];
            chatRoomViewController.user = aUser;
            [self.navigationController pushViewController:chatRoomViewController animated:YES];
            
            // cleanup
            [chatRoomViewController release];
            [aUser release];
        }
    }];
    [request setFailedBlock:^{
        
        // Show an alert with the error to the user
        NSError *error = [request error];
        DebugLog(@"Failed with error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Connection Failed :(" 
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"Try again.."
                          otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];
    [request startAsynchronous];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.userName = nil;
	
}


- (void)dealloc {
	
	[userName release];
    [super dealloc];
}

@end
