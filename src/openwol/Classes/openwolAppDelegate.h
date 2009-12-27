//
//  openwolAppDelegate.h
//  openwol
//
//  Created by iceboundrock on 09-12-28.
//  Copyright Lychee Studio 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class openwolViewController;

@interface openwolAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    openwolViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet openwolViewController *viewController;

@end

