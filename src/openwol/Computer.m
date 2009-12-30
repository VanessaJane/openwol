// 
//  Computer.m
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Computer.h"


@implementation Computer 
@synthesize delegate = _delegate;
@synthesize hostIPAddress = _hostIPAddress;

@dynamic lastWakeupTime;
@dynamic port;
@dynamic mac;
@dynamic overInternet;
@dynamic mask;
@dynamic host;
@dynamic name;


- (void)updated
{
	if (_delegate != nil && [_delegate conformsToProtocol:@protocol(ComputerDelegate)]) {
		[_delegate computerUpdated:self];
	}
}

- (void)dealloc
{
	[_hostIPAddress release];
	[_delegate release];
	[super dealloc];
}

@end
