//
//  AllSettingsController.m
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC/Elliptic. All rights reserved.
//

#import "AllSettingsController.h"
#import "SettingsController.h"
#import "AllSettingsTableCell.h"
#import	"PlaylistTracksController.h"
#import "appdata.h"
#import "airbandAppDelegate.h"


@implementation AllSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {		
		timeout_ = nil;
    }
    return self;
}


-(void) prepForLogin
{
	[activity_ stopAnimating];
	
	username_.enabled = TRUE;
	password_.enabled = TRUE;
	autologin_.enabled = TRUE;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:6];
	login_.alpha = 1;
	create_.alpha  = 1;
	password_.alpha = 1;
	username_.alpha = 1;	
	autologin_.alpha = 1;
	background_.alpha = .6;	
	[UIView commitAnimations];		
}


- (void)timerFireMethod:(NSTimer*)theTimer
{	
	[timeout_ invalidate];
	timeout_ = nil;
	
	[[[UIAlertView alloc] initWithTitle:@"Airband" 
								message:@"Couldn't log in"
							   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	
	status_.text = @"try again!";	
	
    [loadingView_ removeView];
	[self prepForLogin];
}


// additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{	
	//[TODO] -- when more providers are available:
	//load our data data from a plist file inside our app bundle
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"SettingsData" ofType:@"plist"];
	//self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];	
	
	AppData *app = [AppData get];		
	
	// [TODO] -- see the keychain mess in settingscontroller.m	
	username_.text = app.username_;	
	password_.text = app.password_;

	if (![app.username_ length] || ![app.password_ length]) 
	{
		[self prepForLogin];
	}
	else   		// try logging in
	{	
		// [TODO] -- let the user set this; use autologin_ switch
		
		BOOL autologin = [app autoLogin_];
        
		if( autologin ) {
			[self loginAction:nil];
		} else {
			[self prepForLogin];
		}
	}
}


- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
}


- (void) loginFail:(id) unused
{
	[timeout_ invalidate];
	timeout_ = nil;
	status_.text = @"Login problems!";

	[[[UIAlertView alloc] initWithTitle:@"Airband" 
								message:@"Problem logging in"
							   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	
    [loadingView_ removeView];
	[self prepForLogin];
}


- (void) loginOK:(id) unused
{
	// [NOTE] -- invalidate the timer here, might be too soon as the
	//           artistlist can fail also.
	
	[timeout_ invalidate];
	timeout_ = nil;
	
	status_.text = @"Success! request bands...";
    [loadingView_ removeView];
    loadingView_ = [LoadingView loadingViewInView:self.view loadingText:@"Loading Artists..."];
}


- (void) artistListReady:(id) unused
{
    [loadingView_ removeView];
    
	airbandAppDelegate *airband = (airbandAppDelegate*) ([UIApplication sharedApplication].delegate);
	[airband startMainUI];	
}

- (void) albumListReady:(id) unused
{
}


- (void) goLogin
{
	[activity_ startAnimating];
	
	timeout_ = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)10
												target:self 
											  selector:@selector(timerFireMethod:)
											  userInfo:NULL repeats:NO ];	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2];
	login_.alpha = .1;
	create_.alpha  = .1;
	password_.alpha = .1;
	username_.alpha = .1;
	autologin_.alpha = .1;
	background_.alpha = 1;
	[UIView commitAnimations];		
	
	username_.enabled = FALSE;
	password_.enabled = FALSE;	
	
	status_.text = @"Connecting...";
    
    loadingView_ = [LoadingView loadingViewInView:self.view loadingText:@"Connecting..."];

	//
	// wait for login to succeed and artist list to arrive
	//
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginFail:) 
												 name:@"loginFAIL" 
											   object:nil];		

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginFail:) 
												 name:@"connectionFAIL" 
											   object:nil];		
	
	// [TODO] -- might want to split this into just login 
	//           and then go directly to artist view screen.
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginOK:) 
												 name:@"loginOK" 
											   object:nil];		
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(artistListReady:) 
												 name:@"artistListReady" 
											   object:nil];
    	
	AppData *app = [AppData get];

	//
	// save the input 
	// [NOTE] -- doesn't get written to user data area just yet.
	// 
	app.password_ = password_.text;
	app.username_ = username_.text;
	
	//
	// log in ...
	//
	
	if( ![app login] )
	{
		[self prepForLogin];
	}	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -----------------------
#pragma mark nibCallbacks
#pragma mark -----------------------

- (IBAction) loginAction:(id)sender
{
	[self goLogin];
}


- (IBAction) createAccountAction:(id)sender
{		
}


#pragma mark -----------------------
#pragma mark textFieldDelegate
#pragma mark -----------------------

- (BOOL)textFieldShouldReturn:(UITextField *)thetextField 
{
	[thetextField resignFirstResponder];
	return YES;
}

@end
