//
//  User.h
//  ChatApplication
//
//  Created by Chris Roebuck on 23/01/2011.
//  Copyright 2011 cjroebuck.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString *nick;
	NSString *user_id;
	NSDate *last_message_time;
}

@property(nonatomic,retain) NSString *nick;
@property(nonatomic,retain) NSString *user_id;
@property(nonatomic, retain) NSDate *last_message_time;

/*-(id) init;*/
-(id) initWithNick:(NSString *)nick andId:(NSString *)nicksId;


@end
