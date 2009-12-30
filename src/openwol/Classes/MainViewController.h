//
//  ComputersViewController.h
//  openwol
//
//  Created by iceboundrock on 09-12-29.
//  Copyright 2009 Lychee Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ComputerDelegate.h"

@class ComputerDetailViewController;

@interface MainViewController : UITableViewController
<UITableViewDelegate,
UITableViewDataSource,
ComputerDelegate,
UIActionSheetDelegate> 
{
	NSMutableArray* _computers;
	
	int _selectedIndex;
	
	ComputerDetailViewController* _detailView;
}

- (IBAction)onAddClick:(id)sender;

@end
