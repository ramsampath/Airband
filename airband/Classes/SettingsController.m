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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		if (self)
		{
			self.title = NSLocalizedString(@"MP3Tunes.COM", @"");

		}
		
	}
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	/*
	table_ = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    table_.delegate = self;
    table_.dataSource = self;
    table_.sectionHeaderHeight = 20.0;
    table_.rowHeight = 40.0;
    CGRect titleRect = CGRectMake( 0, 0, 300, 40 );
	
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
	
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
	tableTitle.textAlignment = UITextAlignmentCenter;
    tableTitle.text = @"Login";
	
	table_.tableHeaderView = tableTitle;
	*/
	
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	loginButton.frame = CGRectMake(201.0, 243.0, 101.0, 37.0);
	loginButton.adjustsImageWhenDisabled = YES;
	loginButton.adjustsImageWhenHighlighted = YES;
	loginButton.alpha = 1.000;
	loginButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	loginButton.clearsContextBeforeDrawing = NO;
	loginButton.clipsToBounds = NO;
	loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	loginButton.contentMode = UIViewContentModeScaleToFill;
	loginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	loginButton.enabled = YES;
	loginButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.000];
	loginButton.hidden = NO;
	loginButton.highlighted = NO;
	loginButton.multipleTouchEnabled = NO;
	loginButton.opaque = NO;
	loginButton.reversesTitleShadowWhenHighlighted = NO;
	loginButton.selected = NO;
	loginButton.showsTouchWhenHighlighted = NO;
	loginButton.tag = 0;
	loginButton.userInteractionEnabled = YES;
	[loginButton setTitle:@"Login" forState:UIControlStateDisabled];
	[loginButton setTitle:@"Login" forState:UIControlStateHighlighted];
	[loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[loginButton setTitle:@"Login" forState:UIControlStateSelected];
	[loginButton setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[loginButton setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[loginButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[loginButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[loginButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[loginButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[loginButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[loginButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[loginButton addTarget:self	action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
	
	UITextField *loginField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 94.0, 280.0, 31.0)];
	loginField.frame = CGRectMake(15.0, 94.0, 280.0, 31.0);
	loginField.adjustsFontSizeToFitWidth = YES;
	loginField.alpha = 1.000;
	loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	loginField.autocorrectionType = UITextAutocorrectionTypeNo;
	loginField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	loginField.borderStyle = UITextBorderStyleRoundedRect;
	loginField.clearsContextBeforeDrawing = NO;
	loginField.clearsOnBeginEditing = YES;
	loginField.clipsToBounds = NO;
	loginField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	loginField.contentMode = UIViewContentModeScaleToFill;
	loginField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	loginField.enabled = YES;
	loginField.enablesReturnKeyAutomatically = YES;
	loginField.font = [UIFont fontWithName:@"Helvetica" size:12.000];
	loginField.hidden = NO;
	loginField.highlighted = NO;
	loginField.keyboardAppearance = UIKeyboardAppearanceDefault;
	loginField.keyboardType = UIKeyboardTypeDefault;
	loginField.minimumFontSize = 17.000;
	loginField.multipleTouchEnabled = NO;
	loginField.opaque = NO;
	loginField.placeholder = @"email address (for mp3tunes.com)";
	loginField.returnKeyType = UIReturnKeyNext;
	loginField.secureTextEntry = NO;
	loginField.selected = NO;
	loginField.tag = 0;
	loginField.text = @"";
	loginField.textAlignment = UITextAlignmentLeft;
	loginField.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
	loginField.userInteractionEnabled = YES;
	
	UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 191.0, 280.0, 31.0)];
	passwordField.frame = CGRectMake(15.0, 191.0, 280.0, 31.0);
	passwordField.adjustsFontSizeToFitWidth = YES;
	passwordField.alpha = 1.000;
	passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	passwordField.borderStyle = UITextBorderStyleRoundedRect;
	passwordField.clearsContextBeforeDrawing = NO;
	passwordField.clearsOnBeginEditing = YES;
	passwordField.clipsToBounds = NO;
	passwordField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	passwordField.contentMode = UIViewContentModeScaleToFill;
	passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	passwordField.enabled = YES;
	passwordField.enablesReturnKeyAutomatically = YES;
	passwordField.font = [UIFont fontWithName:@"Helvetica" size:12.000];
	passwordField.hidden = NO;
	passwordField.highlighted = NO;
	passwordField.keyboardAppearance = UIKeyboardAppearanceDefault;
	passwordField.keyboardType = UIKeyboardTypeDefault;
	passwordField.minimumFontSize = 17.000;
	passwordField.multipleTouchEnabled = NO;
	passwordField.opaque = NO;
	passwordField.placeholder = @"password (for mp3tunes.com)";
	passwordField.returnKeyType = UIReturnKeyDone;
	passwordField.secureTextEntry = YES;
	passwordField.selected = NO;
	passwordField.tag = 0;
	passwordField.text = @"";
	passwordField.textAlignment = UITextAlignmentLeft;
	passwordField.textColor = [UIColor colorWithWhite:0.000 alpha:1.000];
	passwordField.userInteractionEnabled = YES;
	
	UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 367.0)];
	mainview.frame = CGRectMake(0.0, 0.0, 320.0, 367.0);
	mainview.alpha = 1.000;
	mainview.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	mainview.backgroundColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.000];
	mainview.clearsContextBeforeDrawing = YES;
	mainview.clipsToBounds = NO;
	mainview.contentMode = UIViewContentModeScaleToFill;
	mainview.hidden = NO;
	mainview.multipleTouchEnabled = NO;
	mainview.opaque = YES;
	mainview.tag = 0;
	mainview.userInteractionEnabled = YES;
	
	UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(117.0, 162.0, 75.0, 21.0)];
	passwordLabel.frame = CGRectMake(117.0, 162.0, 75.0, 21.0);
	passwordLabel.adjustsFontSizeToFitWidth = YES;
	passwordLabel.alpha = 1.000;
	passwordLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	passwordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	passwordLabel.clearsContextBeforeDrawing = YES;
	passwordLabel.clipsToBounds = YES;
	passwordLabel.contentMode = UIViewContentModeScaleToFill;
	passwordLabel.enabled = YES;
	passwordLabel.font = [UIFont fontWithName:@"Helvetica" size:17.000];
	passwordLabel.hidden = NO;
	passwordLabel.lineBreakMode = UILineBreakModeTailTruncation;
	passwordLabel.minimumFontSize = 10.000;
	passwordLabel.multipleTouchEnabled = NO;
	passwordLabel.numberOfLines = 1;
	passwordLabel.opaque = NO;
	passwordLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	passwordLabel.tag = 0;
	passwordLabel.text = @"Password";
	passwordLabel.textAlignment = UITextAlignmentLeft;
	passwordLabel.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
	passwordLabel.backgroundColor = [UIColor clearColor];
	passwordLabel.userInteractionEnabled = NO;
	
	UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0, 65.0, 79.0, 21.0)];
	usernameLabel.frame = CGRectMake(115.0, 65.0, 79.0, 21.0);
	usernameLabel.adjustsFontSizeToFitWidth = YES;
	usernameLabel.alpha = 1.000;
	usernameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	usernameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	usernameLabel.clearsContextBeforeDrawing = YES;
	usernameLabel.clipsToBounds = YES;
	usernameLabel.contentMode = UIViewContentModeScaleToFill;
	usernameLabel.enabled = YES;
	usernameLabel.font = [UIFont fontWithName:@"Helvetica" size:17.000];
	usernameLabel.hidden = NO;
	usernameLabel.lineBreakMode = UILineBreakModeTailTruncation;
	usernameLabel.minimumFontSize = 10.000;
	usernameLabel.multipleTouchEnabled = NO;
	usernameLabel.numberOfLines = 1;
	usernameLabel.opaque = NO;
	usernameLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	usernameLabel.tag = 0;
	usernameLabel.text = @"Username";
	usernameLabel.textAlignment = UITextAlignmentLeft;
	usernameLabel.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
	usernameLabel.backgroundColor = [UIColor clearColor];
	usernameLabel.userInteractionEnabled = NO;
	
	UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	clearButton.frame = CGRectMake(15.0, 243.0, 94.0, 37.0);
	clearButton.adjustsImageWhenDisabled = YES;
	clearButton.adjustsImageWhenHighlighted = YES;
	clearButton.alpha = 1.000;
	clearButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	clearButton.clearsContextBeforeDrawing = NO;
	clearButton.clipsToBounds = NO;
	clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	clearButton.contentMode = UIViewContentModeScaleToFill;
	clearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	clearButton.enabled = YES;
	clearButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.000];
	clearButton.hidden = NO;
	clearButton.highlighted = NO;
	clearButton.multipleTouchEnabled = NO;
	clearButton.opaque = NO;
	clearButton.reversesTitleShadowWhenHighlighted = NO;
	clearButton.selected = NO;
	clearButton.showsTouchWhenHighlighted = NO;
	clearButton.tag = 0;
	clearButton.userInteractionEnabled = YES;
	[clearButton setTitle:@"Clear" forState:UIControlStateDisabled];
	[clearButton setTitle:@"Clear" forState:UIControlStateHighlighted];
	[clearButton setTitle:@"Clear" forState:UIControlStateNormal];
	[clearButton setTitle:@"Clear" forState:UIControlStateSelected];
	[clearButton setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[clearButton setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[clearButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[clearButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[clearButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[clearButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[clearButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[clearButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	
	[mainview addSubview:passwordField];
	[mainview addSubview:clearButton];
	[mainview addSubview:loginButton];
	[mainview addSubview:passwordLabel];
	[mainview addSubview:usernameLabel];
	[mainview addSubview:loginField];	
	
    //[tableTitle release];
	//self.view = table_;
	self.view = mainview;
}


#if TARGET_IPHONE_SIMULATOR
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


- (BOOL)textFieldShouldReturn:(UITextField *)thetextField {
	[thetextField resignFirstResponder];
	return YES;
}


- (void)viewDidLoad {
	printf	("Loaded\n");
	AppData *app = [AppData get];
	if( !app ) {
		printf( "couldn't get app? in settings controller\n" );
		return;
	}
	
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
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
