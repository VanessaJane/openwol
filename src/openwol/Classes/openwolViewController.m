//
//  openwolViewController.m
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//

#import "openwolViewController.h"
#import "WOLClient.h"
#import "Settings.h"

@implementation openwolViewController

- (void)backgroundClick:(id)sender
{
	[_host resignFirstResponder];
	[_subNet resignFirstResponder];
	[_port resignFirstResponder];
	[_macAddress resignFirstResponder];
}

- (void)onWakeUp:(id)sender
{
	WOLClient* client = [[WOLClient alloc] init];
	client.Host = [_host text];
	client.SubNet = [_subNet text];
	client.Port = [_port text];
	client.Mac = [_macAddress text];
	
	Settings* settings = [[Settings alloc] init];
	settings.Host = [_host text];
	settings.SubNet = [_subNet text];
	settings.Port = [_port text];
	settings.Mac = [_macAddress text];
	settings.OverInternet = _lanOrWan.selectedSegmentIndex;
	
	if (![client checkPort]) {
		[self alert:@"Port should large than 0 and less than 65535."];
		[client release];
		return;
	}
	
	
	if (![client checkMACFormat]) {
		[self alert:@"There is something wrong with MAC."];
		[client release];
		return;
	}
	BOOL overInternet = _lanOrWan.selectedSegmentIndex == 0;
	if (overInternet) {

		if (![client checkHost]) {
			[self alert:@"There is something wrong with Host."];
			[client release];
			return;
		}
		
		
		if (![client checkSubnetMask]) {
			[self alert:@"There is something wrong with Subnet Mask."];
			[client release];
			return;
		}
	}
	[settings save];
	[settings release];
	[client wakeUp:overInternet];
	[client release];
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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	
	Settings* settings = [[Settings alloc] init];
	if ([settings load]) {
		_host.text = settings.Host;
		_port.text = settings.Port;
		_macAddress.text = settings.Mac;
		_subNet.text = settings.SubNet;
		_lanOrWan.selectedSegmentIndex = settings.OverInternet;
	}
	
	[settings release];
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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
