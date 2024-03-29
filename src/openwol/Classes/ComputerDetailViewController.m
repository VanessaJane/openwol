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

const NSString *ComputerCellIdentifier = @"ComputerCellIdentifier";

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

-(void) setNavButton:(NSString*)title action:(SEL)action isLeft:(BOOL)isLeft
{
	UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:title
																	 style:UIBarButtonItemStylePlain
																	target:self
																	action:action];
	if (isLeft) {
		self.navigationItem.leftBarButtonItem = button;
	}
	else{
		self.navigationItem.rightBarButtonItem = button;
	}
	[button release];
	
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
													reuseIdentifier:(NSString*)ComputerCellIdentifier] autorelease];
	UILabel* label = [self createLabel:[_labelsText objectAtIndex:[indexPath row]]];
	UIView* inputField = [_inputFields objectAtIndex:[indexPath row]];
	
	[cell.contentView addSubview:label];
	[cell.contentView addSubview:inputField];
	
	[label release];
	
	return cell;
}

- (UITextField*)createTextField
{
	UITextField *textField = [[UITextField alloc] initWithFrame:
							  CGRectMake(120, 12, 200, 32)];
	textField.clearsOnBeginEditing = NO;
	[textField setDelegate:self];
	[textField addTarget:self 
				  action:@selector(textFieldDone:) 
		forControlEvents:UIControlEventEditingDidEndOnExit];
	
	return textField;
}

- (UILabel*)createLabel:(NSString*)text
{
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 32)];
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont boldSystemFontOfSize:18];
	label.text = text;
	return label;
}


- (void) backToMainView {
  openwolAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController popViewControllerAnimated:YES];

}
-(IBAction) onCancel:(id)sender
{
	[self backToMainView];

}

-(void) viewDidLoad{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	
	
	[_inputFields release];
	[_labelsText release];
	[_name release];
	[_macAddress release];
	[_port release];
	[_subNet release];
	[_boardcast release];
	[_computer release];
	[_host release];
	
	_labelsText = [[NSArray alloc] initWithObjects:@"Name",
						@"MAC", @"Port", @"Host", @"Mask", @"Boardcast", nil];
	
	_name = [self createTextField];
	_name.placeholder = @"My FTP Server";
	
	_macAddress = [self createTextField];
	[_macAddress setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	_macAddress.placeholder = @"00-25-A0-CC-00-E2";
	
	_port = [self createTextField];
	[_port setKeyboardType:UIKeyboardTypeNumberPad];
	_port.placeholder = @"7";
	
	_host = [self createTextField];
	_host.placeholder = @"ftp.my.com";
	
	_subNet = [self createTextField];
	[_subNet setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	_subNet.placeholder = @"255.255.255.255";
	
	_boardcast = [[UISwitch alloc] initWithFrame:CGRectMake(120, 8, 170, 32)];
	
	_inputFields =  [[NSArray alloc] initWithObjects:_name, _macAddress,
					 _port, _host, _subNet, _boardcast, nil];
		
	//[self setNavButton:@"Cancel" action:@selector(onCancel:) isLeft:YES];
	[self setNavButton:@"Save" action:@selector(onSave:) isLeft:NO];
	[super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated{
	
    if (nil != _computer) {
		_name.text = _computer.name;
		_host.text = _computer.host;
		_port.text = [NSString stringWithFormat:@"%d", [_computer.port intValue]];
		_macAddress.text = _computer.mac;
		_subNet.text = _computer.mask;
		
		_boardcast.on = ![_computer.overInternet boolValue];
	}
	else {
		_name.text = @"";
		_host.text = @"";
		_port.text = @"";
		_macAddress.text = @"";
		_subNet.text = @"";
		_boardcast.on = NO;
		
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


- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return kNumberOfEditableRows;
}


/*
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}
*/

-(void) keyboardWillShow:(NSNotification *)note
{
	
	if (![_subNet isFirstResponder]) {
		return;
	}
	
	if(!_isScrolling)
    {
        _isScrolling = YES;
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
        CGFloat keyboardHeight = keyboardBounds.size.height;
		
		CGRect frame = self.view.frame;
		frame.size.height += keyboardHeight;
		self.view.frame = frame;
		
        CGPoint scrollPoint = frame.origin;
        scrollPoint.y += ((UITableView*)self.view).contentSize.height - keyboardHeight;
        [((UITableView*)self.view) setContentOffset:scrollPoint animated:YES];
    }
}

-(void) keyboardWillHide:(NSNotification *)note
{
	if(_isScrolling)
    {
        _isScrolling = NO;
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
        CGFloat keyboardHeight = keyboardBounds.size.height;
		
		CGRect frame = self.view.frame;
		frame.size.height -= keyboardHeight;
		self.view.frame = frame;
		
        CGPoint scrollPoint = frame.origin;
		[((UITableView*)self.view) setContentOffset:scrollPoint animated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (IBAction)onSave:(id)sender
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	openwolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	BOOL insert = nil == _computer;
	if (insert) {
		_computer = (Computer*)
		[NSEntityDescription
		 insertNewObjectForEntityForName:@"Computer"
		 inManagedObjectContext:delegate.managedObjectContext];
		
		[_computer retain];
	}
	
	_computer.port = [NSNumber numberWithInt:[_port.text intValue]];
	
	
	_computer.overInternet = [NSNumber numberWithBool:!_boardcast.on];
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
	if (![delegate.managedObjectContext save:&error])
	{
		[self alert:[NSString
					 stringWithFormat:@"Save failed. Error code: %d",
					 [error code]]];
	}else {
		if (insert) 
		{
			if (_delegate != nil &&
				[_delegate conformsToProtocol:@protocol(ComputerDelegate)])
			{
				[_delegate computerAdded:_computer];
			}
		}
		else
		{
			[_computer updated];
		}
		
		[self backToMainView];
	}

}


- (void)dealloc {
	[_inputFields release];
	[_labelsText release];
	[_name release];
	[_macAddress release];
	[_port release];
	[_subNet release];
	[_boardcast release];
	[_computer release];
	[_host release];
	
	[super dealloc];
}

-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= kNumberOfEditableRows)
        row = 0;
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex 
                                                         length:2];
    UITableViewCell *nextCell = [self.tableView 
                                 cellForRowAtIndexPath:newPath];
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}

@end
