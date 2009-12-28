//
//  WOLClient.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WOLClient : NSObject {
	NSString* _mac;
	NSString* _port;
	NSString* _subNet;
	NSString* _host;
}

@property (retain, nonatomic) NSString* Mac;
@property (retain, nonatomic) NSString* Port;
@property (retain, nonatomic) NSString* SubNet;
@property (retain, nonatomic) NSString* Host;

-(void) wakeUp:(BOOL)overInternet;
-(void) wakeUpLan;
-(void) wakeUpWan;
-(NSData*) buildPayload;
-(NSData*) parseMAC;
-(struct sockaddr_in*) getTargetAddr;
-(BOOL)checkHost;
-(BOOL)checkMACFormat;
-(BOOL)checkSubnetMask;
- (BOOL)checkPort;

@end
