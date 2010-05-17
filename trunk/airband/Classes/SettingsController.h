//
//  SettingsController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
//@interface SettingsController : UIViewController<UITextFieldDelegate> {
    IBOutlet UITextField     *username_;
    IBOutlet UITextField     *password_;
    IBOutlet UITableView     *table_;
    IBOutlet UITableView     *table2_;
    IBOutlet UITableViewCell *usernamecell_;
    IBOutlet UITableViewCell *passwordcell_;
    IBOutlet UITableViewCell *startpagecell_;
    IBOutlet UITableViewCell *coverflowstylecell_;
    int                       startscreen_;
    IBOutlet UITableView     *table3_;
}

@property(readonly) int startscreen_;
@property (nonatomic, retain) IBOutlet UITableView *table_;
@property (nonatomic, retain) IBOutlet UITableView *table2_;
@property (nonatomic, retain) IBOutlet UITableView *table3_;


-(IBAction) setPassword;
-(IBAction) setUsername;
-(IBAction) login;
-(IBAction) clearEverything;
-(IBAction) createAccount;

@end
