//
//  openwolViewController.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Computer;

@interface ComputerDetailViewController : UIViewController {
	IBOutlet UITextField* _macAddress;
	IBOutlet UITextField* _port;
	IBOutlet UITextField* _subNet;
	IBOutlet UITextField* _host;
	IBOutlet UITextField* _name;
	IBOutlet UISegmentedControl* _lanOrWan;
	IBOutlet UIButton* _saveButton;
	Computer* _computer;
	
	id _delegate;
}

@property (nonatomic, retain) Computer* computer;
@property (retain, nonatomic) id delegate;

- (IBAction)onSave:(id)sender;
- (void)backgroundClick:(id)sender;
- (void)alert:(NSString*)msg;
@end

