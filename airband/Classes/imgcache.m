#import "imgcache.h"

// ================================================================================
// how many thumbnails to keep in cache
// ================================================================================
#define kCACHE_CAPACITY 4
// ================================================================================
// thumbnail size in pixels
// ================================================================================
#define kTHUMBNAIL_SIZE 30

// ================================================================================
// ================================================================================

#pragma mark	-------------------------------------------------
#pragma mark	SimpleCache implementation
#pragma mark	-------------------------------------------------

@implementation SimpleCache

- (id)initWithCapacity:(int)cap
{
    if (nil != (self = [super init])) {
        capacity_ = cap;
        map_ = [[NSMutableDictionary alloc] initWithCapacity:cap];
        lru_ = [[NSMutableArray alloc] initWithCapacity:cap];
    }
    return self;
}

- (void)dealloc
{
    [map_ release];
    [lru_ release];
    [super dealloc];
}

- (id)objectForKey:(id)key
{
    NSUInteger index = [lru_ indexOfObject:key];
    if (index == NSNotFound) 
        return nil;
    
    if (index) {
        [lru_ removeObjectAtIndex:index];
        [lru_ insertObject:key atIndex:0];
    }
    
    return [map_ objectForKey:key];
}

- (void)setObject:(id)value forKey:(id)key
{
    NSUInteger index = [lru_ indexOfObject:key];
    if (index) {
        if (index != NSNotFound) {
            [lru_ removeObjectAtIndex:index];
        }
        
        [lru_ insertObject:key atIndex:0];
		
        if ([lru_ count] > capacity_) {
            [map_ removeObjectForKey:[lru_ lastObject]];
            [lru_ removeLastObject];
        }
    }
    
    [map_ setObject:value forKey:key];
}

@end


// ================================================================================
// ================================================================================

#pragma mark	-------------------------------------------------
#pragma mark	image cache implementation
#pragma mark	-------------------------------------------------

@implementation imagecache

- (id) init
{
    self = [super init];
    if( self ) {
        requests_ = [[NSMutableArray arrayWithCapacity:20] retain];
        cache_ = [[[SimpleCache alloc] initWithCapacity:kCACHE_CAPACITY] retain];
        io_ = [[[asyncIO alloc] init] retain];
        busy_ = FALSE;
    }
    
    return self;
}


// --------------------------------------------------------------------------------

- (void) dealloc
{
    [io_ release];
    [cache_ release];
    [requests_ release];
    [super dealloc];
}

// --------------------------------------------------------------------------------

-(void) nextRequest
{
	if( !busy_ && [requests_ count])
	{
		busy_ = TRUE;
		NSDictionary *r = [requests_ objectAtIndex:0];
		[io_ loadWithURL:[r objectForKey:@"url"]  asyncinfo:self  asyncdata:@"feh"];		
	}
}

- (UIImage *) loadImage:(NSString *) imagename
{

    //
    // check if already there.
    //
    UIImage *img = [cache_ objectForKey:imagename];
    if( img != nil ) {
        return img;
    }
    else {
        UIImage *img = [UIImage imageNamed:imagename];
        [cache_ setObject:img forKey:imagename];
        return img;
    }
    
    return nil;
}


// --------------------------------------------------------------------------------

- (UIImage*) loadWithURL:(NSString*)strurl
				callback:(id)user  
			callbackdata:(id)userdata
{
    //
    // sanity check
    //
    if( ![user conformsToProtocol:@protocol(ProtocolAsyncImage)] ) {
        return nil;
    }
    
    //
    // check if already downloaded.
    //
    UIImage *img = [cache_ objectForKey:strurl];
    if( img != nil ) {
        return img;
    }
    
    //
    // check for duplicate requests.
    //
    NSMutableDictionary *r;
    for( r in requests_ ) {
        if ([[r objectForKey:@"url"] isEqual:strurl]) {
            return nil;
        }
    }
    
    //
    // add new request.
    //
    r = [NSMutableDictionary dictionaryWithCapacity:3];
    [r setObject:strurl forKey:@"url"];
    [r setObject:user forKey:@"user"];
    [r setObject:userdata forKey:@"userdata"];
    [requests_ addObject:r];
    
    //
    // schedule it.
    //
    [self nextRequest];
	
    //
    // got nothing for ya!
    //
    return nil;
}




// --------------------------------------------------------------------------------

