//
//  WOLClientTest.m
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "WOLClientTest.h"
#import "WOLClient.h"

@implementation WOLClientTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void) testBuildPayLoad2
{
	/*
	WOLClient* client = [[WOLClient alloc] init];
	client.Mac = @"00-90-27-A3-22-FE";
	
	NSData* payload = [client buildPayload];
	NSData* data = [NSData dataWithContentsOfFile:[@"/Users/iceboundrock/sample.dat"]];
	
	NSLog(@"payload: %d, sample: %d", [payload length], [data length]);
	
	
	STAssertTrue([payload length] == [data length], @"Payload length error.");
	const uint8_t* payloadBuf = [payload bytes];
	const uint8_t* sampleBuf = [data bytes];
	for (int i = 0; i < [payload length]; i++) {
		STAssertTrue(payloadBuf[i] == sampleBuf[i], @"content error.");
	}
	*/
	
}

- (void) testBuildPayLoad
{
	WOLClient* client = [[WOLClient alloc] init];
	client.Mac = @"00-00-00-00-00-00";
    
	NSData* payload = [client buildPayload];
	
	STAssertTrue([payload length] == 102, @"Payload length error.");
	
	const uint8_t* bytes = [payload bytes];
	for (int i = 0; i < 6; i++) {
		STAssertTrue( bytes[i] == 0xFF, @"Payload header error");
	}
	
	for (int i = 6; i < [payload length]; i++) {
		STAssertTrue( bytes[i] == 0, @"Payload content error");
	}
	
}

- (void) testParseMAC {
    
    WOLClient* client = [[WOLClient alloc] init];
	client.Mac = @"00-00-00-00-00-00";
    
	NSData* macData = [client parseMAC];
	STAssertTrue([macData length] == 6, @"MAC data length error.");
	
	const uint8_t* bytes = [macData bytes];
	
	for (int i = 0; i < [macData length]; i++) {
		STAssertTrue(bytes[i] == 0, @"MAC data parse error.");
	}
	client.Mac = @"FF-FF-FF-FF-FF-FF";
    macData = [client parseMAC];
	STAssertTrue([macData length] == 6, @"MAC data length error.");
	
	bytes = [macData bytes];
	for (int i = 0; i < [macData length]; i++) {
		STAssertTrue(bytes[i] == 0xFF, @"MAC data parse error.");
	}
	
	client.Mac = @"AF-AF-AF-AF-AF-AF";
    macData = [client parseMAC];
	STAssertTrue([macData length] == 6, @"MAC data length error.");
	
	
	bytes = [macData bytes];
	for (int i = 0; i < [macData length]; i++) {
		STAssertTrue(bytes[i] == 0xAF, @"MAC data parse error.");
	}
}
#else // all code under test must be linked into the Unit Test bundle

#endif


@end
