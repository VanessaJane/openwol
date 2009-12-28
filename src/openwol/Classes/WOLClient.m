//
//  WOLClient.m
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#include <sys/types.h>
#include <stdlib.h>
#include <limits.h>
#import "WOLClient.h"
#import "RegexKitLite.h"

#import <unistd.h>
#import <stdlib.h>

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

#define BOARDCAST_ADDR "255.255.255.255"

@implementation WOLClient
@synthesize Mac = _mac;
@synthesize Port = _port;
@synthesize SubNet = _subNet;
@synthesize Host = _host;

const NSString* IP_PATTERN = @"^\\s*(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\s*$";
const NSString* MAC_PATTERN = @"^\\s*([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})\\s*$";
const int HEADER = 6;
const int MAC_BYTES_LEN = 6;
const int MAC_TIMES = 16;

- (BOOL)checkPort
{
	return [_port intValue] > 0 && [_port intValue] <= 65535;
}

-(BOOL)checkHost
{
	NSArray* ipParts =
		[_host captureComponentsMatchedByRegex:(NSString*)IP_PATTERN];
	
	return (5 == [ipParts count]);
}

-(BOOL)checkSubnetMask
{
	NSArray* ipParts =
	[_subNet captureComponentsMatchedByRegex:(NSString*)IP_PATTERN];
	
	return (5 == [ipParts count]);
	
}

-(BOOL)checkMACFormat
{
	NSArray* macParts =
		[_mac captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	
	return (7 == [macParts count]);
}

-(void) wakeUp:(BOOL)overInternet
{
	if (overInternet) {
		[self wakeUpWan];
	}else {
		[self wakeUpLan];
	}

}

-(NSData*) buildPayload{
	
	void* bytes = malloc(HEADER);
	
	memset(bytes, 0xFF, HEADER);
	
	NSMutableData* buffer = [[NSMutableData alloc]
					  initWithBytesNoCopy:bytes
							length:HEADER
					  freeWhenDone:YES];
	
	NSData* macData = [self parseMAC];
	
	for (int i = 0; i < MAC_TIMES; i++) {
		[buffer appendData:macData];
	}
	
	return [buffer autorelease];
}

-(struct sockaddr_in*) getTargetAddr
{
	struct sockaddr_in* pRemoteIP = malloc(sizeof(struct sockaddr_in));
	bzero(pRemoteIP, sizeof(struct sockaddr_in));
	pRemoteIP->sin_family = AF_INET;
	pRemoteIP->sin_port = htons([_port intValue]);
	
	NSArray* hostParts
		= [_host captureComponentsMatchedByRegex:(NSString *)IP_PATTERN];
	
	if ([hostParts count] != 5) {
		return nil;
	}
	
	NSArray* maskParts
		= [_subNet captureComponentsMatchedByRegex:(NSString *)IP_PATTERN];
	
	if ([maskParts count] != 5) {
		return nil;
	}
	
	NSMutableString* ipAddressString
		= [[NSMutableString alloc] initWithCapacity:16];
	
	uint8_t* remote = malloc([hostParts count] - 1);
	
	for (int i = 1; i < [hostParts count]; i++) {
		remote[i - 1] = ((uint8_t)[[hostParts objectAtIndex:i] intValue])
		| ~((uint8_t)[[maskParts objectAtIndex:i] intValue]);
	}
	
	
	[ipAddressString appendFormat:@"%d.%d.%d.%d",
		remote[0],
		remote[1],
		remote[2],
		remote[3]];
	
	free(remote);
	
	int addrBufferSize = [ipAddressString length] + 1;
	char* pAddressBuffer = malloc(addrBufferSize);
	bzero(pAddressBuffer, addrBufferSize);
	[ipAddressString getCString:pAddressBuffer
					  maxLength:addrBufferSize
					   encoding:NSASCIIStringEncoding];
	
	inet_pton(AF_INET,
			  pAddressBuffer,
			  &(pRemoteIP->sin_addr.s_addr));
	
	
	[ipAddressString release];
	free(pAddressBuffer);
	return pRemoteIP;
}

-(int) createUdpClient
{
	int udpClient = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	
	struct sockaddr_in localAddr;
	localAddr.sin_family = AF_INET;
	localAddr.sin_port = htons([_port intValue]);
	localAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	
	bind(udpClient, (struct sockaddr*)&localAddr, sizeof(localAddr));
	
	return udpClient;
}

-(void) wakeUpWan
{
	struct sockaddr_in* remoteAddr = [self getTargetAddr];
	int udpClient = [self createUdpClient];
	NSData* payload = [self buildPayload];
	
	sendto(udpClient,
		   [payload bytes],
		   [payload length],
		   0,
		   (struct sockaddr*)remoteAddr,
		   sizeof(struct sockaddr_in));
	
	free(remoteAddr);
}

-(void) wakeUpLan
{
	struct ip_mreq mreq;
	bzero(&mreq, sizeof(struct ip_mreq));
	inet_pton(AF_INET, BOARDCAST_ADDR, &mreq.imr_multiaddr.s_addr);
	mreq.imr_interface.s_addr = htonl(INADDR_ANY);
	
	int udpClient = [self createUdpClient];
	
	setsockopt(udpClient,
			   IPPROTO_IP,
			   IP_ADD_MEMBERSHIP,
			   &mreq,
			   sizeof(mreq));
	u_char ttl = 2;	
	setsockopt(udpClient, IPPROTO_IP, IP_MULTICAST_TTL, &ttl, sizeof(ttl));
	
	u_char loopBack = NO;
	setsockopt(udpClient, IPPROTO_IP, IP_MULTICAST_LOOP, &loopBack, sizeof(loopBack));
	
	NSData* payload = [self buildPayload];
	
	struct sockaddr_in mcAddress;
	mcAddress.sin_family = AF_INET;
	inet_pton(AF_INET, BOARDCAST_ADDR, &mcAddress.sin_addr.s_addr);
	
	mcAddress.sin_port = htons([_port intValue]);
	
	sendto(udpClient,
		   [payload bytes],
		   [payload length],
		   0,
		   (struct sockaddr*)&mcAddress,
		   sizeof(struct sockaddr_in));
	
	
	close(udpClient);
}

-(NSData*) parseMAC
{
	NSArray* macParts =
		[_mac captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	
	if (nil == macParts) {
		return nil;
	}
	
	void* buffer = malloc(MAC_BYTES_LEN);
	
	char * pMacPart = malloc(3);
	bzero(pMacPart, 3);
	for (int i = 0; i < [macParts count] - 1; i++) {
		NSString* part = [macParts objectAtIndex:i + 1];
		
		if([part getCString:pMacPart maxLength:3 encoding:NSASCIIStringEncoding])
		{
			memset(buffer + i, strtol(pMacPart, (char **)NULL, 16), 1);
		}
	}
	
	free(pMacPart);
	
	return [NSData dataWithBytesNoCopy:buffer
								length:MAC_BYTES_LEN
						  freeWhenDone:YES];
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
