//
//  audiohelp.m
//  
//
//  Created by Scot Shinderman on 8/6/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#define APR29_LATEST_HACKS 1
static int ghackApr29_finished_loading = 0;
static float g_hackVolume = 1.0;

#import "pthread.h"
#import "audiohelp.h"
#import "CFNetwork/CFHTTPMessage.h"

//#define PRINTERROR(LABEL)	dbg_printf("%s (%4.4s:%d)\n", LABEL, &err, err)
#define PRINTERROR(LABEL)

// --------------------------------------------------------------------------------
static const char* checkstatus( OSStatus s )
{
	const char *r = "whatev";
	
	switch( s ) {
		case  kAudioFileUnspecifiedError: 
			r = "kAudioFileUnspecifiedError"; 
			break;
		case  kAudioFileUnsupportedFileTypeError: 
			r =  "kAudioFileUnsupportedFileTypeError"; 
			break;
		case kAudioFileStreamError_IllegalOperation:
			r = "kAudioFileStreamError_IllegalOperation";
			break;		  
		case kAudioFileUnsupportedDataFormatError:
			r = "kAudioFileUnsupportedDataFormatError"; 
			break;
		case kAudioFileInvalidFileError: 
			r="kAudioFileInvalidFileError"; 
			break;
		case kAudioFileStreamError_ValueUnknown: 
			r="kAudioFileStreamError_ValueUnknown";
			break;
		case kAudioFileStreamError_DataUnavailable: 
			r="kAudioFileStreamError_DataUnavailable";
			break;
	}
	
	if( s ) {
		//const char *e = (const char*)&s;
		//dbg_printf( "ERROR status: %s %c%c%c%c\n", r, e[3],e[2],e[1],e[0] );
	}
	
	return r;
}






#pragma mark ----------
#pragma mark AudioData
#pragma mark ----------


#define  kNumAQBufs  10			// number of audio queue buffers we allocate
#define  kAQMaxPacketDescs  512		// number of packet descriptions in our array
static const size_t kAQBufSize = 128 * 1024;		// number of bytes in each audio queue buffer

struct AudioData
{
	AudioFileStreamID audioFileStream;	// the audio file stream parser
	
	AudioQueueRef audioQueue_;								// the audio queue
	AudioQueueBufferRef audioQueueBuffer[kNumAQBufs];		// audio queue buffers
	bool inuse[kNumAQBufs];			// flags to indicate that a buffer is still in use
	
	AudioStreamPacketDescription packetDescs[kAQMaxPacketDescs];	// packet descriptions for enqueuing audio
	
	unsigned int fillBufferIndex;	// the index of the audioQueueBuffer that is being filled
	size_t bytesFilled;				// how many bytes have been filled
	size_t packetsFilled;			// how many packets have been filled
	
	bool started;					// flag to indicate that the queue has been started
	bool failed;					// flag to indicate an error occurred
	bool endAudioData;
	
	pthread_mutex_t mutex;			// a mutex to protect the inuse flags
	pthread_cond_t cond;			// a condition varable for handling the inuse flags
	
	AudioTimeStamp pausedTimeStamp; // where the audio was stopped
};
typedef struct AudioData AudioData;


// --------------------------------------------------------------------------------
// return the index of the audio buffer 
// --------------------------------------------------------------------------------
static int MyFindQueueBuffer(AudioData* myData, AudioQueueBufferRef inBuffer)
{
	unsigned int i;
	for ( i = 0; i < kNumAQBufs; ++i) {
		if (inBuffer == myData->audioQueueBuffer[i]) 
			return i;
	}
	//dbg_printf( "HUH -- couldn't find audio buffer index\n" );
	return -1;
}


// --------------------------------------------------------------------------------
// this is called by the audio queue when it has finished decoding our data. 
// --------------------------------------------------------------------------------
static void MyAudioQueueOutputCallback(	void* inClientData, 
										AudioQueueRef inAQ, 
										AudioQueueBufferRef inBuffer)
{
	// The buffer is now free to be reused.
	AudioData* myData = (AudioData*)inClientData;
	unsigned int bufIndex = MyFindQueueBuffer(myData, inBuffer);
	
	// signal waiting thread that the buffer is free.
	pthread_mutex_lock(&myData->mutex);
	myData->inuse[bufIndex] = false;
	pthread_cond_signal(&myData->cond);
	pthread_mutex_unlock(&myData->mutex);	
}


