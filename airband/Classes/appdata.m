
#import "airbandAppDelegate.h"   // for access to global AppData
#import "xmlhelp.h"
#import "audiohelp.h"
#import "SimpleIO.h"


#pragma mark	-
#pragma mark	AppData
#pragma mark	-

static asyncIO *g_async = nil;
//static NSString *partner_token = @"8560950360";
static NSString *partner_token = @"3110321588";
static audiohelp_II *g_audio = nil;

// mp3 tunes API:
// http://www.mp3tunes.com/api/doc/apiv1
// static const char *mp3api = "http://ws.mp3tunes.com/api/v1/lockerData?output=xml";



@implementation AppData

@synthesize fullArtistList_;
@synthesize username_;
@synthesize password_;
@synthesize sessionID_;
@synthesize artwork_;
@synthesize playLists_;
@synthesize currentTracklist_;
@synthesize albumList_;
@synthesize trackList_;
@synthesize currentTrackTitle_;
@synthesize currentArtist_;
@synthesize currentAlbum_;
@synthesize currentTrackIndex_;
@synthesize currentAlbumTrackIndex_;
@synthesize currentTrackLength_;
@synthesize currentTrackFileSize_;
@synthesize bitRate_;
@synthesize lastVolume_;
@synthesize autoLogin_;
@synthesize albumArtCache_;
@synthesize startpage_;
@synthesize images_;
@synthesize coverflowDisplayType_;
@synthesize albumartimages_;
@synthesize albumHistory_;
@synthesize albumIndexHistory_;

// --------------------------------------------------------------------------
// singelton
// --------------------------------------------------------------------------
+(AppData*) get
{
    airbandAppDelegate *airband = (airbandAppDelegate*) ([UIApplication sharedApplication].delegate);	
    return airband.appdata_;
}



// --------------------------------------------------------------------------
// constructor
// --------------------------------------------------------------------------
-(id) init
{
	if( self = [super init] )
	{
        username_             = nil;
        password_             = nil;
        sessionID_            = nil;
        fullArtistList_       = nil;
        albumInRequest_       = nil;
        artwork_              = nil;
        artworkdata_          = nil;
        currentTracklist_     = nil;
        albumList_            = nil;
        trackList_            = nil;
        currentTrackTitle_    = nil;
        currentAlbum_         = nil;
        currentArtist_        = nil;
        bitRate_              = 56000;
        lastVolume_		      = 1;
        albumArtCache_        = [[imagecache alloc] retain];
        images_               = [[NSMutableArray arrayWithCapacity:50] retain];
        autoLogin_            = true;
        albumartimages_       = [[NSMutableArray arrayWithCapacity:50] retain];
        coverflowDisplayType_ = 0; // type albumart
        albumHistory_         = [[NSMutableDictionary alloc] init];
        albumIndexHistory_    = [[NSMutableDictionary alloc] init];
        // read the user settings.
        [self restoreState];
	}
	
	return self;
}

// --------------------------------------------------------------------------
// destructor 
// --------------------------------------------------------------------------
- (void)dealloc
{
    [self saveState];

    [username_ release];
    [password_ release];
    [sessionID_ release];
    [fullArtistList_ release];
    [albumInRequest_ release];
    [artwork_ release];
    [artworkdata_ release];
    [currentTracklist_ release];
    [albumList_ release];
    [trackList_ release];
    [currentTrackTitle_ release];
    [currentArtist_ release];
    [currentAlbum_ release];
    [albumArtCache_ release];
    [albumartimages_ release];
    [albumHistory_ release];
    [albumIndexHistory_ release];
    [super dealloc];
}


// --------------------------------------------------------------------------
// get a typical <item> list from xml data.
// --------------------------------------------------------------------------
-(NSArray*) parseItemList:(NSData*)data
{
    NSXMLParser * parser = [[[NSXMLParser alloc] initWithData:data] autorelease];	
    XMLParseItemList* parseDelegate = [[[XMLParseItemList alloc] init] autorelease];	
    [parser setDelegate:parseDelegate];
    [parser parse];	
	
    NSArray *a = [[NSArray arrayWithArray:parseDelegate.itemList_] retain];			
    return a;
}


