#import <UIKit/UIKit.h>
#import "xmlhelp.h"
#import "imgcache.h"

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
    NSData  *artworkdata_;
    // tracks (array of dictionary) for currently select playlist
    NSArray *currentTracklist_;
    // albums (array of dictionary) for selected artist
    NSArray *albumList_;
    // tracks (array of dictionary)for currently selected artist+album
    
    NSArray* trackList_;
    float   currentTrackFileSize_;
    float   currentTrackLength_;
    float   lastVolume_;
    // name of the current song.
    NSString *currentTrackTitle_;
    NSString *currentArtist_;
    NSString *currentAlbum_;
    // bit rate to pass to the URL
    int bitRate_;

    // the index of the current track playing
    int currentTrackIndex_;
    // the index in the album of the current track (from mp3tunes.com)
    int currentAlbumTrackIndex_;
    
    bool autoLogin_;
    NSInteger startpage_;
    
    imagecache *albumArtCache_;

    // 
    bool currentlyPlaying_;
    
    //
    //
    int coverflowDisplayType_;
    //
    //
    NSMutableArray *images_;
}

@property (retain)    NSString *username_;
@property (retain)    NSString *password_;
@property (readonly)  NSString* sessionID_;
@property (readonly)  NSArray* fullArtistList_;
@property (retain)    UIImage* artwork_;
@property (readonly)  NSArray* playLists_;
@property (readonly)  NSArray* currentTracklist_;
@property (readonly)  NSArray* albumList_;
@property (readonly)  NSArray* trackList_;
@property (readonly)  NSString* currentTrackTitle_;
@property (readonly)  NSString* currentArtist_;
@property (readonly)  NSString* currentAlbum_;
@property (readonly)  float currentTrackLength_;
@property (readonly)  float currentTrackFileSize_;
@property (readonly)  int currentAlbumTrackIndex_;
@property (readwrite) int currentTrackIndex_;
@property (readonly)  int bitRate_;
@property (readwrite) float lastVolume_;
@property (readwrite) bool autoLogin_;
@property (readwrite) NSInteger startpage_;
@property (readonly)  imagecache* albumArtCache_;
@property (readwrite) int coverflowdisplayType_;
@property (readonly) NSMutableArray *images_;
@property (readwrite) int coverflowDisplayType_;

- (NSString*) createAccount:(NSDictionary*)userinfo;
- (void) restoreState;
- (void) saveState;
- (BOOL) login;
- (void) getArtistList;
- (void) getAlbumList;
- (void) getPlayListsAsync;
- (void) getAlbumListAsync:(NSString*)artist_id;
- (void) getTrackListAsync:(NSString*)album_id;
- (void) getPlayListTracksAsync:(NSString*)playlist_id;

- (UIImage *)getAlbumArtwork:(NSString *)aid;
- (void) getAlbumListArtwork:(NSArray *)albumlist;

- (void) gotAlbumList:(NSArray*)albumlist;
- (void) gotTrackList:(NSArray*)tracklist;
- (void) dataReady:(NSData*)data  userdata:(id)userdata;
- (void) failed:(id)userdata error:(NSError*)error;
- (void) playTrack:(NSDictionary*)track;
- (int)  getPlayLength;
- (void) play:(NSDictionary*)artistdictionary;
- (void) pause;
- (void) resume;
- (void) stop;
- (void) setvolume:(float)volume;
- (NSArray*) parseItemList:(NSData*)data;
- (void)  setStreamingRate:(int)rate;
- (float) percent;
- (float) tracklength;
- (float) trackFileSize;
- (bool)  isPlaying;
- (bool)  isPaused;
- (bool)  hasfinished;
// if audio track is being played
- (bool) isrunning;

+ (AppData*) get;


@end


