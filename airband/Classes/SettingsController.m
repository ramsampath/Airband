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
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */


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
