//
//  openwolViewController.m
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//

#import "openwolAppDelegate.h"
#import "ComputerDetailViewController.h"
#import "WOLClient.h"
#import "Computer.h"
#import "ComputerDelegate.h"
#import "ComputerValidator.h"

@implementation ComputerDetailViewController

@synthesize computer = _computer;
@synthesize delegate = _delegate;

- (void)backgroundClick:(id)sender
{
	[_host resignFirstResponder];
	[_subNet resignFirstResponder];
	[_port resignFirstResponder];
	[_macAddress resignFirstResponder];
	[_name resignFirstResponder];
}


- (void)alert:(NSString*)msg{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
													message:msg 
												   delegate:self
										  cancelButtonTitle:@"Okey"
						  
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void) viewWillAppear:(BOOL)animated{
    if (nil != _computer) {
		_name.text = _computer.name;
		_host.text = _computer.host;
		_port.text = [NSString stringWithFormat:@"%d", [_computer.port intValue]];
		_macAddress.text = _computer.mac;
		_subNet.text = _computer.mask;
		
		_lanOrWan.selectedSegmentIndex = [_computer.overInternet boolValue] ? 0 : 1;
	}
	else {
		_name.text = @"";
		_host.text = @"";
		_port.text = @"";
		_macAddress.text = @"";
		_subNet.text = @"";
		_lanOrWan.selectedSegmentIndex = 0;
		
	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)showNotification:(BOOL)s
{
}

- (IBAction)onSave:(id)sender
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	openwolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	BOOL insert = nil == _computer;
	if (insert) {
		_computer = (Computer*)[NSEntityDescription insertNewObjectForEntityForName:@"Computer"
												  inManagedObjectContext:delegate.managedObjectContext];
		[_computer retain];
	}
	
	_computer.port = [NSNumber numberWithInt:[_port.text intValue]];
	
	
	_computer.overInternet = [NSNumber numberWithBool:(_lanOrWan.selectedSegmentIndex == 0)];
	
	
	
	_computer.mask = _subNet.text;
	_computer.host = _host.text;
	_computer.name = _name.text;
	_computer.mac = _macAddress.text;
	
	if (![_computer doValidator:@selector(alert:) target:self]) {
		[_computer release];
		_computer = nil;
		return;
	}
	
	NSError *error;
	if (![delegate.managedObjectContext save:&error]) {
		[self alert:[NSString
					 stringWithFormat:@"Save failed. Error code: %d",
					 [error code]]];
	}else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Info"
															message:@"Save successfully."
														delegate:self
												  cancelButtonTitle:@"Okey"
												  otherButtonTitles:nil];
		
		if (insert) {
			if (_delegate != nil &&
				[_delegate conformsToProtocol:@protocol(ComputerDelegate)]) {
					[_delegate computerAdded:_computer];
			}
		}
		else {
			[_computer updated];
		}
		
		[alertView show];
		[alertView release];
	}

}


- (void)dealloc {
	if (_computer != nil) {
		[_computer release];
	}
	
	[super dealloc];
}

@end