-(UIImage*) resizeImage:(UIImage*)image 
                toWidth:(float)width 
               toHeight:(float)height
{
#if 0 // -- maintain aspect ratio --
    /*
     float srcHeight = image.size.height;
     float srcWidth  = image.size.width;
     
     float aspect = srcWidth/srcHeight;
     float maxRatio = width/height;
     
     if(aspect < maxRatio){
     width = height * srcWidth / srcHeight;
     } else{
     height = width * srcHeight / srcWidth;
     }
     */
#endif
    
    CGRect rect = CGRectMake(0.0, 0.0, width,height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = [UIGraphicsGetImageFromCurrentImageContext() retain];
    UIGraphicsEndImageContext();
    
	return img;
}

// --------------------------------------------------------------------------------

-(UIImage*) prepareImage:(NSData*)data
{
    NSData *dup = [[NSData dataWithData:data] retain];
    CGDataProviderRef provider = CGDataProviderCreateWithData( NULL, [dup bytes],[dup length], NULL );
    CGImageRef imageref = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    if( !imageref ) {
        return nil;      
    }
    
    CGDataProviderRelease(provider);
    CGImageRetain(imageref);
    UIImage *img = [UIImage imageWithCGImage:imageref];
    
    img = [self resizeImage:img toWidth:kTHUMBNAIL_SIZE toHeight:kTHUMBNAIL_SIZE];
    
    CGImageRelease(imageref);
    [dup release];
    // [OPT] --- recompress as jpeg ---
    //NSData *dataForJPEGFile = UIImageJPEGRepresentation(theImage, 0.6);
    
    return img;
}


// --------------------------------------------------------------------------------
// [NOTE] -- this is in callback from socket thread
//           so 1) calling user directly may be dangerous
//              2) firing off another task (in this thread) may be wrong?
// --------------------------------------------------------------------------------
-(void) dataReady:(NSData*)data  userdata:(id)userdata
{	
    NSDictionary *r = [[requests_ objectAtIndex:0] retain];
    [requests_ removeObjectAtIndex:0];
    
    NSString *url = [r objectForKey:@"url"];
	
    // 
    // get image ready
    //
    UIImage *img = [[self prepareImage:data] retain];
    
    //
    // store in cache
    //
    [cache_ setObject:img forKey:url];
    
    // 
    // tell user
    //
    NSObject<ProtocolAsyncImage>* usercallback = [r objectForKey:@"user"];
    [usercallback imageReady:img  userData:[r objectForKey:@"userdata"]];
    
	
    //
    // get next thing to do
    //
    [r release];
    busy_ = FALSE;
    [self nextRequest];
}


-(void) failed:(id)userdata error:(NSError*)error
{
	NSLog( @"something went haywire\n" );
    
    if ([requests_ count]) {
        [requests_ removeObjectAtIndex:0];
    }
    
    busy_ = FALSE;
    [self nextRequest];
}


-(void) stop
{
	[requests_ removeAllObjects];
	[io_ cancel];
	busy_ = FALSE;
}


@end




// ================================================================================
// testing area.
// ================================================================================

@interface mytest : NSObject<ProtocolAsyncImage>
{
}
@end

@implementation mytest

-(void) imageReady:(UIImage*)img   userData:(id)userData
{
	if( !img) 
		printf( "image nil!\n" );
	else
		printf( "image ready!  %f x %f,   userdata:%s\n", img.size.width, img.size.height, [userData UTF8String] );
}

-(void) failed:(id)userdata error:(NSError*)error
{
	printf( "image failed\n" );
}

@end



void test_imagecache()
{
	NSLog(@"test_imagecache");
	static imagecache *ic = nil;
	static mytest *myt = nil;
	
	if( !ic) {
		ic = [[[imagecache alloc] init] retain];
		myt = [[[mytest alloc] init] retain];
	}
	
	NSString *thelist[] = {
		@"http://venturebeat.com/wp-content/uploads/2009/05/1977_starwars.jpg",
		@"http://farm4.static.flickr.com/3351/3565691700_9dbcf12baf_m.jpg",
		@"http://farm4.static.flickr.com/3368/3564875175_36bd152921_m.jpg",
		@"http://farm3.static.flickr.com/2475/3565697674_c52faf9085_m.jpg",	
		@"http://farm4.static.flickr.com/3386/3565746810_6d46a187c2.jpg",
		@"http://imgur.com/avkrh.jpg",
		@"http://farm3.static.flickr.com/2474/3565541298_bc231117b4.jpg?v=0",
		@"http://media.npr.org/news/images/2009/may/25/afghan_233.jpg",
		@"http://imgur.com/qbpwr.jpg"
	};
	
	int j;
	for(j=0; j<sizeof(thelist)/sizeof(NSString*); ++j ) { 
		UIImage *img = [ic loadWithURL:thelist[j] callback:myt callbackdata:[NSString stringWithFormat:@"origIndex:%d", j]];
		if( img ) {
			[myt imageReady:img userData:@"2"];
		}
	}			
	
	//[myt release];
	//[ic release];
}


