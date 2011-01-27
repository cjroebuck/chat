//
//  ChatRoomViewController.m
//  ChatApplication
//
//  Created by Ankur Gurha on 22/01/2011.
//  Copyright 2011 Credit-Suisse. All rights reserved.
//

#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... ) 
#endif

#import "ChatRoomViewController.h"
#import <YAJL/YAJL.h>
#import "ASIHTTPRequest.h"
#import "CustomRow.h"
#import "Message.h"

@implementation ChatRoomViewController
@synthesize user;
@synthesize messageText;
@synthesize messageView;
@synthesize messages;


-(void) longPoll:(NSString *)data
{	
	if(data != nil){
		if(self.messages == nil){
			self.messages = [[NSMutableArray alloc]init];
		}
		NSDictionary *payload = [data yajl_JSON];
		NSLog(@"payload = %@",payload);
		NSArray* msgs = [payload valueForKey:@"messages"];
		
		NSLog(@"num messages = %d",[msgs count]);
		
		for (id message in msgs) {
			
			NSTimeInterval seconds = [[message objectForKey:@"timestamp"]doubleValue]/1000;
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
			Message *msg = [[Message alloc] initWithNick:[message objectForKey:@"nick"]
													type:[message objectForKey:@"type"]
													text:[message objectForKey:@"text"]
											   timestamp:date];
			
			[self.messages addObject:msg];
			
			[msg release];
			
			if (date > user.last_message_time) {
				user.last_message_time = date;
			}
		}
		[messageView reloadData];
		NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
		[messageView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	
	long long date = [user.last_message_time timeIntervalSince1970] * 1000;
	NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:8001/recv?since=%qi&id=%@",date,user.user_id];
	NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:60.0];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        int statusCode = [request responseStatusCode];
        if (statusCode != 200) {
            NSLog(@"Request failed with status code %d", statusCode);
        } 
        else {   
            // We received data, the connection is now closed, so we need to begin a new request.
            [self longPoll:responseString];
        }    
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
		NSLog(@"Failed with error: %@", error);
		
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Something went wrong.. :(" 
													   message:[error localizedDescription]
													  delegate:nil
											 cancelButtonTitle:@"Try again.."
											 otherButtonTitles:nil];
		[alert show];
		[alert release];

        // Something went wrong.. move back to the login screen
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [request startAsynchronous];
}

-(IBAction)sendMessage
{
	NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:8001/send?id=%@&text=%@",user.user_id,self.messageText.text];
	NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:60.0];
    [request setDelegate:self];
    [request setCompletionBlock:^{
		NSString *responseString = [request responseString];
        int statusCode = [request responseStatusCode];
        if (statusCode != 200) {
            NSLog(@"Request failed with status code %d", statusCode);
        } 
        else { 
			NSLog(@"Send Message Request sent, response: %@", responseString);
        }    
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
		NSLog(@"Failed with error: %@", error);
		
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Something went wrong.. :(" 
													   message:[error localizedDescription]
													  delegate:nil
											 cancelButtonTitle:@"Try again.."
											 otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		// Something went wrong.. move back to the login screen?
		[self.navigationController popViewControllerAnimated:YES];
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark Table View Data Source Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(self.messages != nil)
		return [self.messages count];
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *MyIdentifier = @"CustomRowIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    CustomRow *cell = (CustomRow *)[messageView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomRow"
													 owner:self options:nil];
		for (id element in nib) 
		{
			if ([element isKindOfClass:[CustomRow class]])
			{
				cell = (CustomRow *)element;
			}
		}
    }
    
    // Set up the cell.
	NSUInteger row = [indexPath row];
	Message *message = [self.messages objectAtIndex:row];
	cell.userNameLabel.text = message.nick;
	cell.msgTypeLabel.text = message.type;
	cell.msgContentLabel.text = message.text;
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	cell.dateLabel.text = [timeFormat stringFromDate:message.timestamp];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	return kTableViewRowHeight;
}

#pragma mark -
#pragma mark Lifetime Callbacks

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Start Long Poll
	[self longPoll:nil];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.user = nil;
	self.messageText = nil;
	self.messageView = nil;
	self.messages = nil;
}

- (void)dealloc {
    [user release];
	[messageText release];
	[messageView release];
	[messages release];
	[super dealloc];
	
}

@end
