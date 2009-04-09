#import <UIKit/UIKit.h>
#import "xmlhelp.h"

#pragma mark	-------------------------------------------------
#pragma mark	AppData
#pragma mark	-------------------------------------------------

@interface AppData : NSObject<ProtocolAsyncInfo>
{
  // user login data;  probably should be encrypted/keychained etc.
  NSString *username_;
  NSString *password_;
  // current session
  NSString* sessionID_;	
  // a list of dictionaries;  pythonesque in its wastefulness.
  NSArray *fullArtistList_;	
  NSArray *playLists_;
  NSDictionary *albumInRequest_;
  UIImage *artwork_;
  NSArray *currentTracklist_;
  NSArray *albumList_;
  NSArray* trackList_;
  NSString *currentTrackTitle_;
}

@property (retain) NSString *username_;
@property (retain) NSString *password_;
@property (readonly) NSArray* fullArtistList_;
@property (readonly) UIImage* artwork_;
@property (readonly) NSArray* playLists_;
@property (readonly) NSArray* currentTracklist_;
@property (readonly) NSArray* albumList_;
@property (readonly) NSArray* trackList_;
@property (readonly) NSString* currentTrackTitle_;

- (void) restoreState;
- (void) saveState;
- (BOOL) login;
- (void) getArtistList;
- (void) getPlayListsAsync;
- (void) getAlbumListAsync:(NSString*)artist_id;
- (void) getTrackListAsync:(NSString*)album_id;
- (void) getPlayListTracksAsync:(NSString*)playlist_id;
- (void) gotAlbumList:(NSArray*)albumlist;
- (void) gotTrackList:(NSArray*)tracklist;
- (void) dataReady:(NSData*)data  userdata:(id)userdata;
- (void) failed:(id)userdata error:(NSError*)error;
- (void) playTrack:(NSDictionary*)track;
- (void) play:(NSDictionary*)artistdictionary;
- (void) stop;
- (void) setvolume:(float)volume;
- (float) percent;
// if audio track is being played
- (BOOL) isrunning;

+ (AppData*) get;
@end