// --------------------------------------------------------------------------------

static void MyAudioQueuePropertyListenerProc ( void                 *inClientData,
											  AudioQueueRef         inAQ,
											  AudioQueuePropertyID  inID
)
{
	AudioData* myData = (AudioData*)inClientData;
	if( !myData ) {
		//dbg_printf( "incoming data to propertyListenerProc is busted\n" );
	}
		 
	UInt32 dataSize=0;
	OSStatus status = AudioQueueGetPropertySize( inAQ, inID, &dataSize );

	////dbg_printf( "audioqueuePropertyListenerProc\n" );
	
	if( inID == kAudioQueueProperty_IsRunning )
	{
		UInt32 isRunning=0;
		dataSize = sizeof(isRunning);
		status = AudioQueueGetProperty(inAQ, inID, &isRunning, &dataSize);
		if( dataSize !=sizeof(isRunning) ) {
			//dbg_printf( "queue get proprty wacked\n" );
		}
		
		////dbg_printf( "audio is running prop: %d\n", isRunning );
		if( !isRunning )
		{
			pthread_mutex_lock(&myData->mutex);
			pthread_cond_signal(&myData->cond);
			pthread_mutex_unlock(&myData->mutex);			
		}
	}
}



static void setPropListeners( AudioData* myData )
{
	OSStatus err = AudioQueueAddPropertyListener (
												  myData->audioQueue_,
												  kAudioQueueProperty_IsRunning,
												  MyAudioQueuePropertyListenerProc,
												  myData );
	checkstatus(err);
}




// --------------------------------------------------------------------------------



// --------------------------------------------------------------------------------
static void MyPropertyListenerProc(	void *inClientData,
									AudioFileStreamID inAudioFileStream,
									AudioFileStreamPropertyID inPropertyID,
									UInt32 *ioFlags)
{	
	// this is called by audio file stream when it finds property values
	AudioData* myData = (AudioData*)inClientData;
	OSStatus err = noErr;
	
	////dbg_printf("MyPropertyListenerProc '%c%c%c%c'\n", 
	//	   (inPropertyID>>24)&255, (inPropertyID>>16)&255, (inPropertyID>>8)&255, inPropertyID&255);
	
	switch (inPropertyID) {
		case kAudioFileStreamProperty_ReadyToProducePackets :
		{
			// the file stream parser is now ready to produce audio packets.
			// get the stream format.
			AudioStreamBasicDescription asbd;
			UInt32 asbdSize = sizeof(asbd);
			err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataFormat, &asbdSize, &asbd);
			if (err) { 
				PRINTERROR("get kAudioFileStreamProperty_DataFormat"); 
				myData->failed = true; 
				break; 
			}
			
			// create the audio queue
			err = AudioQueueNewOutput(&asbd, MyAudioQueueOutputCallback, myData, NULL, NULL, 0, &myData->audioQueue_);
			if (err) { 
				PRINTERROR("AudioQueueNewOutput"); 
				myData->failed = true; 
				break;
			}
			
			// allocate audio queue buffers
			unsigned int i;
			for ( i = 0; i < kNumAQBufs; ++i) {
				err = AudioQueueAllocateBuffer(myData->audioQueue_, kAQBufSize, &myData->audioQueueBuffer[i]);
				if (err) { PRINTERROR("AudioQueueAllocateBuffer"); myData->failed = true; break; }
			}
			
			// set (callback) property listeners
			setPropListeners( myData );
			
			// get the cookie size
			UInt32 cookieSize;
			Boolean writable;
			err = AudioFileStreamGetPropertyInfo(inAudioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, &writable);
			if (err) { 
				PRINTERROR("err - info kAudioFileStreamProperty_MagicCookieData"); 
				break; 					
			}
			
			// get the cookie data
			void* cookieData = calloc(1, cookieSize);
			err = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, cookieData);
			if (err) { PRINTERROR("err -- get kAudioFileStreamProperty_MagicCookieData"); free(cookieData); break; }			
			// set the cookie on the queue.
			err = AudioQueueSetProperty(myData->audioQueue_, kAudioQueueProperty_MagicCookie, cookieData, cookieSize);
			free(cookieData);
			if (err) { PRINTERROR("err -- set kAudioQueueProperty_MagicCookie"); break; }
			break;
		}
	}
}

