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
	[self.textLabel sizeToFit];
	self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	if (computer.lastWakeupTime != nil) {
		NSDateFormatter* f = [[NSDateFormatter alloc] init];
		[f setDateStyle:NSDateFormatterFullStyle];
		[f setTimeStyle:NSDateFormatterFullStyle];
		
		self.detailTextLabel.text = [f stringFromDate:computer.lastWakeupTime];
	}
	else {
		self.detailTextLabel.text = @"Never waked up before";
		
	}
	[self autoresizesSubviews];
}

@end
