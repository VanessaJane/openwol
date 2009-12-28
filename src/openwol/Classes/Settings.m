//
//  Settings.m
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "Settings.h"
#import "RegexKitLite.h"

const NSString* SAVED_PATTERN = @"^(.+)::(.+)::(.*)::(.*)::(\\d+)$";


@implementation Settings
@synthesize Mac = _mac;
@synthesize Port = _port;
@synthesize SubNet = _subNet;
@synthesize Host = _host;
@synthesize OverInternet = _overInternet;

- (BOOL)load{
	NSString* fileName = [@"~/Documents/settings.txt" stringByExpandingTildeInPath];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:fileName])
	{
		NSString* settings = [NSString stringWithContentsOfFile:fileName
													encoding:NSUTF8StringEncoding
														  error:nil];
		NSArray* parts = [settings captureComponentsMatchedByRegex:(NSString *)SAVED_PATTERN];
	
		if ([parts count] != 6) {
			return NO;
		}
		
		self.Mac = [parts objectAtIndex:1];
		self.Port = [parts objectAtIndex:2];
		self.SubNet = [parts objectAtIndex:3];
		self.Host = [parts objectAtIndex:4];
		self.OverInternet = [[parts objectAtIndex:5] intValue];
	
		return YES;
	}
	else {
		return NO;
	}

}

- (BOOL)save{
	NSString* settings = [NSString
								 stringWithFormat:@"%@::%@::%@::%@::%d",
						  self.Mac,
						  self.Port,
						  self.SubNet,
						  self.Host,
						  self.OverInternet];
	
	NSString* fileName = [@"~/Documents/settings.txt" stringByExpandingTildeInPath];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:fileName])
	{
		NSError* error = [[NSError alloc] init];
		if(![fm removeItemAtPath:fileName error:&error])
		{
			[error release];
			
			return NO;
		}
	}
	
	
	[fm createFileAtPath:fileName
				contents:[settings dataUsingEncoding:NSUTF8StringEncoding]
			  attributes:nil];
	
	return YES;
}

-(void) dealloc
{
	[_mac release];
	[_port release];
	[_subNet release];
	[_host release];
	[super dealloc];
}

@end
