#import "xmlhelp.h"

#pragma mark	-------------------------------------------------
#pragma mark	async protocol
#pragma mark	-------------------------------------------------

@implementation asyncIO

- (id) init
{
  self = [super init];
	if( self ) {	
	  user_ = nil;
	  userdata_ = nil;
	  inflight_ = nil;
	  capacity_ = 0;
	  recv_ = 0;
	  buf_ = NULL;
	}
	
	return self;
}

- (void) dealloc
{
  free( buf_ );
  [super dealloc];
}

- (bool) isBusy
{
  return (inflight_ != nil);
}


- (void) clean
{
  user_ = nil;
  userdata_ = nil;
  inflight_ = nil;
  recv_ = 0;

  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) loadWithURL:(NSString*)strurl asyncinfo:(id)user  asyncdata:(id)userdata
{
  if( inflight_ )
	return;

  if( [user conformsToProtocol:@protocol(ProtocolAsyncInfo)] ) {
	user_ = user;
	userdata_ = userdata;
  } else {
	printf( "[bug] -- bad asyncinfo\n" );
  }

  recv_   = 0;
  NSString *enc = strurl; // [strurl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];	
  NSURL    *url = [NSURL URLWithString:enc];	
  inflight_ = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url]
							   delegate:self] ;

  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  printf( "async request in flight:%s\n", [strurl UTF8String] );
}


- (void) cancel
{
  [inflight_ cancel];
  [self clean];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  printf( "didFailWithError:%s\n", [[error localizedDescription] UTF8String] );
  [user_ failed:userdata_ error:error];
  [self clean];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  int needed = [data length] + recv_ + 1;	
  if( capacity_ < needed ) {
	capacity_ = (needed > 2*capacity_) ? needed : 2*capacity_;
	if( !buf_ )
	  buf_ = malloc( capacity_ );
	else
	  buf_ = realloc(buf_, capacity_);
  }	
  
  [data getBytes:&buf_[recv_] ];
  recv_ += [data length];
  		
  // terminate strings.
  buf_[recv_] = 0;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	

  NSData *rdata = [[NSData dataWithBytes:buf_ length:recv_] retain];
  // this is a little tricky if 'self' is reused.	
  inflight_ = nil;
  recv_ = 0;
  [user_ dataReady:rdata  userdata:userdata_];
  [rdata release];
}

@end



#pragma mark	-
#pragma mark	Simple Element XML
#pragma mark	-

@implementation XMLParseSimpleElement
@synthesize found_;
@synthesize search_;

- (id) init {    
  if (self = [super init]) {
	elementStarted_ = false;
	found_ = [[NSMutableString stringWithCapacity:50] retain];
  }
	
  return self;
}

- (void) dealloc {
  [found_ release];
  [super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict 
{    
  elementStarted_ = [elementName isEqualToString:search_];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
  if( elementStarted_ ) {
	[found_ appendString:str];
  }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  elementStarted_ = FALSE;
}	

@end



#pragma mark	-
#pragma mark	XMLParseItemList
#pragma mark	-

@implementation XMLParseItemList
@synthesize itemList_;

- (id) init {    
  if (self = [super init]) {
	elementData_ = [[NSMutableString stringWithCapacity:100] retain];
	itemList_    = [[NSMutableArray arrayWithCapacity:1000] retain];
	currentItem_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	parsingItem_ = FALSE;
  }
	
  return self;
}

- (void) dealloc {
  [itemList_ release];
  [currentItem_ release];
  [elementData_ release];
  [super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict 
{
  [elementData_ setString:@""];
	
  if( [elementName isEqualToString:@"item"] ) 
	{
	  parsingItem_ = TRUE;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  if( !parsingItem_ )
	return;
	
  if( [elementName isEqualToString:@"item"] )	{		
	[itemList_ addObject:[NSDictionary dictionaryWithDictionary:currentItem_]];;
	[currentItem_ removeAllObjects];
	parsingItem_ = FALSE;
  } else {	
	[currentItem_ setObject:[NSString stringWithString:elementData_] forKey:elementName];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
  [elementData_ appendString:str];
}

@end


