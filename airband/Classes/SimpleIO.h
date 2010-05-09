// --------------------------------------------------------------------------------
// simple async i/o
// --------------------------------------------------------------------------------

#import "UIKit/UIKit.h"

#pragma mark  --------------------------------------------------------------------------------
#pragma mark  AsyncCallback -- user callbacks (all are optional)
#pragma mark  --------------------------------------------------------------------------------
@protocol AsyncCallback 
-(void) didFailWithError:(NSError*)err  userData:(id)user ;
-(BOOL) someData:(NSData*)data          userData:(id)user ;
-(void) finishedWithData:(NSData*)data  userData:(id)user ;
@end

typedef NSObject<AsyncCallback>  AsyncObject;

#pragma mark  --------------------------------------------------------------------------------
#pragma mark  ConnectionInfo -- Info needed for a connection
#pragma mark  --------------------------------------------------------------------------------
@interface ConnectionInfo : NSObject
{
  NSString *address_;
  // the callback object
  NSObject<AsyncCallback>*  delegate_;
  // user data
  id userdata_;
}

@property (readwrite,retain)   NSString* address_;
@property (readwrite,retain)   NSObject<AsyncCallback>*  delegate_;
@property (readwrite,retain)   id userdata_;
@end


#pragma mark  --------------------------------------------------------------------------------
#pragma mark  SimpleIO -- multiple async i/o handler.
#pragma mark  --------------------------------------------------------------------------------
@interface SimpleIO : NSObject<AsyncCallback>
{
  // maximum connections allowed
  int maxConnections_;
  // connections that are (possibly inflight)
  NSMutableArray *connections_;  
  // connections that are queued up
  NSMutableArray *queue_;
}

-(id) initWithMaxConnections:(int)mxconn;
-(void) request:(ConnectionInfo*)info;
-(void) cancel:(NSObject<AsyncCallback>*) c;
-(BOOL) isBusy:(NSObject<AsyncCallback>*) c;
-(void) cancelAll;
-(BOOL) anyBusy;
-(int) numInFlight;
+(SimpleIO*) singelton;

@end
