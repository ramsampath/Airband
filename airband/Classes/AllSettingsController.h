//
//  AllSettingsController.h
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC/Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSettingsController : UIViewController<UITextFieldDelegate>
{	
	IBOutlet UITextField  *username_;
	IBOutlet UITextField  *password_;
	IBOutlet UIButton     *login_;
	IBOutlet UIButton     *create_;
	IBOutlet UIActivityIndicatorView  *activity_;
	IBOutlet UILabel      *status_;
	IBOutlet UIButton     *background_;
	IBOutlet UISwitch     *autologin_;
	
	NSTimer  *timeout_;
}

- (IBAction) loginAction:(id)sender;
- (IBAction) createAccountAction:(id)sender;

@end
