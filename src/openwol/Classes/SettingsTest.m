//
//  SettingsTest.m
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "SettingsTest.h"
#import "Settings.h"

@implementation SettingsTest


- (void) testAppSettingsWan {
    NSString* mac = @"00-00-00-00-00-00";
	NSString* port = @"8";
	NSString* host = @"www.google.com";
	NSString* subNet = @"255.255.255.255";
	int wan = 0;
	Settings* save = [[Settings alloc] init];
	save.Mac = mac;
	save.Port = port;
	save.Host = host;
	save.SubNet = subNet;
	save.OverInternet = wan;
	STAssertTrue([save save], @"save failed.");
	
	[save release];
	
	Settings* load = [[Settings alloc] init];
	STAssertTrue([save load], @"load failed.");
	STAssertEquals(mac, load.Mac, @"Mac not equal");
	STAssertEquals(port, load.Port, @"Mac not equal");
	STAssertEquals(host, load.Host, @"Host not equal");
	STAssertEquals(subNet, load.SubNet, @"SubNet not equal");
	STAssertEquals(wan, load.OverInternet, @"OverInternet not equal");
	[load release];
}

- (void) testAppSettingsLan {
    NSString* mac = @"00-00-00-00-00-00";
	NSString* port = @"8";
	NSString* host = @"";
	NSString* subNet = @"";
	int wan = 1;
	Settings* save = [[Settings alloc] init];
	save.Mac = mac;
	save.Port = port;
	save.Host = host;
	save.SubNet = subNet;
	save.OverInternet = wan;
	STAssertTrue([save save], @"save failed.");
	
	[save release];
	
	Settings* load = [[Settings alloc] init];
	STAssertTrue([save load], @"load failed.");
	STAssertEquals(mac, load.Mac, @"Mac not equal");
	STAssertEquals(port, load.Port, @"Mac not equal");
	STAssertEquals(host, load.Host, @"Host not equal");
	STAssertEquals(subNet, load.SubNet, @"SubNet not equal");
	STAssertEquals(wan, load.OverInternet, @"OverInternet not equal");
	[load release];
}



@end