// --------------------------------------------------------------------------
// helper for image data
// --------------------------------------------------------------------------
static void myProviderReleaseData (void *info,const void *data,size_t size)
{
    NSData *d = info;
    [d release];
}

// --------------------------------------------------------------------------
// callback from async
// --------------------------------------------------------------------------
-(void) dataReady:(NSData*)data  userdata:(id)userdata
{
	NSString *which = userdata;
	
	//printf( "----------- dataReady:%s\n", [which UTF8String] );
	
    if( [which isEqualToString:@"login"] )
    {
        NSXMLParser * parser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
        XMLParseSimpleElement* parseDelegate = [[[XMLParseSimpleElement alloc] init] autorelease];	
        parseDelegate.search_ = @"session_id";	
        [parser setDelegate:parseDelegate];
        [parser parse];	
		
        // save the session id.
        sessionID_ = [[NSString stringWithString:parseDelegate.found_] retain];

        if( [sessionID_ length] < 4 ) {
            [sessionID_ release];
            sessionID_ = nil;			
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginFAIL" object:nil];				
            return;
        }
		
        if (sessionID_) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:nil];
        }
    }
    else if( [which isEqualToString:@"artistList"] )
	{
		[fullArtistList_ release];
		fullArtistList_ = [self parseItemList:data];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"artistListReady" object:nil];								
	}
	else if( [which isEqualToString:@"playLists"] )
	{		
		[playLists_ release];
		playLists_ = [self parseItemList:data];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playListsReady" object:nil];		
	}		
	else if( [which isEqualToString:@"albumList"] )
	{		
		[albumList_ release];
		NSArray *a = [self parseItemList:data];
		albumList_ = a;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"albumListReady" object:nil];		
		//printf( "albumList size:%d\n", [a count] );
		[self gotAlbumList:a];
        //[self getAlbumlistArtwork:a];
	}		
	else if( [which isEqualToString:@"trackList"] )
	{
		[trackList_ release];
		NSArray *a = [self parseItemList:data];		
		trackList_ = a;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"trackListReady" object:nil];		
		//[self gotTrackList:a];
    }
    else if( [which isEqualToString:@"playlistTracks"] )
    {
		[currentTracklist_ release];
		NSArray *a = [self parseItemList:data];
		currentTracklist_ = a;
        //
        // [NOTE] the following added by ram to make the nowplaying display
        // the playlist's tracks and not from the artist. - dont know if it will cause other problems
        //
        trackList_ = currentTracklist_;
        // end of additions
		//printf( "playlistTracks: %d items\n", [a count] );
		//[self gotPlaylistTracks:a];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playListTracksReady" object:nil];				
	}
	else if( [which isEqualToString:@"artwork"] )
	{			
		if( [data length] > 100 )
		{			
			[artworkdata_ release];
			artworkdata_ = [[NSData dataWithData:data] retain];
			CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, [artworkdata_ bytes], [artworkdata_ length], 
																	           myProviderReleaseData );
			CGImageRef imageref = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);						
			if( imageref ) {
				[artwork_ release];
				CGImageRetain(imageref);			
				artwork_ = [[UIImage imageWithCGImage:imageref] retain];			
				[[NSNotificationCenter defaultCenter] postNotificationName:@"artworkReady" object:artwork_];						
				CGDataProviderRelease(provider);				
				CGImageRelease(imageref);				
			}			
		}
	}
	else
	{
		//printf("WTF -- unknown callback:%s\n", [which UTF8String] );
	}
	
}

