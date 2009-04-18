//
//  SettingsController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface SettingsController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
@interface SettingsController : UIViewController<UITextFieldDelegate> {
	IBOutlet UITextField  *username_;
	IBOutlet UITextField  *password_;
	IBOutlet UITableView *table_;
}

-(IBAction) setPassword;
-(IBAction) setUsername;
-(IBAction) login;
-(IBAction) clearEverything;

@end
