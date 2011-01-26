//
//  Message.m
//  ChatApplication
//
//  Created by Chris Roebuck on 26/01/2011.
//  Copyright 2011 cjroebuck.com. All rights reserved.
//

#import "Message.h"


@implementation Message
@synthesize nick;
@synthesize type;
@synthesize timestamp;
@synthesize text;

-(id)initWithNick:(NSString *)_nick type:(NSString *)_type text:(NSString *)_text timestamp:(NSDate *)_timestamp
{
	self = [super init];
	if(self != nil){
		self.nick = _nick;
		self.type = _type;
		self.timestamp = _timestamp;
		self.text = _text;
	}
	return (self);
}

@end
