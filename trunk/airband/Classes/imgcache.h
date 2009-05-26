#import "xmlhelp.h"

// ================================================================================

#pragma mark	-------------------------------------------------
#pragma mark	data cache
#pragma mark	-------------------------------------------------

@interface SimpleCache : NSObject 
{
	int capacity_;
	NSMutableDictionary *map_;
	NSMutableArray *lru_;
}

- (id)initWithCapacity:(int)cap;
- (id)objectForKey:(id)key;
- (void)setObject:(id)value forKey:(id)key;

@end


// ================================================================================

#pragma mark	-------------------------------------------------
#pragma mark	async image protocol
#pragma mark	-------------------------------------------------

@protocol ProtocolAsyncImage
@required
-(void) imageReady:(UIImage*)img   userData:(id)userData;
-(void) failed:(id)userdata error:(NSError*)error;
@end

// ================================================================================

#pragma mark	-------------------------------------------------
#pragma mark	image cache w/ async callback to user.
#pragma mark	-------------------------------------------------

@interface imagecache : NSObject<ProtocolAsyncInfo>
{
	// pending requests
	NSMutableArray *requests_;
	// stored items.
	SimpleCache *cache_;
	// network is busy
	BOOL busy_;
	// connection
	asyncIO  *io_;
}

- (UIImage *) loadImage:(NSString *) imagename;

- (UIImage*) loadWithURL:(NSString*)strurl
				callback:(id)user  
			callbackdata:(id)userdata;


- (void) stop;

@end

