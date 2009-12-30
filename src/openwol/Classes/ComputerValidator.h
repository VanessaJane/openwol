//
//  Settings.h
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Computer.h"

@interface Computer (ComputerValidator) 

-(BOOL)checkHost;
-(BOOL)checkMACFormat;
-(BOOL)checkSubnetMask;
-(BOOL)checkPort;
-(struct sockaddr_in*) getTargetAddr;
-(BOOL)doValidator:(SEL)alertSelector target:(id)obj;
@end
