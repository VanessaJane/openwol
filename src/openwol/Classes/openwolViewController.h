//
//  openwolViewController.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface openwolViewController : UIViewController {
	IBOutlet UITextField* _macAddress;
	IBOutlet UITextField* _port;
	IBOutlet UITextField* _subNet;
	IBOutlet UITextField* _host;
	IBOutlet UISegmentedControl* _lanOrWan;
}

- (void)onWakeUp:(id)sender;
- (void)backgroundClick:(id)sender;

@end

