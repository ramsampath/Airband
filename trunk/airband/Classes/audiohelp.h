//
//  audiohelp.h
//  NavBar
//
//  Created by Scot Shinderman on 8/6/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

@protocol audiocallback

-(void) progress:(float)percent;
-(void) failed;

@end


@interface asyncaudio_II : NSObject
{
	struct AudioData *myd_;          // the audio hook
	pthread_t workerThread_;
	pthread_mutex_t mutex_;	// a mutex to protect the datalist
	pthread_cond_t cond_;		// a condition varable for handling the datalist
	pthread_cond_t workerdone_;  // a flag that signals the audio loop has exited.
	bool running_;            // child thread is running
	NSMutableArray*  datalist_;
}

-(void) cancel;
-(bool) launchworker;
-(void) consumer;
-(void) produce:(NSData*)d;
-(BOOL) isrunning;
@property (readwrite) struct AudioData* myd_;
@end


@interface audiohelp_II : NSObject
{
	NSURLConnection*  connection_;
	asyncaudio_II*    asyncaudio_;
	
	bool paused_;
	int tracksize_;
}

@property (readwrite) int tracksize_;

-(void) play:(NSString*)url;
-(void) pause;
-(void) resume;
-(float) percentage;
-(void) cancel;
-(void) setvolume:(float)v;
-(BOOL) isrunning;

@end




