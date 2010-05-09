#import "SimpleIO.h"

#pragma mark    - ---- - ---- - ---- -
#pragma mark    AsyncIO definition
#pragma mark    - ---- - ---- - ---- -

@interface AsyncIO : NSObject
{
  char *buf_;
  int capacity_;
  NSURLConnection *inflight_;
  int  recv_;
  ConnectionInfo *info_;
}


-(void) request:(ConnectionInfo*)info;
-(void) cancel;
-(BOOL) isBusy;

@end


#pragma mark    - ---- - ---- - ---- -
#pragma mark    AsyncIO
#pragma mark    - ---- - ---- - ---- -

@implementation AsyncIO

-(id) init
{
  if (self = [super init]) {
    capacity_ = 8*1024;
    buf_ = malloc( capacity_ );
    recv_ = 0;
    inflight_ = nil;
  }
    
  return self;
}

- (void) dealloc 
{
  free(buf_);
  [inflight_ release];
  [super dealloc];
}

-(void)cancel
{
  recv_ = 0;
  [inflight_ cancel];
  [inflight_ release];
  inflight_ = nil;
}

-(BOOL) isbusy
{
  return inflight_ != nil;
}


-(void) request:(ConnectionInfo*)info
{ 
  [inflight_ release];

  info_ = info;
  recv_ = 0;
	
  [info_ retain];
	
  NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL URLWithString:info_.address_]];
  inflight_ = [[NSURLConnection connectionWithRequest:url
                                             delegate:self] retain];
	
	if (!inflight_) {
		printf( "[async_io] -- error creating urlConnection to:%s\n", [info_.address_ UTF8String]);
	}
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  printf( "[async_io]-- didFailWithError:%s\n", [[error localizedDescription] UTF8String] );
  [inflight_ release];
  inflight_ = nil;
  recv_ = 0;
  [info_.delegate_ didFailWithError:error  userData:info_.userdata_];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  int needed = [data length] + recv_ + 1;   
  if( capacity_ < needed ) {
    capacity_ = (needed > 2*capacity_) ? needed : 2*capacity_;
    buf_ = realloc(buf_, capacity_);
  }
  
  [data getBytes:&buf_[recv_] ];
  recv_ += [data length];  

  // terminate strings.
  buf_[recv_] = 0;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSData *data = [[NSData dataWithBytes:buf_ length:recv_] retain];
  recv_ = 0;
  // this async object will probably be used immediately after.
  ConnectionInfo *prevInfo = info_;  	
  info_ = nil;
  [prevInfo.delegate_ finishedWithData:data  userData:prevInfo.userdata_];
  [data release];	
  [prevInfo release];
}

-(BOOL) isBusy
{
  return inflight_ != nil;
}

@end


#pragma mark    - ---- - ---- - ---- -
#pragma mark    ConnectionInfo
#pragma mark    - ---- - ---- - ---- -

@implementation ConnectionInfo
{
}

@synthesize address_;
@synthesize delegate_;
@synthesize userdata_;

@end


#pragma mark    - ---- - ---- - ---- -
#pragma mark    SimpleConnection
#pragma mark    - ---- - ---- - ---- -

@interface SimpleConnection : NSObject
{
  // interaction w/ asyncIO
  ConnectionInfo  *localConnection_;
  AsyncIO *async_;  
  // connection back to user
  ConnectionInfo  *userConnection_;
}

@property (readwrite,retain) ConnectionInfo *localConnection_;
@property (readwrite,retain) ConnectionInfo *userConnection_;
@property (readwrite,retain) AsyncIO *async_;
@end


@implementation SimpleConnection

- (id) init
{
  self = [super init];
  if (self != nil) {
		
  }
  return self;
}

- (void) dealloc
{
  [super dealloc];
}


@synthesize localConnection_;
@synthesize userConnection_;
@synthesize async_;
@end





#pragma mark    - ---- - ---- - ---- -
#pragma mark    SimpleIO
#pragma mark    - ---- - ---- - ---- -

@implementation SimpleIO

