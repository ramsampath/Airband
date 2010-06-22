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
    
    printf("LoadView\n");
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
#ifdef __IPHONE_3_0	
	loginButton_.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.000];
#else
    loginButton_.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.000];
#endif
	
    loginButton_.hidden = NO;
    loginButton_.highlighted = NO;
    loginButton_.multipleTouchEnabled = NO;
    loginButton_.opaque = NO;
    loginButton_.reversesTitleShadowWhenHighlighted = NO;
    loginButton_.selected = NO;
    loginButton_.showsTouchWhenHighlighted = NO;
    loginButton_.tag = 0;
#ifdef __IPHONE_3_0	
	// [todo] -- assuming this is setup by default
#else
    loginButton_.titleShadowOffset = CGSizeMake(0.0, 0.0);
#endif
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
    usernameText_.textAlignment = UITextAlignmentLeft;
    usernameText_.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
    usernameText_.userInteractionEnabled = YES;
    AppData *app = [AppData get];
    usernameText_.text = [app username_];
    
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
    passwordText_.text = [app password_];
    
    
    UIView *mainview;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768, 1024.0)];
    }
    else {
        mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    }
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
#ifdef __IPHONE_3_0
	mainButton_.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.000];
#else	
    mainButton_.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.000];
#endif
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
    printf("heee %d\n", UI_USER_INTERFACE_IDIOM());

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        mainButton_.backgroundColor       = [UIColor colorWithPatternImage:[UIImage imageNamed:@"airband_splash02@2x-iPad.png"]];
    }
    else {
        mainButton_.backgroundColor       = [UIColor colorWithPatternImage:[UIImage imageNamed:@"airband_splash02@2x.png"]];
    }
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
#ifdef __IPHONE_3_0	
	createButton_.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:11.000];
#else	
    createButton_.font = [UIFont fontWithName:@"Helvetica" size:11.000];
#endif
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
	username_.userInteractionEnabled = TRUE;
	password_.userInteractionEnabled = TRUE;
	login_.enabled = TRUE;
	create_.enabled = TRUE;
	
    
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
	loadingView_ = nil;
    
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



- (void)viewDidUnload
{
}


- (void) loginFail:(id) unused
{
	AppData *app = [AppData get];		

	[timeout_ invalidate];
	[app stop];
	
	timeout_ = nil;

	NSString *signInProbs = @"Couldn't Sign In";
	
	// hack for too many messages...
	if( ![status_.text isEqualToString:signInProbs] ) {
		[[[UIAlertView alloc] initWithTitle:@"Airband" 
									message:@"Problem signing in"
								   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	}

	status_.text = signInProbs;

    [loadingView_ removeView];
	loadingView_ = nil;
    
	[self prepForLogin];
}


- (void) loginOK:(id) unused
{
	// [NOTE] -- invalidate the timer here, might be too soon as the
	//           artistlist can fail also.
	
    [timeout_ invalidate];
    timeout_ = nil;
    
    AppData *app = [AppData get];

    switch( app.startpage_ ) {
        case 0:
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(listReady:) 
                                                         name:@"artistListReady" 
                                                       object:nil];
            [app getArtistList];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(listReady:) 
                                                         name:@"albumListReady" 
                                                       object:nil];
            [app getAlbumList];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(listReady:) 
                                                         name:@"playListsReady" 
                                                       object:nil];
            [app getPlayListsAsync];
            break;
    }

	
    status_.text = @"Loading...";
    [loadingView_ removeView];
    loadingView_ = [[LoadingView loadingViewInView:status_ loadingText:@"Loading..." fontSize:12.0] retain];
}


- (void) listReady:(id) unused
{
    [loadingView_ removeView];
	loadingView_ = nil;
    
	airbandAppDelegate *airband = (airbandAppDelegate*) ([UIApplication sharedApplication].delegate);
	[airband startMainUI];	
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
	username_.userInteractionEnabled = FALSE;
	password_.userInteractionEnabled = FALSE;
	login_.enabled = FALSE;
	create_.enabled = FALSE;
	
	status_.text = @"Connecting...";
    
    loadingView_ = [[LoadingView loadingViewInView:status_ loadingText:@"Connecting..." fontSize:12.0] retain];

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
	//           and then go directly to artist view screen or selected
    // start page screen.
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginOK:) 
												 name:@"loginOK" 
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
	[self resignFirstResponder];
	[self setViewMovedUp:FALSE];
	[self goLogin];
}


- (IBAction) createAccountAction:(id)sender
{		
	[self resignFirstResponder];
	[self setViewMovedUp:FALSE];
	
	AppData *app = [AppData get];
	NSDictionary *userinfo = [[NSDictionary 
							   dictionaryWithObjects:[NSArray arrayWithObjects:username_.text, password_.text, nil]
							   forKeys:[NSArray arrayWithObjects:@"username", @"password", nil]] retain];
	
	[app createAccount:userinfo];
	
	[userinfo release];
	return;
}


#pragma mark -----------------------
#pragma mark textFieldDelegate
#pragma mark -----------------------

- (BOOL)textFieldShouldReturn:(UITextField *)thetextField 
{
	[thetextField resignFirstResponder];	

	if( thetextField == username_ ) {
		[password_ becomeFirstResponder];
	} else {
		[self setViewMovedUp:FALSE];
		[self goLogin];
	}

	return YES;
}


#pragma mark -------------------------------
#pragma mark UIKeyboard handling
#pragma mark -------------------------------

#define kMin 200

static UITextField *curfield = nil;

// http://cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html

-(void)textFieldDidBeginEditing:(UITextField *)sender
{	
	curfield = sender;
	
	//move the main view, so that the keyboard does not hide it.
	if (self.view.frame.origin.y + create_.frame.origin.y >= kMin) {
        [self setViewMovedUp:YES]; 
	}
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
	curfield = nil;
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = self.view.frame;
	
	if (movedUp)
	{
		// 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
		// 2. increase the size of the view so that the area behind the keyboard is covered up.
		rect.origin.y = kMin - create_.frame.origin.y ;
	}
	else
	{
		// revert back to the normal state.
		rect.origin.y = 0;
	}
	self.view.frame = rect;
		
	[UIView commitAnimations];
}


- (void)keyboardWillShow:(NSNotification *)notif
{
	if ([curfield isFirstResponder] && create_.frame.origin.y + self.view.frame.origin.y >= kMin)
	{
		[self setViewMovedUp:YES];
	}
	else if (![curfield isFirstResponder] && create_.frame.origin.y  + self.view.frame.origin.y < kMin)
	{
		[self setViewMovedUp:NO];
	}
	
}

- (void)keyboardWillHide:(NSNotification *)notif
{
	//	if (self.view.frame.origin.y < 0 ) {
	//		[self setViewMovedUp:NO];
	//	}
}


- (void)viewWillAppear:(BOOL)animated
{
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
	// unregister for keyboard notifications while not visible.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