-(void) failed:(id)userdata error:(NSError*)error
{
	[[[UIAlertView alloc] initWithTitle:@"Connection Problem" 
								message:[error localizedDescription] 
							   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
	
	// [todo] -- nsnotification failure.
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFAIL" object:nil];	
}


- (void) getArtistList
{    
	NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];
	[req appendString:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=artist&sid="];
	[req appendString:sessionID_];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"artistList"];
	
	[req release];
};



- (void) getAlbumList
{
    if( [sessionID_ length] < 4 ) {
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" 
									message:@"Bad Session"
								   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        sessionID_ = nil;
        return;
    }
    
	NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];
	[req appendString:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=album&sid="];
	[req appendString:sessionID_];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"albumList"];
};


- (void) getAlbumListAsyn
{
    if( [sessionID_ length] < 4 ) {
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" 
									message:@"Bad Session"
								   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        sessionID_ = nil;
        return;
    }
    
	NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];
	[req appendString:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=album&sid="];
	[req appendString:sessionID_];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"albumList"];
};


- (void) getPlayListsAsync
{
	NSMutableString *req = [NSMutableString stringWithString:
							[NSString stringWithFormat:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=playlist&sid=%@", 
							 sessionID_ ]];
		
	//[busyIndicator startAnimating];			
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"playLists"];
}	


- (void) getAlbumListAsync:(NSString*)artist_id
{
	NSMutableString *req = [NSMutableString stringWithString:
							[NSString stringWithFormat:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=album&artist_id=%@&sid=%@", 
							 artist_id, sessionID_ ]];
		
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"albumList"];
}	

- (void) getTrackListAsync:(NSString*)album_id
{
	NSMutableString *req = [NSMutableString stringWithString:
							[NSString stringWithFormat:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=track&album_id=%@&sid=%@",
							 album_id, sessionID_ ]];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"trackList"];
}	


- (void) getPlayListTracksAsync:(NSString*)playlist_id
{
	NSMutableString *req = [NSMutableString stringWithString:
							[NSString stringWithFormat:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=track&playlist_id=%@&sid=%@",
							 playlist_id, sessionID_ ]];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"playlistTracks"];
}	




- (void) gotAlbumList:(NSArray*)albumlist
{
    NSUInteger numalbums = [albumlist count];
    if( !albumlist || !numalbums ) {
        [[[UIAlertView alloc] initWithTitle:@"Oh No!" 
                                    message:@"Couldn't get albumlist" 
                                   delegate:nil 
                          cancelButtonTitle:@"ok" 
                          otherButtonTitles:nil] show];
		return;
	}
	
	/*
	NSDictionary *album = [albumlist objectAtIndex:(drand48()*numalbums)];
	albumInRequest_ = [album retain];
	[self getTrackListAsync:[album objectForKey:@"albumId"]];			
     */
}

- (UIImage *)getAlbumArtwork:(NSString *)str
{
	return nil;	
}

- (void) getAlbumListArtwork:(NSArray *)albumlist;
{
    /*
    NSString *req = @"all";

    ConnectionInfo *info = [[ConnectionInfo alloc] init];
    info.address_ = req;
    info.delegate_ = self;
    info.userdata_ = @"main";
    
    [[SimpleIO singelton] request:info];	
    [info release];
    */
    /*
    unsigned num = [albumlist count];
    for( int i = 0;  i < num; ++i ) {
        NSDictionary *album = [albumlist objectAtIndex:i];
        [self getAlbumArtwork:[album objectForKey:@"albumId"]];
    } 
     */
}


- (int) getPlayLength
{
	return 0;
}



