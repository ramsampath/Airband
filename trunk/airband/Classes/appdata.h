#import <UIKit/UIKit.h>
#import "xmlhelp.h"

#pragma mark	-------------------------------------------------
#pragma mark	AppData
#pragma mark	-------------------------------------------------

@interface AppData : NSObject<ProtocolAsyncInfo>
{
  // user login data
  // [todo] probably should be encrypted/keychained as this might get stored plaintext 
  // in user's itunes during backup?
  NSString *username_;
  NSString *password_;
	
  // current session
  NSString* sessionID_;	
  // a list of dictionaries;  pythonesque in its wastefulness.
  NSArray *fullArtistList_;	
  // (array of dictionary) of playlist names
  NSArray *playLists_;
  // in flight request
  NSDictionary *albumInRequest_;
  // (single) image of currently playing song
  UIImage *artwork_;
  // tracks (array of dictionary) for currently select playlist
  NSArray *currentTracklist_;
  // albums (array of dictionary) for selected artist
  NSArray *albumList_;
  // tracks (array of dictionary)for currently selected artist+album
  NSArray* trackList_;
  // name of the current song.
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


