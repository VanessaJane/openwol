//
//  openwolViewController.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kNumberOfEditableRows		6
#define kNameRowIndex				0
#define kMacRowIndex				1
#define kPortRowIndex				2
#define kHostRowIndex				3
#define kMaskRowIndex				4
#define kOverInternetRowIndex		5

@class Computer;

@interface ComputerDetailViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	IBOutlet UITextField* _macAddress;
	IBOutlet UITextField* _port;
	IBOutlet UITextField* _subNet;
	IBOutlet UITextField* _host;
	IBOutlet UITextField* _name;
	IBOutlet UISwitch* _boardcast;
	IBOutlet UITextField* _textFieldBeingEdited;
	
	NSArray* _inputFields;
	NSArray* _labelsText;
	
	Computer* _computer;
	BOOL _isScrolling;
	
	id _delegate;
}

@property (nonatomic, retain) Computer* computer;
@property (retain, nonatomic) id delegate;

- (IBAction)onSave:(id)sender;
- (void)backgroundClick:(id)sender;
- (void)alert:(NSString*)msg;
- (UILabel*)createLabel:(NSString*)text;
@end

