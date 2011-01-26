//
//  User.m
//  ChatApplication
//
//  Created by Chris Roebuck on 23/01/2011.
//  Copyright 2011 cjroebuck.com. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize nick;
@synthesize user_id;
@synthesize last_message_time;

/*-(id)init
{
	self=[super init];
	if(self != nil){
		self.nick = @"";
		self.user_id = @"";
	}
	return (self);
}*/

-(id) initWithNick:(NSString *)nickname andId:(NSString *)nicksId
{
	self = [super init];
	if(self != nil){
		self.nick = nickname;
		self.user_id = nicksId;
		self.last_message_time = [NSDate dateWithTimeIntervalSince1970:1];
	}
	return (self);
}

@end