// --------------------------------------------------------------------------------
// get audio buffer ready -- first time through fires up the AudioQueue.
// [note] -- LOCK hazard (breakable w/ data->cond)
// --------------------------------------------------------------------------------
static OSStatus MyEnqueueBuffer(AudioData* myData)
{
	if (myData->endAudioData || myData->failed)
		return noErr;
	
	OSStatus err = noErr;
	myData->inuse[myData->fillBufferIndex] = true;		// set in use flag
	
	// enqueue buffer
	AudioQueueBufferRef fillBuf = myData->audioQueueBuffer[myData->fillBufferIndex];
	fillBuf->mAudioDataByteSize = myData->bytesFilled;		
	
	err = AudioQueueEnqueueBuffer(myData->audioQueue_, fillBuf, myData->packetsFilled, myData->packetDescs);
	if (err) { PRINTERROR("AudioQueueEnqueueBuffer"); myData->failed = true; return err; }		
	
	if (!myData->started) {		// start the queue if it has not been started already
		err = AudioQueueStart(myData->audioQueue_, NULL);
		if (err) { PRINTERROR("AudioQueueStart"); myData->failed = true; return err; }		
		myData->started = true;
		myData->failed=false;
		myData->endAudioData=false;
		
		// always set to user slider 
		AudioQueueSetParameter( myData->audioQueue_, kAudioQueueParam_Volume, g_hackVolume );		
		//dbg_printf("audio queue started\n");
	}
	
	// go to next buffer
	if (++myData->fillBufferIndex >= kNumAQBufs) 
	  myData->fillBufferIndex = 0;

	myData->bytesFilled = 0;		// reset bytes filled
	myData->packetsFilled = 0;		// reset packets filled
	
	// wait until next buffer is not in use
	pthread_mutex_lock(&myData->mutex); 
	while (myData->inuse[myData->fillBufferIndex]) {

		if (myData->endAudioData || myData->failed)
			break;
		
		pthread_cond_wait(&myData->cond, &myData->mutex);
	}
	pthread_mutex_unlock(&myData->mutex);
	
	return err;
}


// --------------------------------------------------------------------------------
static void MyPacketsProc( void *inClientData,
						   UInt32 inNumberBytes,
						   UInt32 inNumberPackets,
						   const void *inInputData,
						   AudioStreamPacketDescription	*inPacketDescriptions)
{
	// this is called by audio file stream when it finds packets of audio
	AudioData* myData = (AudioData*)inClientData;
	
	// the following code assumes we're streaming VBR data. 
	// for CBR data, you'd need another code branch here.

	int i;
	for (i=0;  i<inNumberPackets;  ++i) 
	{
		if(myData->failed || myData->endAudioData) {
			break;
		}
		
		SInt64 packetOffset = inPacketDescriptions[i].mStartOffset;
		SInt64 packetSize   = inPacketDescriptions[i].mDataByteSize;
		
		// if the space remaining in the buffer is not enough for this packet, then enqueue the buffer.
		size_t bufSpaceRemaining = kAQBufSize - myData->bytesFilled;
		if (bufSpaceRemaining < packetSize) {
			MyEnqueueBuffer(myData);
		}
		
		// copy data to the audio queue buffer
		AudioQueueBufferRef fillBuf = myData->audioQueueBuffer[myData->fillBufferIndex];
		memcpy((char*)fillBuf->mAudioData + myData->bytesFilled,
			   (const char*)inInputData + packetOffset, packetSize);

		// fill out packet description
		myData->packetDescs[myData->packetsFilled] = inPacketDescriptions[i];
		myData->packetDescs[myData->packetsFilled].mStartOffset = myData->bytesFilled;
		
		// keep track of bytes filled and packets filled
		myData->bytesFilled += packetSize;
		myData->packetsFilled++;
		
		
		// if that was the last free packet description, then enqueue the buffer.
		size_t packetsDescsRemaining = kAQMaxPacketDescs - myData->packetsFilled;
		if (packetsDescsRemaining == 0 || ghackApr29_finished_loading ) {			
			MyEnqueueBuffer(myData);

			// [todo] -- when is the appropriate time to call this?
			//err = AudioQueueFlush(myData->audioQueue);
			//if (err) { PRINTERROR("AudioQueueFlush"); return 1; }
		}
		
		// [note] -- this is probably a logic bug;  if the stream is done loading
		//    then it should enqueue the remainder and not wait until kAQMax etc...
		
	}	
}


