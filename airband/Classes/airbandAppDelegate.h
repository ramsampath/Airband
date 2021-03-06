//
//  airbandAppDelegate.h
//  airband
//
//  Created by Scot Shinderman on 8/26/08.
//  Copyright Elliptic 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xmlhelp.h"
#import "appdata.h"

@interface airbandAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	
	AppData *appdata_;
}

- (void) startMainUI;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) AppData* appdata_;

@end
