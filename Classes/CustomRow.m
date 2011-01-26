//
//  CustomRow.m
//  ChatApplication
//
//  Created by Chris Roebuck on 26/01/2011.
//  Copyright 2011 cjroebuck.com. All rights reserved.
//

#import "CustomRow.h"


@implementation CustomRow
@synthesize userNameLabel;
@synthesize dateLabel;
@synthesize msgContentLabel;
@synthesize msgTypeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
	[userNameLabel release];
	[dateLabel release];
	[msgContentLabel release];
	[msgTypeLabel release];
    [super dealloc];
}

@end
