//
//  ComputersViewController.m
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import "MainViewController.h"
#import "openwolAppDelegate.h"
#import "ComputerDetailViewController.h"
#import "Computer.h"
#import "ComputerCell.h"
#import "WOLClient.h"
#import "ComputerValidator.h"

@implementation MainViewController

- (void)showDetialView:(Computer*)computer
{
	if (nil == _detailView) {
		_detailView = [[ComputerDetailViewController alloc]
					   initWithNibName:@"ComputerDetailView"
					   bundle:nil];
		_detailView.delegate = self;
	}
	_detailView.computer = computer;
	openwolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[[delegate navController] pushViewController:_detailView
										animated:YES];
}

- (void)onAddClick:(id)sender
{
	[self showDetialView:nil];
}

- (void)computerAdded:(Computer *)computer{
	[_computers insertObject:[computer retain] atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
															  inSection:0]
						  atScrollPosition:UITableViewScrollPositionTop
								  animated:YES];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ComputerCell* cell = [[ComputerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
												   reuseIdentifier:@"computerListCell"];
	
	Computer* computer = [_computers objectAtIndex:[indexPath row]];
	[cell computerUpdated:computer];
	
	computer.delegate = cell;

	return [cell autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_computers count];
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

- (void)wakeUp:(Computer*)computer
{
	if (![computer doValidator:@selector(alert:) target:self]) {
		return;
	}
		
	WOLClient* client = [[WOLClient alloc] init];
	client.computer = computer;
	
	[client wakeUp];
	[client release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		// TODO: wake up
	}
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	_selectedIndex = [indexPath row];
	Computer* computer = [_computers objectAtIndex:_selectedIndex];
	UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Wake up \"%@\" now?", computer.name] 
													delegate:self
										cancelButtonTitle:@"No, not now."
									  destructiveButtonTitle:@"Yes, please."
										   otherButtonTitles:nil];
	[as showInView:self.view];
	[as release];
}

- (void) tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self showDetialView:[_computers objectAtIndex:[indexPath row]]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		/*
        // Delete the managed object at the given index path.
        NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:eventToDelete];
		
        // Update the array and table view.
        [eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
        // Commit the change.
        NSError *error;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
		 */
    }
}

- (void)viewDidLoad{
	openwolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity =
		[NSEntityDescription entityForName:@"Computer"
					inManagedObjectContext:delegate.managedObjectContext];
	[request setEntity:entity];
	NSError *error = nil;
	_computers = [[delegate.managedObjectContext
											executeFetchRequest:request
											error:&error] mutableCopy];
	
	[request release];
	if (_computers == nil) {
		abort();
	}
	
	
	[super viewDidLoad];
}


- (void)dealloc
{
	[_detailView release];
	
	for (id obj in _computers){
		[obj release];
	}
	
	[_computers release];
	[super dealloc];
}


@end
