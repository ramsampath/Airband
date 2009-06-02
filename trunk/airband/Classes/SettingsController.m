//
//  SettingsController.m
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <Security/Security.h>
#import "SettingsController.h"
#import "appdata.h"
#import "airbandAppDelegate.h"


@implementation SettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		if (self)
		{
			self.title = NSLocalizedString(@"MP3Tunes.COM", @"");

		}
		
	}
	return self;
}


- (void)viewDidLoad 
{
	AppData *app = [AppData get];
	if( !app ) {
		printf( "couldn't get app? in settings controller\n" );
		return;
	}
	
	
	UINavigationBar *bar = [self navigationController].navigationBar;
	bar.barStyle = UIBarStyleBlackOpaque;;
	
	username_.text = app.username_;
	password_.text = app.password_;
	
	/*	
	 OSStatus status;
	 
	 
	 #if TARGET_IPHONE_SIMULATOR
	 if( 0 )
	 {
	 const char *serverName = "mp3tunes";
	 const char *accountName = "testuser";
	 const char *path = "/";
	 UInt32  passwordLength;
	 void *passwordData;
	 status = SecKeychainFindInternetPassword (
	 NULL,  // default, CFTypeRef keychainOrArray,
	 strlen(serverName),
	 serverName,
	 0, //securityDomainLength,
	 0, //const char *securityDomain,
	 strlen(accountName),
	 accountName,
	 strlen(path),
	 path,
	 0,  //port,
	 kSecProtocolTypeHTTPS,
	 kSecAuthenticationTypeDefault,
	 &passwordLength,
	 &passwordData,
	 NULL  //SecKeychainItemRef *itemRef
	 );	
	 
	 if (status != noErr) {
	 NSError *err = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
	 NSLog(@"status %d from SecKeychainSearchCreateFromAttributes:%@\n", status, [err localizedDescription]);
	 }
	 }
	 
	 if( 0 )
	 {
	 //CFTypeID keychainID = SecKeychainSearchGetTypeID();	
	 [SettingsController addKeychainItem:@"username" withItemKind:@"kind" forUsername:@"testuser" withPassword:@"pass123"];
	 
	 SecKeychainSearchRef  searchRef=NULL;
	 status = SecKeychainSearchCreateFromAttributes(NULL, kSecInternetPasswordItemClass, 
	 NULL, //const SecKeychainAttributeList *attrList, 
	 &searchRef);
	 
	 if (status != noErr) {
	 printf ("status %d from "
	 "SecKeychainSearchCreateFromAttributes\n",
	 status);
	 }
	 }
	 #else	
	 
	 static const UInt8 kKeychainIdentifier[]    = "com.apple.dts.KeychainUI\0";
	 
	 NSMutableDictionary* passwdquery = [[NSMutableDictionary alloc] init];
	 
	 // class key
	 [passwdquery setObject:(id)kSecClassInternetPassword forKey:(id)kSecClass];
	 //[passwdquery setObject:(id)kSecAttrProtocolHTTPS forKey:<#(id)aKey#>];
	 NSData *keychainType = [NSData dataWithBytes:kKeychainIdentifier length:strlen((const char *)kKeychainIdentifier)];
	 [passwdquery setObject:keychainType forKey:(id)kSecAttrGeneric];
	 
	 // Use the proper search constants, return only the attributes of the first match.
	 [passwdquery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	 [passwdquery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	 
	 NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:passwdquery];
	 
	 NSMutableDictionary *outDictionary = nil;	
	 status = SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary);
	 if( status == noErr)
	 {
	 // Stick these default values into Keychain if nothing found.
	 //[self resetKeychainItem];
	 }
	 else
	 {
	 // load the saved data from Keychain.
	 //NSMutableDictionary *keychainData = [self secItemFormatToDictionary:outDictionary];
	 }
	 [outDictionary release];
	 #endif
	 */
}



