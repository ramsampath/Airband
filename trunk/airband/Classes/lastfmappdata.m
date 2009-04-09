
#import "airbandAppDelegate.h"   // for access to global AppData
#import "xmlhelp.h"
#import "audiohelp.h"

#import	"lastfmappdata.h"

#pragma mark	-
#pragma mark	AppData
#pragma mark	-

static asyncIO *g_async = nil;
static NSString *partner_token = @"[redacted]";
static audiohelp_II *g_audio = nil;

// mp3 tunes API:
// http://www.last.fm/api/intro
// static const char *mp3api = "http://ws.audioscrobbler.com/2.0/";


@implementation LastFMAppData




// --------------------------------------------------------------------------
// singelton
// --------------------------------------------------------------------------
+(LastFMAppData*) get
{
  airbandAppDelegate *airband = (airbandAppDelegate*) ([UIApplication sharedApplication].delegate);	
  return airband.appdata_;
}

// --------------------------------------------------------------------------
// constructor
// --------------------------------------------------------------------------
-(id) init
{
	[super init];
	apiID_  = @"7a9dd8a0ee6aaabadfff9757e7eef163";
	secret_ = @"8fbad0584aab2d1066096137f5857385";
	// read the user settings.
	
	return self;
}

// --------------------------------------------------------------------------
// destructor 
// --------------------------------------------------------------------------
- (void)dealloc
{
	[super dealloc];
}





// --------------------------------------------------------------------------
// callback from async
// --------------------------------------------------------------------------
-(void) dataReady:(NSData*)data  userdata:(id)userdata
{
	NSString *which = userdata;
	
	printf( "----------- dataReady:%s\n", [which UTF8String] );

	
	if( [which isEqualToString:@"artistList"] )
	{
		fullArtistList_ = [super parseItemList:data];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"artistListReady" object:nil];								
	}
	else if( [which isEqualToString:@"playLists"] )
	{		
		playLists_ = [super parseItemList:data];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playListsReady" object:nil];		
	}		
	else if( [which isEqualToString:@"albumList"] )
	{		
		[albumList_ release];
		NSArray *a = [super parseItemList:data];
		albumList_ = a;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"albumListReady" object:nil];		
		printf( "albumList size:%d\n", [a count] );
		//[self gotAlbumList:a];		
	}		
	else if( [which isEqualToString:@"trackList"] )
	{
		NSArray *a = [super parseItemList:data];		
		trackList_ = a;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"trackListReady" object:nil];		
		//[self gotTrackList:a];
	}
	else if( [which isEqualToString:@"playlistTracks"] )
	{
		NSArray *a = [super parseItemList:data];
		currentTracklist_ = a;
		printf( "playlistTracks: %d items\n", [a count] );
		//[self gotPlaylistTracks:a];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playListTracksReady" object:nil];				
	}
	else if( [which isEqualToString:@"artwork"] )
	{			
		printf( "artwork ready.  %d bytes\n", [data length] );
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


- (void) getArtistList
{
	NSMutableString *req = [[NSMutableString stringWithCapacity:1024] retain];
	[req appendString:[NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=artist.getSimilar&artist=%@api_key=%@", favartist_, 
					   apiID_]];
	
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"artistList"];
};



- (void) getPlayListsAsync
{
	NSMutableString *req = [[NSMutableString stringWithCapacity:1024] retain];
	[req appendString:[NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=user.getPlaylists=%@api_key=%@", username_, 
					   apiID_]];
		
	//[busyIndicator startAnimating];			
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"playLists"];
}	


- (void) getAlbumListAsync:(NSString*)artist_id
{
	NSMutableString *req = [[NSMutableString stringWithCapacity:1024] retain];
	[req appendString:[NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=artist.getTopAlbums=%@api_key=%@", favartist_, 
					   apiID_]];
		
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



-(void) playTrack:(NSDictionary*)track
{
	NSString *playfile  = [track objectForKey:@"playURL"];
	NSString *title     = [track objectForKey:@"trackTitle"];
	NSString *tracksize = [track objectForKey:@"trackFileSize"];	
	
	if( !playfile ) {
		[[[UIAlertView alloc] initWithTitle:@"Error w/ LastFM"
									message:@"Couldn't get playfile" 
								   delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
		return;
	}
		
	// stream it.
	NSMutableString *req = [[NSMutableString stringWithString:playfile] retain];
	[req appendString:partner_token];
	
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
		[[[UIAlertView alloc] initWithTitle:@"Error w/ LastFM"
							  message:@"Couldn't get tracklist" 
							  delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];		
		return;
	}
	
	printf( "gotTrackList: %s\n" , [[albumInRequest_ objectForKey:@"albumTitle"] UTF8String]);
	
	NSUInteger numtracks = [tracklist count];
	NSDictionary *track = [tracklist objectAtIndex:(drand48()*numtracks)];
	
	[self playTrack:track];		
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




- (BOOL) login
{
	if( !username_ || !password_ )
		return FALSE;  

	NSMutableString *req = [[NSMutableString stringWithCapacity:512] retain];

	NSString *authToken = [NSString stringWithFormat:@"&md5(%@ + md5(%@))", username_, password_];
	NSString *secret    = [NSString stringWithFormat:@"%@", secret_];
	NSString *api_signature = [NSString stringWithFormat:@"md5(\"api_key%@authToken%@methodauth.getSession%@\")", apiID_, authToken, secret];
	[req appendString: @"http://ws.audioscrobbler.com/2.0/" ];  
	[req appendString:api_signature];
	
	[self stop];
	[g_async release];
	
	g_async = [[[asyncIO alloc] init] retain];
	[g_async loadWithURL:req asyncinfo:self asyncdata:@"login"];

	return TRUE;	
}




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