-(void) playTrack:(NSDictionary *)track
{
    NSString *playfile  = [track objectForKey:@"playURL"];
    NSString *title     = [track objectForKey:@"trackTitle"];
    NSString *tracksize = [track objectForKey:@"trackFileSize"];
    NSString *tracklen  = [track objectForKey:@"trackLength"];
    NSString *album     = [track objectForKey:@"albumTitle"];
    NSString *artist    = [track objectForKey:@"artistName"];
    NSString *tracknum  = [track objectForKey:@"trackNumber"];
    
    currentTrackFileSize_   = [tracksize floatValue];
    currentTrackLength_     = [tracklen floatValue];
    currentAlbumTrackIndex_ = [tracknum intValue];
    
    if( !playfile ) {
        [[[UIAlertView alloc] initWithTitle:@"Error w/ mp3tunes"
                                    message:@"Couldn't get playfile" 
                                   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        return;
    }
    
    /* - log plays
     */
    
    NSString *loc = [NSString
                     stringWithFormat:@"http://air-band.appspot.com/access?name=%@&artist=%@&album=%@&title=%@",
                     username_, artist, album, title ];
    
    NSString *enc = [loc
                     stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
	if( enc) {
		NSURL    *url = [NSURL URLWithString:enc];
    
		[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url]
									  delegate:self] ;
	} else {
		NSURL    *url = [NSURL URLWithString:loc];
		[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url]
									  delegate:self] ;
	}
		
	/*
	/// -- debug ---
	{	
		NSMutableString *ms = [[NSMutableString stringWithCapacity:10] retain];
		[ms setString:playfile];
		[ms appendString:@"8560950360"];
		
		NSURL *url = [NSURL URLWithString:ms];
		NSData *data = [NSData dataWithContentsOfURL:url];
	
		printf( "song size: %d\n", [data length] );
		
		[data release];
	}
	*/
	// stream it.
	NSMutableString *req = [[NSMutableString stringWithString:playfile] retain];
	[req appendString:partner_token];
	NSString *bitRate = [ NSString stringWithFormat:@"&bitrate=%d", bitRate_ ];
	[req appendString:bitRate];
	
	if( !g_audio ) {
		g_audio = [[[audiohelp_II alloc] init] retain];			
	} else {	
		[g_audio cancel];
	}
	
	
	[g_audio play:req];
	[g_audio setTracksize_:[tracksize intValue]];
	[g_audio setvolume:lastVolume_];
	
	[req release];
	
	// next step -- get artwork.
	NSString *artwork = [track objectForKey:@"albumArtURL"];
	if( artwork ) {
		[g_async loadWithURL:artwork asyncinfo:self asyncdata:@"artwork"];	
	}
	
	
	// someone might want to know...
    currentTrackTitle_ = title;
    currentArtist_     = artist;
    currentAlbum_      = album;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"titleAvailable" object:self userInfo:[track retain]];	
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appPlaying" object:nil];				
}