-(UITableViewCell*) create_Cell:(NSString *)labelName frame:(CGRect) labelframe 
					textframe:(CGRect) textframe 
					index:(int) index
{
	AppData *app = [AppData get];
	if( !app ) {
		printf( "couldn't get app? in settings controller\n" );
		return nil;
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:labelframe];
	label.adjustsFontSizeToFitWidth = YES;
	label.lineBreakMode = UILineBreakModeTailTruncation;
	label.multipleTouchEnabled = NO;
	label.numberOfLines = 1;
	label.opaque = NO;
	label.shadowOffset = CGSizeMake(0.0, -1.0);
	label.tag = 0;
	label.text = labelName;
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
	label.userInteractionEnabled = NO;
	label.font = [UIFont systemFontOfSize:14.0];

	
	UITextField *textfield = [[UITextField alloc] initWithFrame:textframe];
	textfield.adjustsFontSizeToFitWidth = NO;
	textfield.alpha = 1.000;
	textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textfield.autocorrectionType = UITextAutocorrectionTypeNo;
	textfield.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	textfield.borderStyle = UITextBorderStyleNone;
	textfield.clearsContextBeforeDrawing = NO;
	textfield.clearsOnBeginEditing = NO;
	textfield.clipsToBounds = NO;
	textfield.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	textfield.contentMode = UIViewContentModeScaleToFill;
	textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textfield.enabled = YES;
	textfield.enablesReturnKeyAutomatically = NO;
	textfield.hidden = NO;
	textfield.highlighted = NO;
	textfield.keyboardAppearance = UIKeyboardAppearanceDefault;
	textfield.keyboardType = UIKeyboardTypeDefault;
	textfield.minimumFontSize = 17.000;
	textfield.multipleTouchEnabled = NO;
	textfield.opaque = NO;
	textfield.placeholder = @"Required";
	textfield.returnKeyType = UIReturnKeyDone;
	textfield.secureTextEntry = NO;
	textfield.selected = NO;
	textfield.tag = 112;
	textfield.text = @"";
	textfield.textAlignment = UITextAlignmentLeft;
	textfield.userInteractionEnabled = YES;
	textfield.font = [UIFont systemFontOfSize:14.0];

	if( index == 0 )  {
		username_ = textfield;
	}
	else {
		password_ = textfield;
		password_.secureTextEntry = TRUE;
	}
	textfield.delegate = self;
	
	UITableViewCell *tablecell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0) reuseIdentifier:(nil)];
	tablecell.frame            = CGRectMake(0.0, 0.0, 320.0, 44.0);
	tablecell.accessoryType    = UITableViewCellAccessoryNone;
	tablecell.alpha            = 1.000;
	tablecell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	tablecell.backgroundColor  = [UIColor colorWithWhite:1.000 alpha:0.000];
	tablecell.clearsContextBeforeDrawing = NO;
	tablecell.clipsToBounds   = NO;
	tablecell.contentMode     = UIViewContentModeScaleToFill;
	tablecell.hidden          = NO;
#ifdef __IPHONE_3_0	
	// [todo] -- not sure what this should be.
#else
	tablecell.hidesAccessoryWhenEditing = YES;
#endif

	tablecell.indentationLevel          = 0;
	tablecell.indentationWidth          = 10.000;
	tablecell.multipleTouchEnabled      = NO;
	tablecell.opaque                    = NO;
#ifdef __IPHONE_3_0	
	tablecell.textLabel.lineBreakMode   = UILineBreakModeTailTruncation;
	tablecell.textLabel.highlightedTextColor = [UIColor colorWithWhite:1.000 alpha:1.000];
#else
	tablecell.lineBreakMode             = UILineBreakModeTailTruncation;
	tablecell.selectedTextColor         = [UIColor colorWithWhite:1.000 alpha:1.000];
#endif
	
	tablecell.selectionStyle            = UITableViewCellSelectionStyleNone;
	tablecell.showsReorderControl       = NO;
	tablecell.tag                       = 0;
#ifdef __IPHONE_3_0	
	tablecell.textLabel.textAlignment   = UITextAlignmentLeft;
	tablecell.textLabel.textColor       = [UIColor colorWithWhite:0.000 alpha:1.000];
#else
	tablecell.textAlignment             = UITextAlignmentLeft;
	tablecell.textColor                 = [UIColor colorWithWhite:0.000 alpha:1.000];
#endif
	
	[tablecell addSubview:label];
	[tablecell addSubview:textfield];
	
	
	return tablecell;
}	



- (void)selectbitrate:(id)sender
{
	UISegmentedControl *segControl = sender;
	AppData *app = [AppData get];	

	switch (segControl.selectedSegmentIndex) 
	{
		case 0:
			[app setStreamingRate:24000];
			break;
		case 1:	
			[app setStreamingRate:56000];
			break;
		case 2: 
			[app setStreamingRate:96000];
			break;
		case 3:	
			[app setStreamingRate:128000];
			break;
		case 4:	
			[app setStreamingRate:192000];
			break;
	}
}


