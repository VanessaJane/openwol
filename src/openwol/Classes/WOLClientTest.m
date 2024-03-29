//
//  WOLClientTest.m
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "WOLClientTest.h"
#import "WOLClient.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <strings.h>
#import <netdb.h>
#import <net/if.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/select.h>
#import <sys/time.h>

#import "Computer.h"
#import "ComputerValidator.h"

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

- (void) setUp
{
	NSMutableSet *allBundles = [[NSMutableSet alloc] init];
	[allBundles addObjectsFromArray:[NSBundle allBundles]];
	//[allBundles addObjectsFromArray:[NSBundle allFrameworks]];
	
	managedObjectModel = [[NSManagedObjectModel
						   mergedModelFromBundles:[allBundles allObjects]] retain];
	[allBundles release];
	coodinator = [[NSPersistentStoreCoordinator alloc]
				  initWithManagedObjectModel:managedObjectModel];
	
	managedObjectContext = [[NSManagedObjectContext alloc] init];
	[managedObjectContext setPersistentStoreCoordinator:coodinator];
}

- (void) tearDown
{
	[managedObjectContext release];
	[coodinator release];
	[managedObjectModel release];
}

- (void) testCheckHost
{
	Computer *computer = (Computer*)[NSEntityDescription
									 insertNewObjectForEntityForName:@"Computer"
									 inManagedObjectContext:managedObjectContext];
	
	STAssertNotNil( computer, @"Created entity was nil" );
	
	computer.host = @"217.204.255.55";
	STAssertTrue([computer checkHost], @"check host error");
	
	computer.host = @"www.google.cn";
	STAssertTrue([computer checkHost], @"check host error");
	
	computer.host = @"a.b.c.d";
	STAssertTrue(![computer checkHost], @"check host error");
	
}

- (void) testGetTargetAddr
{
	Computer *computer = [NSEntityDescription
						  insertNewObjectForEntityForName:@"Computer"
						  inManagedObjectContext:managedObjectContext];
	
	computer.host = @"217.204.255.55";
	computer.mask = @"255.255.255.240";
	
	struct sockaddr_in* sock = [computer getTargetAddr];
	
	STAssertTrue(strcmp("217.204.255.63", inet_ntoa(sock->sin_addr)) == 0, @"Address error.");
	
	free(sock);
}

- (void) testBuildPayLoad
{
	WOLClient* client = [[WOLClient alloc] init];
	Computer *computer = [NSEntityDescription
						  insertNewObjectForEntityForName:@"Computer"
						  inManagedObjectContext:managedObjectContext];
	
	client.computer = computer;
	computer.mac = @"00-00-00-00-00-00";
    
	NSData* payload = [client buildPayload];
	
	STAssertTrue([payload length] == 102, @"Payload length error.");
	
	const uint8_t* bytes = [payload bytes];
	for (int i = 0; i < 6; i++) {
		STAssertTrue( bytes[i] == 0xFF, @"Payload header error");
	}
	
	for (int i = 6; i < [payload length]; i++) {
		STAssertTrue( bytes[i] == 0, @"Payload content error");
	}
	[client release];
}

- (void) testParseMAC {
	WOLClient* client = [[WOLClient alloc] init];
	Computer *computer = [NSEntityDescription
						  insertNewObjectForEntityForName:@"Computer"
						  inManagedObjectContext:managedObjectContext];
	client.computer = computer;
	computer.mac = @"00-00-00-00-00-00";
    
	NSData* macData = [client parseMAC];
	STAssertTrue([macData length] == 6, @"MAC data length error.");
	
	const uint8_t* bytes = [macData bytes];
	
	for (int i = 0; i < [macData length]; i++) {
		STAssertTrue(bytes[i] == 0, @"MAC data parse error.");
	}
	computer.mac = @"FF-FF-FF-FF-FF-FF";
    macData = [client parseMAC];
	STAssertTrue([macData length] == 6, @"MAC data length error.");
	
	bytes = [macData bytes];
	for (int i = 0; i < [macData length]; i++) {
		STAssertTrue(bytes[i] == 0xFF, @"MAC data parse error.");
	}
	
	computer.mac = @"AF-AF-AF-AF-AF-AF";
    macData = [client parseMAC];
	STAssertTrue([macData length] == 6, @"MAC data length error.");
	
	
	bytes = [macData bytes];
	for (int i = 0; i < [macData length]; i++) {
		STAssertTrue(bytes[i] == 0xAF, @"MAC data parse error.");
	}
	
	[client release];
}
#else // all code under test must be linked into the Unit Test bundle

#endif


@end