-(id) initWithMaxConnections:(int)mxconn
{
  if (self = [super init]) {
    maxConnections_ = mxconn;

    connections_ = [[NSMutableArray arrayWithCapacity:mxconn] retain];
	  
    for (NSUInteger i=0; i<maxConnections_; ++i) 
      {
        SimpleConnection *s = [[SimpleConnection alloc] init];
        s.localConnection_ = [[ConnectionInfo alloc] init];
        s.localConnection_.delegate_ = self;
        s.localConnection_.userdata_ = s;
        s.async_ = [[AsyncIO alloc] init];
        s.userConnection_ = nil;
        [connections_ addObject:s];
      }
    
    queue_ = [[NSMutableArray arrayWithCapacity:2*mxconn] retain];
  }
	
  return self;
}


- (void) dealloc 
{
  [self cancelAll];
  [connections_ release];
  [queue_ release];
  [super dealloc];
}


-(void) request:(ConnectionInfo*)userinfo
{
  @synchronized(self) {
    for (NSUInteger i=0; i<maxConnections_; ++i) 
      {        
        SimpleConnection *simple = [connections_ objectAtIndex:i];

        if (simple.userConnection_ == nil) 
          {    
            simple.userConnection_ = userinfo;
            simple.localConnection_.address_ = userinfo.address_;
            [simple.async_ request:simple.localConnection_];
			  
            //printf("(simpleIO) -- sending off request for: %s from slot:%d\n",
            //       [simple.userConnection_.address_ UTF8String], i);

            return;
          }
      }
  }

  // otherwise...
  [queue_ addObject:userinfo];
	
  // printf( "request postponed, queue size is: %d\n", [queue_ count] );
}


-(void) checkMoreWork
{	
  @synchronized(self) {
    if (![queue_ count]) {
      return;
    }

    ConnectionInfo *info = [queue_ lastObject];
    [self request:info];
    [queue_ removeLastObject];
  }
}


-(void) cancelAll
{

  @synchronized(self) {
	
    [queue_ removeAllObjects];
        
    for (NSUInteger i=0; i<maxConnections_; ++i) {
      SimpleConnection *simple = [connections_ objectAtIndex:i];
      if (simple.userConnection_) 
        {
          [simple.async_ cancel];
          simple.userConnection_ = nil;
        }
    }    
  }  
}

-(void) cancel:(NSObject<AsyncCallback>*) c
{
  @synchronized(self) {
    for (NSUInteger i=0; i<maxConnections_; ++i) {
      SimpleConnection *simple = [connections_ objectAtIndex:i];
      if (simple.userConnection_ && simple.userConnection_.delegate_ == c) 
        {
          [simple.async_ cancel];
          simple.userConnection_ = nil;
			return;
        }
    }
	  // todo -- check if the request is in the queue.
  }

	
  [self checkMoreWork];
}


-(BOOL) isBusy:(NSObject<AsyncCallback>*) c
{
  // todo
  return FALSE;
}


-(BOOL) anyBusy
{
  return [self numInFlight] > 0;
}


-(int) numInFlight
{
  int count = 0;
	
  @synchronized(self) {
    for (NSUInteger i=0; i<maxConnections_; ++i) {
      SimpleConnection *s = [connections_ objectAtIndex:i];
      if (s.userConnection_ != nil) 
        ++count;
    }    
  }	

  return count;
}


-(void) didFailWithError:(NSError*)err  userData:(id)user
{
  @synchronized(self) {
    SimpleConnection *s = user;
    [s.userConnection_.delegate_ didFailWithError:err userData:s.userConnection_.userdata_];
    s.userConnection_ = nil;
  }
}

-(BOOL) someData:(NSData*)data  userData:(id)user
{
  return FALSE;
}


-(void) finishedWithData:(NSData*)data  userData:(id)user
{	
  @synchronized(self) {
    SimpleConnection *s = user;
    [s.userConnection_.delegate_ finishedWithData:data  userData:s.userConnection_.userdata_];
    s.userConnection_ = nil;    
  }
	
  [self checkMoreWork];	
}

+(SimpleIO*) singelton
{
  static SimpleIO *g = NULL;

  @synchronized(self)
    {
      if (!g) {
        g = [[self alloc] initWithMaxConnections:7];
        [g retain];
      }
    }
	
  return g;
}

@end

