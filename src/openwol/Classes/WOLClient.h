//
//  WOLClient.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright 2009 Lychee Studio. All rights reserved.
//


#import <netinet/in.h>
#import <ifaddrs.h>

@class Computer;
@interface WOLClient : NSObject {
	Computer* _computer;
	NSString* _hostIPAddr;
}

@property (retain, nonatomic) Computer* computer;


-(void) wakeUp;
-(void) wakeUpLan;
-(void) wakeUpWan;
-(NSData*) buildPayload;
-(NSData*) parseMAC;



@end
