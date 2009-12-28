//
//  Settings.h
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {
	NSString* _mac;
	NSString* _port;
	NSString* _subNet;
	NSString* _host;
	int	_overInternet;
}
@property (retain, nonatomic) NSString* Mac;
@property (retain, nonatomic) NSString* Port;
@property (retain, nonatomic) NSString* SubNet;
@property (retain, nonatomic) NSString* Host;
@property (assign, nonatomic) int OverInternet;
-(BOOL)load;
-(BOOL)save;

@end
