
#import "airbandAppDelegate.h"   // for access to global AppData
#import "xmlhelp.h"
#import "audiohelp.h"


#pragma mark	-
#pragma mark	AppData
#pragma mark	-

static asyncIO *g_async = nil;
static NSString *partner_token = @"8560950360";
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
@synthesize currentTrackIndex_;
@synthesize currentTrackLength_;

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
	  username_ = nil;
	  password_ = nil;
	  sessionID_ = nil;
	  fullArtistList_ = nil;
	  albumInRequest_ = nil;
	  artwork_ = nil;
	  currentTracklist_ = nil;
	  albumList_ = nil;
	  trackList_ = nil;
	  currentTrackTitle_ = nil;
	
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
	[currentTracklist_ release];
	[albumList_ release];
	[trackList_ release];
	[currentTrackTitle_ release];
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
// callback from async
// --------------------------------------------------------------------------
-(void) dataReady:(NSData*)data  userdata:(id)userdata
{
	NSString *which = userdata;
	
	printf( "----------- dataReady:%s\n", [which UTF8String] );
	
	if( [which isEqualToString:@"login"] )
	{
		NSXMLParser * parser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
		XMLParseSimpleElement* parseDelegate = [[[XMLParseSimpleElement alloc] init] autorelease];	
		parseDelegate.search_ = @"session_id";	
		[parser setDelegate:parseDelegate];
		[parser parse];	
		
		// save the session id.
		sessionID_ = [[NSString stringWithString:parseDelegate.found_] retain];
				
		// on to the next step
		[self getArtistList];
	}
	else if( [which isEqualToString:@"artistList"] )
	{
		fullArtistList_ = [self parseItemList:data];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"artistListReady" object:nil];								
	}
	else if( [which isEqualToString:@"playLists"] )
	{		
		playLists_ = [self parseItemList:data];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playListsReady" object:nil];		
	}		
	else if( [which isEqualToString:@"albumList"] )
	{		
		[albumList_ release];
		NSArray *a = [self parseItemList:data];
		albumList_ = a;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"albumListReady" object:nil];		
		printf( "albumList size:%d\n", [a count] );
		//[self gotAlbumList:a];		
	}		
	else if( [which isEqualToString:@"trackList"] )
	{
		NSArray *a = [self parseItemList:data];		
		trackList_ = a;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"trackListReady" object:nil];		
		//[self gotTrackList:a];
	}
	else if( [which isEqualToString:@"playlistTracks"] )
	{
		NSArray *a = [self parseItemList:data];
		currentTracklist_ = a;
		printf( "playlistTracks: %d items\n", [a count] );
		//[self gotPlaylistTracks:a];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playListTracksReady" object:nil];				
	}
	else if( [which isEqualToString:@"artwork"] )
	{			
		if( [data length] > 100 )
		{			
			NSData *dup = [[NSData dataWithData:data] retain];
			CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, [dup bytes], [dup length], NULL );
			CGImageRef        imageref = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);						
			if( imageref )
			{
				CGImageRetain(imageref);			
				[artwork_ release];
				artwork_ = [[UIImage imageWithCGImage:imageref] retain];			
				[[NSNotificationCenter defaultCenter] postNotificationName:@"artworkReady" object:artwork_];						
				//CGImageRelease(imageref);				
			}
			
			//[dup release];
		}
	}
	else
	{
		printf("WTF -- unknown callback:%s\n", [which UTF8String] );
	}
	
}

-(void) failed:(id)userdata error:(NSError*)error
{
	[[[UIAlertView alloc] initWithTitle:@"Connection Problem" 
								message:[error localizedDescription] 
							   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
	
	//[busyIndicator stopAnimating];				
	// [todo] -- nsnotification failure.
}


- (void) getArtistList
{
	NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];
	[req appendString:@"http://ws.mp3tunes.com/api/v1/lockerData?output=xml&type=artist&sid="];
	[req appendString:sessionID_];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"artistList"];
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
	
	
	NSDictionary *album = [albumlist objectAtIndex:(drand48()*numalbums)];
	albumInRequest_ = [album retain];
	[self getTrackListAsync:[album objectForKey:@"albumId"]];			
}


- (int) getPlayLength
{
	return 0;
}



