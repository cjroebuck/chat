//
//  CustomRow.h
//  ChatApplication
//
//  Created by Chris Roebuck on 26/01/2011.
//  Copyright 2011 cjroebuck.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomRow : UITableViewCell {
	UILabel *userNameLabel;
	UILabel *dateLabel;
	UILabel *msgContentLabel;
	UILabel *msgTypeLabel;
@private
    
}

@property (nonatomic,retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *msgContentLabel;
@property (nonatomic, retain) IBOutlet UILabel *msgTypeLabel;

@end
