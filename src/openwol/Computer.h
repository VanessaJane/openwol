//
//  Computer.h
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ComputerDelegate.h"

@interface Computer :  NSManagedObject  
{
	id _delegate;
	NSString* _hostIPAddress;
}

- (void)updated;

@property (nonatomic, retain) id delegate;
@property (nonatomic, readonly) NSString* hostIPAddress;

@property (nonatomic, retain) NSDate * lastWakeupTime;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSString * mac;
@property (nonatomic, retain) NSNumber * overInternet;
@property (nonatomic, retain) NSString * mask;
@property (nonatomic, retain) NSString * host;
@property (nonatomic, retain) NSString * name;

@end