-(void) playTrack:(NSDictionary*)track
{
	NSString *playfile  = [track objectForKey:@"playURL"];
	NSString *title     = [track objectForKey:@"trackTitle"];
	NSString *tracksize = [track objectForKey:@"trackFileSize"];
	NSString *tracklen  = [track objectForKey:@"trackLength"];
	
	currentTrackLength_ = [tracklen floatValue];
	if( !playfile ) {
		[[[UIAlertView alloc] initWithTitle:@"Error w/ mp3tunes"
									message:@"Couldn't get playfile" 
								   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
		return;
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
	[req appendString:@"&bitrate=96000"];
	
	if( !g_audio ) {
		g_audio = [[[audiohelp_II alloc] init] retain];			
	} else {	
		[g_audio cancel];
	}
	
	[g_audio play:req];
	[g_audio setTracksize_:[tracksize intValue]];
	
	// next step -- get artwork.
	NSString *artwork = [track objectForKey:@"albumArtURL"];
	if( artwork ) {
		[g_async loadWithURL:artwork asyncinfo:self asyncdata:@"artwork"];	
	}
	
	
	// someone might want to know...
	currentTrackTitle_ = title;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"titleAvailable" object:self userInfo:[track retain]];	
}



- (void) gotTrackList:(NSArray*)tracklist
{	
	if( !tracklist ) {
		[[[UIAlertView alloc] initWithTitle:@"Error w/ mp3tunes"
							  message:@"Couldn't get tracklist" 
							  delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];		
		return;
	}
	
	printf( "gotTrackList: %s\n" , [[albumInRequest_ objectForKey:@"albumTitle"] UTF8String]);
	
	NSUInteger numtracks = [tracklist count];
	NSDictionary *track = [tracklist objectAtIndex:(drand48()*numtracks)];
	
	[self playTrack:track];		
}


-(void) pause
{
	[g_audio pause];
}

-(void) resume;
{
	[g_audio resume];
}


-(void) stop
{
	[g_async cancel];
	[g_audio cancel];	
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


- (void) setvolume:(float)volume
{
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


- (BOOL) isrunning
{
	return [g_audio isrunning];
}


- (BOOL) login
{
  if( !username_ || !password_ )
	return FALSE;  

  NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];

  [req appendString: @"https://shop.mp3tunes.com/api/v1/login?output=xml" ];  
  [req appendString:[NSString stringWithFormat:@"&partner_token=%@", partner_token]];
  [req appendString:[NSString stringWithFormat:@"&username=%@&password=%@", username_, password_]];
	
  [self stop];
  [g_async release];
	
  g_async = [[[asyncIO alloc] init] retain];
  [g_async loadWithURL:req asyncinfo:self asyncdata:@"login"];
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
	
	[req appendString: @"https://shop.mp3tunes.com/api/v1/login?output=xml" ];  
	[req appendString:[NSString stringWithFormat:@"&partner_token=%@", partner_token]];
	
	if( [firstname length] && [lastname length] ) {
		[req appendString:[NSString stringWithFormat:@"&email=%@&password=%@&firstname=%@&lastname=%@", 
						   username, password, firstname, lastname]];
	}
	else {
		[req appendString:[NSString stringWithFormat:@"&email=%@&password=%@", 
						   username, password]];
	}
	
	NSURL *url = [NSURL URLWithString:req];
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
	NSString *status  = [parseDelegate.found_ retain];
	
	[parseDelegate reset];
	parseDelegate.search_ = @"errorMessage";
	[parser parse];		
	NSString *errmsg  = [parseDelegate.found_ retain];
		
	if( [status isEqualToString:@"1"] )
	{
		[[[UIAlertView alloc] initWithTitle:@"Account Created" 
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

- (BOOL)applicationDataToFile:(NSData *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}


- (NSData*) applicationDataFromFile:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
	return myData;
}



- (BOOL)writeApplicationPlist:(id)plist toFile:(NSString *)fileName {
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


- (id)applicationPlistFromFile:(NSString *)fileName {
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
  if(!d)
	return;

  [username_ release];
  [password_ release];

  username_ = [[d objectForKey:@"username"] retain];
  password_ = [[d objectForKey:@"password"]  retain];
}


- (void) saveState
{
  NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:10];
  [d setValue:username_ forKey:@"username"];
  [d setValue:password_ forKey:@"password"];
  [self writeApplicationPlist:d toFile:@"airbandPlist"];  
}



@end