// --------------------------------------------------------------------------------
// audio delegate with worker thread for audio pump
// --------------------------------------------------------------------------------

#pragma mark ----------
#pragma mark asynaudio_II
#pragma mark ----------

@implementation asyncaudio_II

@synthesize myd_;
@synthesize bytesloaded_;

-(id)init
{
	workerThread_ = NULL;
	myd_ = NULL;
		
	// allocate a struct for storing our state
	myd_ = (AudioData*)calloc(1, sizeof(AudioData));
	
	myd_ -> started = false;
	myd_ -> endAudioData = false;
	myd_ -> failed = false;

	bytesloaded_ = 0;
	
	// initialize a mutex and condition so that we can block on buffers in use.
	pthread_mutex_init(&myd_->mutex, NULL);
	pthread_cond_init(&myd_->cond, NULL);	
	
	// make sure that the audio can be played when the phone/iPod goes to sleep
	AudioSessionInitialize(NULL, NULL, NULL, NULL);
	
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof( sessionCategory ), &sessionCategory);
	AudioSessionSetActive( YES );
	
	// create an audio file stream parser 
	OSStatus err = AudioFileStreamOpen(myd_, MyPropertyListenerProc, MyPacketsProc, 
									   kAudioFileMP3Type, //kAudioFileAAC_ADTSType, 
									   &myd_->audioFileStream);
	if (err) { PRINTERROR("AudioFileStreamOpen"); return nil; }
	

	
	// network buffer mutex/cond
	pthread_mutex_init(&mutex_, NULL);
	pthread_cond_init(&cond_, NULL);
	pthread_cond_init(&workerdone_,NULL);
	datalist_ = [[NSMutableArray arrayWithCapacity:20] retain];		
	
	running_ = TRUE;
	[self launchworker];
	
	return self;
}

-(void) dealloc
{
  if(myd_) {
	  free(myd_);
  }
	
  [datalist_ release];
  pthread_mutex_destroy(&mutex_);
  pthread_cond_destroy(&cond_);
  [super dealloc];
}

-(BOOL) isrunning
{
	return running_;
}





-(void) cancel
{
	if( myd_ && running_ )
	{
		pthread_mutex_lock(&mutex_); 
		{		
#ifdef APR29_LATEST_HACKS
			myd_ -> endAudioData = true;
			myd_ -> failed = true;
#endif
			
			[datalist_ removeAllObjects];
			running_ = FALSE;				
			// [note] -- forcing enqueue to quit here.
			pthread_cond_signal(&myd_->cond);
			pthread_cond_signal(&cond_);
		}
		pthread_mutex_unlock(&mutex_);	
	
		// wait for worker thread to say it's done.
		//dbg_printf( "waiting for workerthread\n" );
		pthread_mutex_lock(&mutex_); 
		{	
			pthread_cond_wait(&workerdone_, &mutex_);		
		}
		pthread_mutex_unlock(&mutex_);		
		//dbg_printf( "workerdone signalled ... waiting for workerthread\n" );	
	}
}


// communication callback (thread)
-(void) produce:(NSData*)data
{
  pthread_mutex_lock(&mutex_); 
  {
	  if( data ) {
		  [datalist_ addObject:data];
	  } else {
		 // dataConnectionIsFinished_ = TRUE;
	  }
	  
	pthread_cond_signal(&cond_);
  }
  pthread_mutex_unlock(&mutex_);
}