- (void) gotTrackList:(NSArray*)tracklist
{	
	if( !tracklist ) {
		[[[UIAlertView alloc] initWithTitle:@"Error w/ mp3tunes"
							  message:@"Couldn't get tracklist" 
							  delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];		
		return;
	}
	
	//printf( "gotTrackList: %s\n" , [[albumInRequest_ objectForKey:@"albumTitle"] UTF8String]);
	
	NSUInteger numtracks = [tracklist count];
	NSDictionary *track = [tracklist objectAtIndex:(drand48()*numtracks)];
	
	[self playTrack:track];		
}


-(void) pause
{
	[g_audio pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appPaused" object:nil];				
}

-(void) resume;
{
	[g_audio resume];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appResumed" object:nil];				
}


-(void) stop
{
	[g_async cancel];
	[g_audio cancel];	
}

-(bool) isPlaying
{
    return( ![g_audio paused_] );
}

-(bool) isPaused
{
    return( [g_audio paused_] );
}


-(void) play:(NSDictionary*)artistdictionary
{
	NSString *artist_id = [artistdictionary objectForKey:@"artistId"];
	if( !artist_id )
		return;
		
	// cancel anything in flight.
	[self stop];
	
	// start retrieving new info.
	[self getAlbumListAsync:artist_id];
    
}

-(void) setStreamingRate:(int) rate
{
	bitRate_ = rate;
}

- (void) setvolume:(float)volume
{
	lastVolume_ = volume;
	[g_audio setvolume:volume];
}

- (float) tracklength 
{
    return currentTrackLength_;
}

- (float) percent
{
	return [g_audio percentage];
}

- (float) trackFileSize
{
	return [g_audio percentLoaded]; 
}

- (bool) isrunning
{
	return [g_audio isrunning];
}

- (bool) hasfinished
{
	return [g_audio hasfinished];
}

- (BOOL) login
{
  if( !username_ || !password_ )
	return FALSE;  

  NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];

  [req appendString: @"https://shop.mp3tunes.com/api/v1/login?output=xml" ];  
  [req appendString:[NSString stringWithFormat:@"&partner_token=%@", partner_token]];
  [req appendString:[NSString stringWithFormat:@"&username=%@&password=%@", username_, password_]];

  //printf ("Login Request String: %s\n", [req UTF8String] );
  [self stop];
  [g_async release];
	
  g_async = [[[asyncIO alloc] init] retain];
  [g_async loadWithURL:req asyncinfo:self asyncdata:@"login"];
  [req release];
  return TRUE;	
}


// ---- pass in a dictionary of strings
//      username, password, firstname (optional), lastname (optional)

- (NSString*) createAccount:(NSDictionary*)userinfo
{	
	NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];
	
	NSString *username  = [userinfo objectForKey:@"username"];
	NSString *password  = [userinfo objectForKey:@"password"];
	NSString *firstname = [userinfo objectForKey:@"firstname"];
	NSString *lastname  = [userinfo objectForKey:@"lastname"];
	
	[req appendString: @"https://shop.mp3tunes.com/api/v1/createAccount?output=xml" ];  
	[req appendString:[NSString stringWithFormat:@"&partner_token=%@", partner_token]];
	
	if( [firstname length] && [lastname length] ) {
		[req appendString:[NSString stringWithFormat:@"&email=%@&password=%@&firstname=%@&lastname=%@", 
						   username, password, firstname, lastname]];
	}
	else {
		[req appendString:[NSString stringWithFormat:@"&email=%@&password=%@", 
						   username, password]];
	}
	
	NSString *req2 = [req stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	NSURL *url = [NSURL URLWithString:req2];
	NSData *data = [NSData dataWithContentsOfURL:url];
		
	if(!data) {
		[[[UIAlertView alloc] initWithTitle:@"Account Creation Problem" 
									message:@"Couldn't connect to mp3tunes!"
								   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
		return nil;
	}
	
	
	NSXMLParser * parser = [[[NSXMLParser alloc] initWithData:data] autorelease];	
	
	XMLParseSimpleElement* parseDelegate = [[[XMLParseSimpleElement alloc] init] autorelease];	
	[parser setDelegate:parseDelegate];
	
	parseDelegate.search_ = @"status";
	[parser parse];		
	NSString *status  = [[NSString stringWithString:parseDelegate.found_] retain];
	[parseDelegate reset];
	parseDelegate.search_ = @"errorMessage";
	[parser parse];		
	NSString *errmsg  = [parseDelegate.found_ retain];
		
	if( [status isEqualToString:@"1"] )
	{
		[[[UIAlertView alloc] initWithTitle:@"Account Created!" 
									message:username 
								   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
	}
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"Account Creation Problem" 
									message:errmsg 
								   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
	}
	
	
	return errmsg;
}


// [todo] -- should store password in keychain or whatever the equivalent is for iphone.

#pragma mark	-
#pragma mark		simple state save/restore
#pragma mark	-

- (BOOL)applicationDataToFile:(NSData *)data toFile:(NSString *)fileName 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}


- (NSData*) applicationDataFromFile:(NSString *)fileName 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
	return myData;
}



- (BOOL)writeApplicationPlist:(id)plist toFile:(NSString *)fileName 
{
    NSString *error;
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList:plist 
												 format:NSPropertyListBinaryFormat_v1_0 
												 errorDescription:&error];
    if (!pData) {
        NSLog(@"%@", error);
        return NO;
    }
	
	
    return ([self applicationDataToFile:pData toFile:(NSString *)fileName]);
}


- (id)applicationPlistFromFile:(NSString *)fileName 
{
    NSData *retData;
    NSString *error;
    id retPlist;
    NSPropertyListFormat format;
	
    retData = [self applicationDataFromFile:fileName];
    if (!retData) {
        NSLog(@"Data file not returned.");
        return nil;
    }
    retPlist = [NSPropertyListSerialization propertyListFromData:retData  
												mutabilityOption:NSPropertyListMutableContainersAndLeaves
												format:&format errorDescription:&error];
    if (!retPlist){
        NSLog(@"Plist not returned, error: %@", error);
    }
    return retPlist;
}


#pragma mark	-
#pragma mark		save / restore state
#pragma mark	-


- (void) restoreState
{

    NSDictionary *d = [self applicationPlistFromFile:@"airbandPlist"];  

    [username_ release];
    [password_ release];
	
    //username_   = [[d objectForKey:@"username"] retain];
    //password_   = [[d objectForKey:@"password"] retain];
    if( d )
        lastVolume_ = [[[d objectForKey:@"lastVolume"] retain] floatValue];
    //bitRate_    = [[[d objectForKey:@"bitRate"] retain] intValue];
    //autoLogin_  = [[[d objectForKey:@"autoLogin"] retain] boolValue];
    //coverflowDisplayType_ = [[[d objectForKey:@"albumartstyle"] retain] intValue];
    
    
    //
    // Read the global preferences and set the app preferences 
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSString *loginValue = [defaults stringForKey:@"usernamekey"];
	NSString *passwordValue = [defaults stringForKey:@"passwordkey"];
	BOOL autologinValue = [defaults boolForKey:@"autologinkey"];
	NSInteger streamingRateValue = [defaults integerForKey:@"streamingratekey"];
	NSInteger startpageValue = [defaults integerForKey:@"startpagekey"];
	NSInteger coverflowstyle = [defaults integerForKey:@"albumartstyle"];
    
    username_ = loginValue;
    password_ = passwordValue;
    [self setStreamingRate:streamingRateValue];
    [self setAutoLogin_:autologinValue];
    [self setStartpage_:startpageValue];
    [self setCoverflowDisplayType_:coverflowstyle];
    return;
}


- (void) saveState
{
    //
    // Airband related saved state settings
    //
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:10];
    [d setValue:username_   forKey:@"username"];
    [d setValue:password_   forKey:@"password"];
    
    [d setValue:[NSString stringWithFormat:@"%f", lastVolume_] forKey:@"lastVolume"];
    [d setValue:[NSString stringWithFormat:@"%d", bitRate_] forKey:@"bitRate"];
    [d setValue:[NSString stringWithFormat:@"%d", autoLogin_] forKey:@"autoLogin"];
    [d setValue:[NSString stringWithFormat:@"%d", coverflowDisplayType_] forKey:@"coverflowstyle"];
        
    [self writeApplicationPlist:d toFile:@"airbandPlist"];

    //
    // Write the global settings
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:autoLogin_ forKey:@"autologinkey"];
    [defaults setInteger:bitRate_ forKey:@"streamingratekey"];
    [defaults setInteger:startpage_ forKey:@"startpagekey"];
    [defaults setValue:username_ forKey:@"usernamekey"];
    [defaults setValue:password_ forKey:@"passwordkey"];
    [defaults setInteger:coverflowDisplayType_ forKey:@"coverflowstyle"];
    
    /*
    NSDictionary *appPrerfs = [NSDictionary dictionaryWithObjectsAndKeys:
                               username_, @"autologinkey",
                               password_, @"passworckey",
                               startpage_, @"startpagekey",
                               autoLogin_, @"autologinkey",
                               bitRate_, @"streamingratekey",
                               nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appPrerfs];
*/
    [defaults synchronize];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    return;
}



@end





