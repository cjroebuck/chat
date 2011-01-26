//
//  Message.h
//  ChatApplication
//
//  Created by Chris Roebuck on 26/01/2011.
//  Copyright 2011 cjroebuck.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Message : NSObject {
	NSString *nick;
	NSString *type;
	NSString *text;
	NSDate *timestamp;
@private
    
}
@property(nonatomic,retain) NSString *nick;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *text;
@property(nonatomic,retain) NSDate *timestamp;

-(id)initWithNick:(NSString *)nick type:(NSString *)type text:(NSString *)text timestamp:(NSDate *)timestamp;
@end