//
// audio pump (worker thread)
//    takes blocks from the network connection and feeds into audio
//    buffer queues.
//
-(void) consumer
{
  for( ;running_ || [datalist_ count]>0; )
	{
		if( myd_->failed || myd_->endAudioData ) {
			break;
		}
		
	  NSData *data = NULL;		
	  pthread_mutex_lock(&mutex_); 
		{
			// [todo] -- this is a bug -- need something to mark that data conneciton is done.
			// so we don't wait.
		   
		  while (running_ && ![datalist_ count]) {
			pthread_cond_wait(&cond_, &mutex_);
			  
			  if( myd_->failed || myd_->endAudioData ) {
				  break;
			  }			  
		  }

			if( myd_->failed || myd_->endAudioData ) {
			} else {
				
				  ////dbg_printf( "audioChunks(consume): %d, running:%d\n", [datalist_ count], (int) running_ );			
				  if( [datalist_ count] ) {
					  data = [[datalist_ objectAtIndex:0] retain];
					  [datalist_ removeObjectAtIndex:0];
					  // [opt] prefer swap(last,0), removeLast;
				  }
			}
		}
	  pthread_mutex_unlock(&mutex_);

		if( myd_->failed || myd_->endAudioData ) {
			break;
		}
		
	  // note -- 
	  // this blocks/waits until the audio can process it.
		if( data && !myd_->failed && !myd_->endAudioData) 
		{
		  OSStatus err;
		  err = AudioFileStreamParseBytes(myd_->audioFileStream, [data length], [data bytes], 0);
		  checkstatus(err);
		  [data release];
		}		
	}  

		
	if(0) 
	{
		//dbg_printf( "waiting for audioqueue listener marked as done\n" );
		pthread_mutex_lock(&mutex_); 
		{	
			// [todo] -- probably need a new condition var here.
			pthread_cond_wait(&cond_, &mutex_);		
		}
		pthread_mutex_unlock(&mutex_);		
	}
	
	if(1)
	{
		//dbg_printf( "closingdown audio.\n" );
		OSStatus err;	
		err = AudioQueueStop(myd_->audioQueue_, TRUE);
		err = AudioFileStreamClose(myd_->audioFileStream);
		err = AudioQueueDispose(myd_->audioQueue_, false);
	}
	
	pthread_mutex_lock(&mutex_); 
	{	
		//dbg_printf( "signal audio.\n" );
		running_ = FALSE;
		pthread_cond_signal(&workerdone_);
	}
	pthread_mutex_unlock(&mutex_);
}

static void* workerthread( void* pv )
{
  asyncaudio_II *aa = (asyncaudio_II*)pv;
  [aa consumer];
	
  //dbg_printf( "worker thread exiting\n" );	
  return NULL;
}

-(bool)launchworker
{
	if( pthread_create( &workerThread_, NULL, workerthread, self ) )
		return FALSE;
	
  return TRUE;
}

#pragma mark ----------
#pragma mark nsconnection delegate
#pragma mark ----------

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  //dbg_printf( "asyncaudio: didFailWithError:%s\n", [[error localizedDescription] UTF8String] );
  [self cancel];
	// [todo] -- delegate failed.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	bytesloaded_ += [data length];

  [self produce:[NSData dataWithData:data]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//dbg_printf( "connectionDidFinishLoading\n" );

#ifdef APR29_LATEST_HACKS	
	ghackApr29_finished_loading = 1;
#endif
	
	[self produce:NULL];
}


- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse*)aResponse;
    if (response) {
		
		if( response.statusCode == 200 )
		{
			; // no error
		}
		else
		{
			//dbg_printf( "connection response: %d(%s)\n", (int) response.statusCode, 
			//	   [[NSHTTPURLResponse localizedStringForStatusCode:response.statusCode] UTF8String] );

			// 
			// we'll let the client do this
			// [self cancel];
			// 

			[[NSNotificationCenter defaultCenter] postNotificationName:@"connectionError" object:nil];			
		}
    }
}


