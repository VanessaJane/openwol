//
//  ComputerDelegate.h
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

@class Computer;
@protocol ComputerDelegate

@optional
- (void)computerAdded:(Computer*)computer;
- (void)computerUpdated:(Computer*)computer;
@end
