//
//  Settings.m
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "ComputerValidator.h"
#import "RegexKitLite.h"
#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#import "RegexPatterns.h"

@implementation Computer (ComputerValidator) 

-(BOOL)doValidator:(SEL)alertSelector target:(id)obj
{
	
	if (![self checkPort]) {
		[obj performSelector:alertSelector
				  withObject:@"Port should large than 0 and less than 65535."];
		return NO;
	}
	
	
	if (![self checkMACFormat]) {
		[obj performSelector:alertSelector
				  withObject:@"There is something wrong with MAC."];
		return NO;
	}
	
	if (self.overInternet) {
		
		if (![self checkHost]) {
			[obj performSelector:alertSelector
					  withObject:@"There is something wrong with Host."];
			
			return NO;
		}
		
		
		if (![self checkSubnetMask]) {
			[obj performSelector:alertSelector
					  withObject:@"There is something wrong with Subnet Mask."];
			
			return NO;
		}
	}
	return YES;
}

-(struct sockaddr_in*) getTargetAddr
{
	struct sockaddr_in* pRemoteIP = malloc(sizeof(struct sockaddr_in));
	bzero(pRemoteIP, sizeof(struct sockaddr_in));
	pRemoteIP->sin_family = AF_INET;
	pRemoteIP->sin_port = htons([self.port intValue]);
	
	NSArray* hostParts
	= [self.hostIPAddress captureComponentsMatchedByRegex:(NSString *)IP_PATTERN];
	
	
	NSArray* maskParts
	= [self.mask captureComponentsMatchedByRegex:(NSString *)IP_PATTERN];
	
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
	
	size_t addrBufferSize = [ipAddressString length] + 1;
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

- (BOOL)checkPort
{
	return [self.port intValue] > 0 && [self.port intValue] <= 65535;
}

-(BOOL)checkHost
{
	NSArray* ipParts =
	[self.host captureComponentsMatchedByRegex:(NSString*)IP_PATTERN];
	
	if (5 == [ipParts count]){
		_hostIPAddress = [self.host retain];
		return YES;
	}
	
	CFHostRef host = CFHostCreateWithName(NULL, (CFStringRef)self.host);
	
	CFStreamError err;
	bzero(&err, sizeof(CFStreamError));
	
	BOOL ret = NO;
	if(CFHostStartInfoResolution(host, kCFHostAddresses, &err))
	{
		Boolean hasBeenResolved;
		NSArray* addrs = (NSArray*)CFHostGetAddressing(host, &hasBeenResolved);
		if ([addrs count] > 0) {
			NSData* addrData = [addrs objectAtIndex:0];
			struct sockaddr_in* pAddr = (struct sockaddr_in*)[addrData bytes];
			
			char* pAddrString = inet_ntoa(pAddr->sin_addr);
			
			_hostIPAddress = [[NSString alloc] initWithCStringNoCopy:pAddrString
														   length:strlen(pAddrString)
													 freeWhenDone:YES];
			
			ret = YES;
		}
		
	}
	CFRelease(host);
	return ret;
}

-(BOOL)checkSubnetMask
{
	NSArray* ipParts =
	[self.mask captureComponentsMatchedByRegex:(NSString*)IP_PATTERN];
	
	return (5 == [ipParts count]);
	
}

-(BOOL)checkMACFormat
{
	NSArray* macParts =
	[self.mac captureComponentsMatchedByRegex:(NSString*)MAC_PATTERN];
	
	return (7 == [macParts count]);
}



@end
