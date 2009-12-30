//
//  ComputerCell.m
//  openwol
//
//  Created by iceboundrock on 09-12-30.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "ComputerCell.h"
#import "Computer.h"

@implementation ComputerCell

- (void)computerUpdated:(Computer*)computer
{
	self.textLabel.text = computer.name;
	
	self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	if (computer.lastWakeupTime != nil) {
		NSDateFormatter* f = [[NSDateFormatter alloc] init];
		[f setDateStyle:NSDateFormatterMediumStyle];
		[f setTimeStyle:NSDateFormatterShortStyle];
		
		self.detailTextLabel.text = [NSString stringWithFormat:@"Last waked up at: %@",
									 [f stringFromDate:computer.lastWakeupTime]];
	}
	else {
		self.detailTextLabel.text = @"Never waked up before";
		
	}
	[self.textLabel sizeToFit];
	[self.detailTextLabel sizeToFit];
}

@end