- (void)selectautologin:(id)sender
{
    UISegmentedControl *alcontrol = sender;
	AppData *app = [AppData get];	
    
	if (alcontrol.selectedSegmentIndex == 1)  {
        [app setAutoLogin_:true];
    }
    else {
        [app setAutoLogin_:false];
    }
}

-(UISegmentedControl *) create_streamingBitrateButtons
{
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"28k", @"56k", @"96k", @"128k", @"192k", nil];

	UISegmentedControl *sbrButtons = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	
	CGRect frame = CGRectMake( 127, 200, 180, 30);
	
	AppData *app = [AppData get];	

	sbrButtons.frame                 = frame;
	sbrButtons.segmentedControlStyle = UISegmentedControlStyleBar;

	if( app != nil ) {
		switch( [app bitRate_ ] ) {
			case 28000: 
				sbrButtons.selectedSegmentIndex = 0;
				break;
			case 56000:
				sbrButtons.selectedSegmentIndex = 1;
				break;
			case 96000:
				sbrButtons.selectedSegmentIndex = 2;
				break;
			case 128000:
				sbrButtons.selectedSegmentIndex = 3;
				break;
			case 192000:
				sbrButtons.selectedSegmentIndex = 4;
				break;
		}
	}
    else
        sbrButtons.selectedSegmentIndex = 1;
	
	sbrButtons.tintColor  = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
	
	[sbrButtons addTarget:self action:@selector(selectbitrate:) forControlEvents:UIControlEventValueChanged];
	
	return sbrButtons;
}


-(UISegmentedControl *) create_autoLoginButtons
{
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Off", @"On", nil];
    
	UISegmentedControl *alButtons = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	
	CGRect frame = CGRectMake( 127, 260, 180, 30);
	
	AppData *app = [AppData get];	
    
	alButtons.frame                 = frame;
	alButtons.segmentedControlStyle = UISegmentedControlStyleBar;
    
	if( app != nil ) {
		if( [app autoLogin_ ] ) {
            alButtons.selectedSegmentIndex = 1;
		}
        else {
            alButtons.selectedSegmentIndex = 0;
        }

	}
    else
        alButtons.selectedSegmentIndex = 1;
	
	alButtons.tintColor  = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
	
	[alButtons addTarget:self action:@selector(selectautologin:) forControlEvents:UIControlEventValueChanged];
	
	return alButtons;
}



