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



-(void) loadVieww
{
    [super loadView];
    
    UIButton *loginButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton_.frame = CGRectMake(120.0, 227.0, 80.0, 22.0);
    loginButton_.adjustsImageWhenDisabled = YES;
    loginButton_.adjustsImageWhenHighlighted = YES;
    loginButton_.alpha = 0.100;
    loginButton_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    loginButton_.clearsContextBeforeDrawing = NO;
    loginButton_.clipsToBounds = NO;
    loginButton_.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    loginButton_.contentMode = UIViewContentModeScaleToFill;
    loginButton_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginButton_.enabled = YES;
    loginButton_.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.000];
    loginButton_.hidden = NO;
    loginButton_.highlighted = NO;
    loginButton_.multipleTouchEnabled = NO;
    loginButton_.opaque = NO;
    loginButton_.reversesTitleShadowWhenHighlighted = NO;
    loginButton_.selected = NO;
    loginButton_.showsTouchWhenHighlighted = NO;
    loginButton_.tag = 0;
    loginButton_.titleShadowOffset = CGSizeMake(0.0, 0.0);
    loginButton_.userInteractionEnabled = YES;
    [loginButton_ setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton_ addTarget:self action:@selector(loginAction:) forControlEvents:UIControlStateSelected];
    [loginButton_ setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0.000] forState:UIControlStateNormal];
    [loginButton_ setTitleColor:[UIColor colorWithWhite:1.000 alpha:0.000] forState:UIControlStateHighlighted];
    [loginButton_ setTitleShadowColor:[UIColor colorWithRed:0.082 green:0.061 blue:0.074 alpha:1.000] forState:UIControlStateNormal];
    loginButton_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbutton_bg.png"]];

    UITextField *usernameText_ = [[UITextField alloc] initWithFrame:CGRectMake(111.0, 126.0, 178.0, 31.0)];
    usernameText_.frame = CGRectMake(111.0, 126.0, 178.0, 31.0);
    usernameText_.adjustsFontSizeToFitWidth = YES;
    usernameText_.alpha = 0.100;
    usernameText_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameText_.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameText_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    usernameText_.borderStyle = UITextBorderStyleRoundedRect;
    usernameText_.clearsContextBeforeDrawing = NO;
    usernameText_.clearsOnBeginEditing = NO;
    usernameText_.clipsToBounds = NO;
    usernameText_.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    usernameText_.contentMode = UIViewContentModeScaleToFill;
    usernameText_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameText_.enabled = NO;
    usernameText_.enablesReturnKeyAutomatically = YES;
    usernameText_.font = [UIFont fontWithName:@"Helvetica" size:12.000];
    usernameText_.hidden = NO;
    usernameText_.highlighted = NO;
    usernameText_.keyboardAppearance = UIKeyboardAppearanceDefault;
    usernameText_.keyboardType = UIKeyboardTypeEmailAddress;
    usernameText_.minimumFontSize = 17.000;
    usernameText_.multipleTouchEnabled = NO;
    usernameText_.opaque = NO;
    usernameText_.placeholder = @"email address (for mp3tunes.com)";
    usernameText_.returnKeyType = UIReturnKeyNext;
    usernameText_.secureTextEntry = NO;
    usernameText_.selected = NO;
    usernameText_.tag = 0;
    usernameText_.text = @"";
    usernameText_.textAlignment = UITextAlignmentLeft;
    usernameText_.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
    usernameText_.userInteractionEnabled = YES;
    
    UITextField *passwordText_ = [[UITextField alloc] initWithFrame:CGRectMake(111.0, 164.0, 178.0, 31.0)];
    passwordText_.frame = CGRectMake(111.0, 164.0, 178.0, 31.0);
    passwordText_.adjustsFontSizeToFitWidth = YES;
    passwordText_.alpha = 0.100;
    passwordText_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordText_.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordText_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    passwordText_.borderStyle = UITextBorderStyleRoundedRect;
    passwordText_.clearsContextBeforeDrawing = NO;
    passwordText_.clearsOnBeginEditing = YES;
    passwordText_.clipsToBounds = NO;
    passwordText_.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    passwordText_.contentMode = UIViewContentModeScaleToFill;
    passwordText_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordText_.enabled = NO;
    passwordText_.enablesReturnKeyAutomatically = YES;
    passwordText_.font = [UIFont fontWithName:@"Helvetica" size:12.000];
    passwordText_.hidden = NO;
    passwordText_.highlighted = NO;
    passwordText_.keyboardAppearance = UIKeyboardAppearanceDefault;
    passwordText_.keyboardType = UIKeyboardTypeDefault;
    passwordText_.minimumFontSize = 17.000;
    passwordText_.multipleTouchEnabled = NO;
    passwordText_.opaque = NO;
    passwordText_.placeholder = @"password (for mp3tunes.com)";
    passwordText_.returnKeyType = UIReturnKeyGo;
    passwordText_.secureTextEntry = YES;
    passwordText_.selected = NO;
    passwordText_.tag = 0;
    passwordText_.text = @"";
    passwordText_.textAlignment = UITextAlignmentLeft;
    passwordText_.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
    passwordText_.userInteractionEnabled = YES;
    
    
    UIView *mainview               = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
	mainview.alpha                 = 1.000;
	mainview.autoresizingMask      = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	mainview.backgroundColor       = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.000];
    
    UIButton *mainButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
    mainButton_.frame = CGRectMake(0.0, 20.0, 320.0, 480.0);
    mainButton_.adjustsImageWhenDisabled = NO;
    mainButton_.adjustsImageWhenHighlighted = NO;
    mainButton_.alpha = 1.000;
    mainButton_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    mainButton_.clearsContextBeforeDrawing = NO;
    mainButton_.clipsToBounds = NO;
    mainButton_.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    mainButton_.contentMode = UIViewContentModeScaleToFill;
    mainButton_.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    mainButton_.enabled = YES;
    mainButton_.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.000];
    mainButton_.hidden = NO;
    mainButton_.highlighted = NO;
    mainButton_.multipleTouchEnabled = NO;
    mainButton_.opaque = NO;
    mainButton_.reversesTitleShadowWhenHighlighted = NO;
    mainButton_.selected = NO;
    mainButton_.showsTouchWhenHighlighted = NO;
    mainButton_.tag = 0;
    mainButton_.userInteractionEnabled = NO;
    [mainButton_ setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [mainButton_ setTitleColor:[UIColor colorWithWhite:1.000 alpha:1.000] forState:UIControlStateHighlighted];
    [mainButton_ setTitleShadowColor:[UIColor colorWithWhite:0.500 alpha:1.000] forState:UIControlStateNormal];
    mainButton_.backgroundColor       = [UIColor colorWithPatternImage:[UIImage imageNamed:@"airband_splash02.png"]];

    UIButton *createButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createButton_.frame = CGRectMake(120.0, 270.0, 80.0, 22.0);
    createButton_.adjustsImageWhenDisabled = YES;
    createButton_.adjustsImageWhenHighlighted = YES;
    createButton_.alpha = 0.100;
    createButton_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    createButton_.clearsContextBeforeDrawing = NO;
    createButton_.clipsToBounds = NO;
    createButton_.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    createButton_.contentMode = UIViewContentModeScaleToFill;
    createButton_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    createButton_.enabled = YES;
    createButton_.font = [UIFont fontWithName:@"Helvetica" size:11.000];
    createButton_.hidden = NO;
    createButton_.highlighted = NO;
    createButton_.multipleTouchEnabled = NO;
    createButton_.opaque = NO;
    createButton_.reversesTitleShadowWhenHighlighted = NO;
    createButton_.selected = NO;
    createButton_.showsTouchWhenHighlighted = NO;
    createButton_.tag = 0;
    createButton_.userInteractionEnabled = YES;
    [createButton_ setTitle:@"Create" forState:UIControlStateNormal];
    [createButton_ setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
    [createButton_ setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [createButton_ setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
    createButton_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbutton_bg.png"]];
    
    UILabel *usernameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 131.0, 79.0, 21.0)];
    usernameLabel_.frame = CGRectMake(20.0, 131.0, 79.0, 21.0);
    usernameLabel_.adjustsFontSizeToFitWidth = YES;
    usernameLabel_.alpha = 1.000;
    usernameLabel_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    usernameLabel_.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    usernameLabel_.clearsContextBeforeDrawing = YES;
    usernameLabel_.clipsToBounds = YES;
    usernameLabel_.contentMode = UIViewContentModeScaleToFill;
    usernameLabel_.enabled = NO;
    usernameLabel_.font = [UIFont fontWithName:@"Helvetica" size:12.000];
    usernameLabel_.hidden = NO;
    usernameLabel_.lineBreakMode = UILineBreakModeTailTruncation;
    usernameLabel_.minimumFontSize = 10.000;
    usernameLabel_.multipleTouchEnabled = NO;
    usernameLabel_.numberOfLines = 1;
    usernameLabel_.opaque = NO;
    usernameLabel_.shadowOffset = CGSizeMake(0.0, -1.0);
    usernameLabel_.tag = 0;
    usernameLabel_.text = @"Username";
    usernameLabel_.textAlignment = UITextAlignmentLeft;
    usernameLabel_.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    usernameLabel_.backgroundColor = [UIColor clearColor];
    usernameLabel_.userInteractionEnabled = NO;
    
    UILabel *passwordLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 169.0, 75.0, 21.0)];
    passwordLabel_.frame = CGRectMake(20.0, 169.0, 75.0, 21.0);
    passwordLabel_.adjustsFontSizeToFitWidth = YES;
    passwordLabel_.alpha = 1.000;
    passwordLabel_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    passwordLabel_.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    passwordLabel_.clearsContextBeforeDrawing = YES;
    passwordLabel_.clipsToBounds = YES;
    passwordLabel_.contentMode = UIViewContentModeScaleToFill;
    passwordLabel_.enabled = NO;
    passwordLabel_.font = [UIFont fontWithName:@"Helvetica" size:12.000];
    passwordLabel_.hidden = NO;
    passwordLabel_.lineBreakMode = UILineBreakModeTailTruncation;
    passwordLabel_.minimumFontSize = 10.000;
    passwordLabel_.multipleTouchEnabled = NO;
    passwordLabel_.numberOfLines = 1;
    passwordLabel_.opaque = NO;
    passwordLabel_.shadowOffset = CGSizeMake(0.0, -1.0);
    passwordLabel_.tag = 0;
    passwordLabel_.text = @"Password";
    passwordLabel_.textAlignment = UITextAlignmentLeft;
    passwordLabel_.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    passwordLabel_.backgroundColor = [UIColor clearColor];
    passwordLabel_.userInteractionEnabled = NO;
    
    UILabel *statusView_ = [[UILabel alloc] initWithFrame:CGRectMake(129.0, 97.0, 62.0, 21.0)];
    statusView_.frame = CGRectMake(129.0, 97.0, 62.0, 21.0);
    statusView_.adjustsFontSizeToFitWidth = YES;
    statusView_.alpha = 1.000;
    statusView_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    statusView_.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    statusView_.clearsContextBeforeDrawing = YES;
    statusView_.clipsToBounds = YES;
    statusView_.contentMode = UIViewContentModeScaleToFill;
    statusView_.enabled = YES;
    statusView_.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.000];
    statusView_.hidden = NO;
    statusView_.lineBreakMode = UILineBreakModeTailTruncation;
    statusView_.minimumFontSize = 10.000;
    statusView_.multipleTouchEnabled = NO;
    statusView_.numberOfLines = 1;
    statusView_.opaque = NO;
    statusView_.shadowOffset = CGSizeMake(0.0, -1.0);
    statusView_.tag = 0;
    statusView_.text = @"Welcome";
    statusView_.textAlignment = UITextAlignmentLeft;
    statusView_.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    statusView_.backgroundColor = [UIColor clearColor];
    statusView_.userInteractionEnabled = NO;
        

    
    UIActivityIndicatorView *activityView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView_.frame = CGRectMake(71.0, 95.0, 20.0, 20.0);
    activityView_.alpha = 1.000;
    activityView_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    activityView_.clearsContextBeforeDrawing = NO;
    activityView_.clipsToBounds = NO;
    activityView_.contentMode = UIViewContentModeScaleToFill;
    activityView_.hidden = NO;
    activityView_.hidesWhenStopped = YES;
    activityView_.multipleTouchEnabled = NO;
    activityView_.opaque = NO;
    activityView_.tag = 0;
    activityView_.userInteractionEnabled = NO;
    [activityView_ startAnimating];
    
    [mainview addSubview:mainButton_];
    [mainview addSubview:activityView_];
    [mainview addSubview:usernameLabel_];
    [mainview addSubview:usernameText_];
    [mainview addSubview:passwordLabel_];
    [mainview addSubview:passwordText_];
    [mainview addSubview:createButton_];
    [mainview addSubview:loginButton_];
    [mainview addSubview:statusView_];

    self.view = mainview;
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
								message:@"Login Timedout"
							   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	
	status_.text = @"Try Again!";	
	
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
	
	status_.text = @"Loading Artists...";
    [loadingView_ removeView];
    loadingView_ = [LoadingView loadingViewInView:status_ loadingText:@"Loading Artists..." fontSize:12.0];
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
	
	timeout_ = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)15
												target:self 
											  selector:@selector(timerFireMethod:)
											  userInfo:NULL repeats:NO ];	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2];
	login_.alpha      = .1;
	create_.alpha     = .1;
	password_.alpha   = .1;
	username_.alpha   = .1;
	autologin_.alpha  = .1;
	background_.alpha = 1;
	[UIView commitAnimations];		
	
	username_.enabled = FALSE;
	password_.enabled = FALSE;	
	
	status_.text = @"Connecting...";
    
    loadingView_ = [LoadingView loadingViewInView:status_ loadingText:@"Connecting..." fontSize:12.0];

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