@end


// --------------------------------------------------------------------------------


#pragma mark ----------
#pragma mark audiohelp_II
#pragma mark ----------

@implementation audiohelp_II

@synthesize tracksize_;
@synthesize paused_;

- (id) init
{	
	[super init];
	asyncaudio_ = nil;
	connection_ = nil;
	return self;
}

- (void) dealloc
{
	[asyncaudio_ release];
	[connection_ release];
	[super dealloc];
}



- (void) play:(NSString*)strurl
{
	[self cancel];	
	
	ghackApr29_finished_loading = 0;
	
	asyncaudio_ = [[asyncaudio_II alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURL    *url = [NSURL URLWithString:strurl];	
	connection_ = [[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url]   
												 delegate:asyncaudio_] retain];
	
	//dbg_printf( "audio async request in flight:%s\n", [strurl UTF8String] );	
}




-(void) setvolume:(float)volume
{
	if( asyncaudio_ && asyncaudio_.myd_ ) {
		AudioQueueSetParameter( asyncaudio_.myd_->audioQueue_, kAudioQueueParam_Volume, volume);
		g_hackVolume = volume;
	}
}

/*
- (void)seekToPacket:(NSNumber *)packet
{.
    aqData.mCurrentPacket = packet.longLongValue;
    aqData.mStartPacket = aqData.mCurrentPacket;
    NSLog(@"%s Attempting to seek to packet %qi", _cmd, aqData.mStartPacket);
    
    [self logError:AudioQueueStop(aqData.mQueue, true)];
    
}  
*/

-(float) percentLoaded
{
	if( !connection_ || !asyncaudio_)
		return 0;
	
	return asyncaudio_.bytesloaded_; 
}

-(BOOL) hasfinished
{
	if (!ghackApr29_finished_loading)
		return false;
	
	for (int i=0; i<kNumAQBufs; ++i) {
		if (asyncaudio_.myd_->inuse[i]) {
			return false;
		}
	}
	
	return TRUE;
}

-(float) percentage
{	
	if( !asyncaudio_ ) {
		return -1.0;
	}

	AudioTimeStamp timeStamp;
	AudioQueueGetCurrentTime(asyncaudio_.myd_->audioQueue_,NULL,&timeStamp,NULL);
  
	double t = timeStamp.mSampleTime;
	
	Float64	sampleRate     = 0;
	UInt32  sampleRateSize = sizeof( sampleRate );
	AudioQueueGetProperty( asyncaudio_.myd_->audioQueue_, kAudioQueueDeviceProperty_SampleRate, 
                            &sampleRate, &sampleRateSize ); 
	
	////dbg_printf ("sample : %f %d\n", fsampleRate, sampleRateSize );

	if( sampleRateSize != sizeof( sampleRate ) || sampleRate == 0 ) {
		t = 0;
	}
    else {
        // convert from millseconds.
        t /= (sampleRate/1000);
    }
	
	return t;
}


-(BOOL) isrunning
{
	return [asyncaudio_ isrunning];
}


-(void) pause
{
	if( paused_ )
		AudioQueueStart( asyncaudio_.myd_->audioQueue_, &asyncaudio_.myd_->pausedTimeStamp );
	else {
		AudioQueuePause( asyncaudio_.myd_->audioQueue_ );
		AudioQueueGetCurrentTime( asyncaudio_.myd_->audioQueue_, NULL, &(asyncaudio_.myd_->pausedTimeStamp), NULL);
	}
	paused_ = !paused_;
}


-(void) resume
{
	paused_ = !paused_;
	AudioQueueStart( asyncaudio_.myd_->audioQueue_, &asyncaudio_.myd_->pausedTimeStamp );
}


-(void) cancel
{	
	if( connection_ ) {
		[connection_ cancel];
		[connection_ release];
		connection_ = nil;
	}
	
	if( asyncaudio_ ) {
		[asyncaudio_ cancel];
		[asyncaudio_ release];
		asyncaudio_ = nil;
	}	
	
	paused_ = FALSE;
}

@end
