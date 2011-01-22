//
//  ChatApplicationViewController.m
//  ChatApplication
//
//  Created by Ankur Gurha on 22/01/2011.
//  Copyright 2011 Credit-Suisse. All rights reserved.
//

#import "ChatApplicationViewController.h"
#import "ChatRoomViewController.h";
#import "JSON.h";

@implementation ChatApplicationViewController

@synthesize userName;
NSURLConnection *theConnection;
NSMutableData *_data;
NSInteger _statusCode;

-(IBAction) buttonPress
{
	//NSLog(@"userName : %@", userName.text);
	ChatRoomViewController *chatRoomViewController = [[ChatRoomViewController alloc] initWithNibName:@"ChatRoomViewController" 
																							  bundle:nil];
	
	
	
	[self createConnection];
	
	
	[self.navigationController pushViewController:chatRoomViewController animated:YES];
	[chatRoomViewController release];
}


-(void) createConnection
{
	NSString *urlString = [NSString stringWithFormat:@"http://127.0.0.1:8001/join?nick=%@", userName.text];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url 
												cachePolicy:NSURLRequestUseProtocolCachePolicy 
											timeoutInterval:60.0];
	
	//[urlString release];
	//[url release];
	
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

#pragma mark -
#pragma mark NSConnection Callbacks

- (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
{
	[_data appendData: data];
}

- (void)connection: (NSURLConnection*) connection didReceiveResponse: (NSHTTPURLResponse*) response
{
	_statusCode = [response statusCode];
}

- (void) connection: (NSURLConnection*) connection didFailWithError: (NSError*) error
{
	//[_delegate twitterRequest: self didFailWithError: error];
	
	[theConnection release];
	theConnection = nil;
	
	[_data release];
	_data = nil;
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection
{
	
	if (_statusCode != 200) {
		NSLog(@"Request failed with status code %d", _statusCode);
		NSString* response = [[[NSString alloc] initWithData: _data encoding: NSUTF8StringEncoding] autorelease];
		NSLog(@"Response = %@", [response JSONValue]);
		// TODO: Real error handling
		//[_delegate twitterRequest: self didFailWithError: nil];
	} else {
		NSString* response = [[[NSString alloc] initWithData: _data encoding: NSUTF8StringEncoding] autorelease];
		NSLog(@"Response = %@", [response JSONValue]);

		NSLog(@"Data is %@", [_data description]);
		//[_delegate twitterRequest: self didFinishLoadingData: _data];
		
		
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		// parse the JSON response into an object
		// Here we're using NSArray since we're parsing an array of JSON status objects
		NSArray *statuses = [parser objectWithString:response error:nil];
		
		// Each element in statuses is a single status
		// represented as a NSDictionary
		for (NSDictionary *status in statuses)
		{
			// You can retrieve individual values using objectForKey on the status NSDictionary
			// This will print the tweet and username to the console
			NSLog(@"%@ - %@", [status objectForKey:@"nick"], [[status objectForKey:@"id"] objectForKey:@"rss"]);
		}
		
		
	}
	
	[theConnection release];
	theConnection = nil;
	
	[_data release];
	_data = nil;
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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	_data = [[NSMutableData data] retain];
	//_statusCode;
	
	
    [super viewDidLoad];
}



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
