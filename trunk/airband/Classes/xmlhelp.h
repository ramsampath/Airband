#import <UIKit/UIKit.h>

#pragma mark	-------------------------------------------------
#pragma mark	async protocol
#pragma mark	-------------------------------------------------

@protocol ProtocolAsyncInfo
@required
-(void) dataReady:(NSData*)data  userdata:(id)userdata;
-(void) failed:(id)userdata error:(NSError*)error;
@end



#pragma mark	-------------------------------------------------
#pragma mark	async IO
#pragma mark	-------------------------------------------------
				   
@interface asyncIO : NSObject {  
@private
  id user_;
  id userdata_;
  int capacity_;
  int recv_;
  char *buf_;
  NSURLConnection  *inflight_;
  NSMutableArray  *tasks_;	
}

- (void) clean;
- (bool) isBusy;
- (void) cancel;
- (void) loadWithURL:(NSString*)strurl asyncinfo:(id)user  asyncdata:(id)userdata;
@end

#pragma mark	-------------------------------------------------
#pragma mark	parse xml simple
#pragma mark	-------------------------------------------------

// parse for <search>data</search>

@interface XMLParseSimpleElement : NSObject {
  NSString *search_;
  bool  elementStarted_;
  NSMutableString*  found_;
}
@property (retain) NSString *search_;
@property (readonly,retain) NSMutableString *found_;

-(void) reset;
@end


#pragma mark	-------------------------------------------------
#pragma mark	parse XML items
#pragma mark	-------------------------------------------------

//
// parse xml for zero or more 
//  <item> 
//     <tag1>data1</tag1>
//     <tagN>dataN</tagN> 
//  </item>
//

@interface XMLParseItemList : NSObject {
  NSMutableString *elementData_;
  bool parsingItem_;
  NSMutableArray *itemList_;
  NSMutableDictionary *currentItem_;
}
@property (retain) NSMutableArray *itemList_;
@end