- (UIButton *)buttonWithTitle:	(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
						imagePressed:(UIImage *)imagePressed
						darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


- (UIButton *)create_ButtonWithImage:(NSString *)name
							  frame:(CGRect)frame

{	
	// create the UIButtons with various background images
	UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	
	UIButton *grayButton = [self buttonWithTitle:name
								frame:frame
								image:buttonBackground
								imagePressed:buttonBackgroundPressed
								darkTextColor:YES];
	
	grayButton.adjustsImageWhenDisabled = YES;
	grayButton.adjustsImageWhenHighlighted = YES;
	grayButton.alpha = 1.000;
	grayButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	grayButton.clearsContextBeforeDrawing = NO;
	grayButton.clipsToBounds = NO;
	grayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	grayButton.contentMode = UIViewContentModeScaleToFill;
	grayButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	grayButton.enabled = YES;
#ifdef __IPHONE_3_0	
	grayButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
#else
	grayButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
#endif
	
	grayButton.hidden = NO;
	grayButton.highlighted = NO;
	grayButton.multipleTouchEnabled = NO;
	grayButton.opaque = NO;
	grayButton.reversesTitleShadowWhenHighlighted = NO;
	grayButton.selected = NO;
	grayButton.showsTouchWhenHighlighted = NO;
	grayButton.tag = 0;
	grayButton.userInteractionEnabled = YES;
	
	[grayButton setTitle:name forState:UIControlStateDisabled];
	[grayButton setTitle:name forState:UIControlStateHighlighted];
	[grayButton setTitle:name forState:UIControlStateNormal];
	[grayButton setTitle:name forState:UIControlStateSelected];
	[grayButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[grayButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[grayButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[grayButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	
	return grayButton;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.title = NSLocalizedString(@"Settings", @"");

	table_ = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    table_.delegate   = self;
    table_.dataSource = self;
    table_.backgroundColor       = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd.png"]];

    //table_.sectionHeaderHeight = 20.0;
    //table_.rowHeight = 40.0;
    CGRect titleRect = CGRectMake( 0, 20, 300, 40 );
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
	
    tableTitle.textColor       = [UIColor whiteColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque          = YES;
    tableTitle.font            = [UIFont boldSystemFontOfSize:16];
	tableTitle.textAlignment   = UITextAlignmentCenter;
    tableTitle.text            = @"mp3tunes.com";
	
	table_.tableHeaderView = tableTitle;
	
    /*
	CGRect loginframe     = CGRectMake( 220.0, 310.0, 84.0, 37.0 );
	UIButton *loginButton = [self create_ButtonWithImage:@"Login" frame:loginframe];
	[loginButton addTarget:self action:@selector(login:) 
          forControlEvents:UIControlEventTouchUpInside];
	
	CGRect caframe                = CGRectMake( 121.0, 310.0, 84.0, 37.0 );
	UIButton *createAccountButton = [self create_ButtonWithImage:@"Create" frame:caframe];
	[createAccountButton addTarget:self action:@selector(createAccount) 
                  forControlEvents:UIControlEventTouchUpInside];

	CGRect clearframe     = CGRectMake( 15.0, 310, 84.0, 37.0 );
	UIButton *clearButton = [self create_ButtonWithImage:@"Clear" frame:clearframe];
	[clearButton addTarget:self action:@selector(clearEverything:) 
          forControlEvents:UIControlEventTouchUpInside];
    */
	CGRect usernameframe     = CGRectMake( 20.0, 6.0, 214.0, 31.0 );
	CGRect usernametextframe = CGRectMake( 120.0, 6.0, 214.0, 31.0 );
	usernamecell_ = [self create_Cell:@"User Name:" 
                                frame:usernameframe textframe:usernametextframe index:0];

	CGRect passwordfieldframe = CGRectMake( 120.0, 6.0, 214.0, 31.0 );
	CGRect passwordlabelframe = CGRectMake( 20.0, 6.0, 214.0, 31.0 );
	passwordcell_ = [self create_Cell:@"Password:" frame:passwordlabelframe 
                            textframe:passwordfieldframe index:1];
	
	UISegmentedControl *sbrButtons = [self create_streamingBitrateButtons];
	UILabel *sbrLabel              = [[[UILabel alloc] init] autorelease];
    sbrLabel.frame                 = CGRectMake( 15, 200, 200, 30);
	sbrLabel.textAlignment         = UITextAlignmentLeft;
    sbrLabel.text                  = @"Stream Rate";
    sbrLabel.font                  = [UIFont boldSystemFontOfSize:14.0];
    sbrLabel.textColor             = [UIColor whiteColor];
    sbrLabel.backgroundColor       = [UIColor clearColor];
    
    UISegmentedControl *alButtons  = [self create_autoLoginButtons];
    UILabel *alLabel               = [[[UILabel alloc] init] autorelease];
    alLabel.frame                  = CGRectMake( sbrLabel.frame.origin.x, alButtons.frame.origin.y + 5, 
                                                alButtons.frame.size.width, alButtons.frame.size.height );
    alLabel.textAlignment          = UITextAlignmentLeft;
    alLabel.text                   = @"Auto Login";
    alLabel.font                   = [UIFont boldSystemFontOfSize:14.0];
    alLabel.textColor              = [UIColor whiteColor];
    alLabel.backgroundColor        = [UIColor clearColor];
	
	UIView *mainview               = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 367.0)];
	mainview.frame                 = CGRectMake(0.0, 0.0, 320.0, 367.0);
	mainview.alpha                 = 1.000;
	mainview.autoresizingMask      = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	//mainview.backgroundColor       = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.000];
    mainview.backgroundColor       = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd.png"]];

	mainview.clearsContextBeforeDrawing = YES;
	mainview.clipsToBounds              = NO;
	mainview.contentMode                = UIViewContentModeScaleToFill;

	mainview.hidden                 = NO;
	mainview.multipleTouchEnabled   = NO;
	mainview.opaque                 = YES;
	mainview.tag                    = 0;
	mainview.userInteractionEnabled = YES;
	
    //[tableTitle release];
	//self.view = table_;
	[table_ addSubview:usernamecell_];
	[table_ addSubview:passwordcell_];

	[mainview addSubview:table_];
	//[mainview addSubview:clearButton];
	//[mainview addSubview:loginButton];
	//[mainview addSubview:createAccountButton];
	[mainview addSubview:sbrButtons];
    [mainview addSubview:sbrLabel];

    [mainview addSubview:alButtons];
    [mainview addSubview:alLabel];
	
	
	self.view = mainview;
	
	//[sbrButtons release];

}


#if TARGET_IPHONE_SIMULATOR_FEH
+ (BOOL)addKeychainItem:(NSString *)keychainItemName 
		   withItemKind:(NSString *)keychainItemKind 
			forUsername:(NSString *)username 
		   withPassword:(NSString *)password
{
    SecKeychainSearchRef search;
    OSErr result;
    int numberOfItemsFound = 0;
	
    SecKeychainAttribute attributes[3];
    SecKeychainAttributeList list;
    SecKeychainItemRef item;
    OSStatus status;
	
	int n=0;
	/*
    attributes[n].tag = kSecAccountItemAttr;
    attributes[n].data = strdup( [username cStringUsingEncoding:NSUTF8StringEncoding] );
    attributes[n].length = [username length];
	 ++n;
	*/
	
    attributes[n].tag = kSecDescriptionItemAttr;
    attributes[n].data = strdup( [keychainItemName cStringUsingEncoding:NSUTF8StringEncoding] );
    attributes[n].length = [keychainItemName length];
	++n;
	
    attributes[n].tag = kSecLabelItemAttr;
    attributes[n].data = strdup( [keychainItemKind cStringUsingEncoding:NSUTF8StringEncoding] );
    attributes[n].length = [keychainItemKind length];
	++n;
	
    list.count = n;
    list.attr = attributes;
	
    /* search for matching keychain item*/
    result = SecKeychainSearchCreateFromAttributes(NULL, kSecInternetPasswordItemClass, &list, &search);	
    if (result != noErr) {
        NSLog(@"status %d from SecKeychainSearchCreateFromAttributes\n", result);
    }
	
	while (SecKeychainSearchCopyNext (search, &item) == noErr) {
        numberOfItemsFound++;
    }
	
	NSLog(@"%d items found\n", numberOfItemsFound);
	
    /* Add a new keychain item if one doesn't exist. */
	if(numberOfItemsFound == 0) {
		//SecKeychainItemCreateFromContent finds a duplicate keychain item that SecKeychainSearchCreateFromAttributes missed.
		status = SecKeychainItemCreateFromContent(kSecInternetPasswordItemClass, &list, 
												  [password length], strdup([password cStringUsingEncoding:NSUTF8StringEncoding]), NULL,NULL,&item);
        if (status != 0) {
            NSLog(@"Error creating new item: %d\n", (int)status);
        }
        //CFRelease (item);
        //CFRelease(search);
        return !status;
	}

	return TRUE;
}
#endif


-(IBAction) setPassword
{
}

-(IBAction) setUsername
{
}

-(IBAction) clearEverything
{
	[username_ setText:@""];
	[password_ setText:@""];
	
	AppData *app = [AppData get];	
	app.password_ = password_.text;
	app.username_ = username_.text;	
}

-(IBAction) createAccount
{
	AppData *app = [AppData get];
	NSDictionary *userinfo = [[NSDictionary 
							   dictionaryWithObjects:[NSArray arrayWithObjects:username_.text, password_.text, nil]
							   forKeys:[NSArray arrayWithObjects:@"username", @"password", nil]] retain];

	[app createAccount:userinfo];
	
	[userinfo release];
	return;
}


-(IBAction) login
{
	AppData *app = [AppData get];	
    
	app.password_ = password_.text;
	app.username_ = username_.text;
	[app login];
	
	[password_ resignFirstResponder];		
	[username_ resignFirstResponder];
	
	airbandAppDelegate *airband = (airbandAppDelegate*) ([UIApplication sharedApplication].delegate);		
	airband.tabBarController.selectedIndex = 0;
}


- (BOOL)textFieldShouldReturn:(UITextField *)thetextField 
{
	[thetextField resignFirstResponder];
	return YES;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
		return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if( section == 0 )
		return 2;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	switch( indexPath.row ) {
		case 0:
			if (indexPath.section == 0) {
				return usernamecell_;
			} 
		case 1:
			return passwordcell_;
			break;
		default:
			break;
	}
	
	return nil;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{		
	return TRUE;
}



- (void)textFieldDidEndEditing:(UITextField *)textField 
{
	[textField resignFirstResponder];

}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
	[super dealloc];
}


@end
