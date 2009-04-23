//
//  NowPlayingController.m
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//


#import "NowPlayingController.h"
//#import <MediaPlayer/MediaPlayer.h>

#import "appdata.h"

@implementation NowPlayingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}

	return self;
}

-(id)init 
{
	if (self = [super init]) {
		self.hidesBottomBarWhenPushed = TRUE;
	}
	return self;
}



/*
 Implement loadView if you want to create a view hierarchy programmatically
 */

#pragma mark
#pragma mark UISlider (Custom)
#pragma mark
- (void)create_Custom_UISlider:(CGRect)frame
{
	volume_ = [[UISlider alloc] initWithFrame:frame];
	[volume_ addTarget:self action:@selector(setvolume:) forControlEvents:UIControlEventValueChanged];

	// in case the parent view draws with a custom color or gradient, use a transparent color
	volume_.backgroundColor = [UIColor clearColor];	
	//UIImage *stetchLeftTrack = [[UIImage imageNamed:@"orangeslide.png"]
	//							stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	//UIImage *stetchRightTrack = [[UIImage imageNamed:@"yellowslide.png"]
	//							 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	[volume_ setThumbImage: [UIImage imageNamed:@"slider_ball_bw.png"] forState:UIControlStateNormal];
	//[volume_ setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
	//[volume_ setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
	volume_.minimumValue = 0.0;
	volume_.maximumValue = 1.0;
	volume_.continuous = YES;
	volume_.value = 1.0;
	volume_.alpha = 1.000;
	volume_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	volume_.clearsContextBeforeDrawing = YES;
	volume_.clipsToBounds = YES;
	
	
	UIImage *stetchLeftTrack = [[UIImage imageNamed:@"leftslide.png"]
								stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"rightslide.png"]
								 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	//    [customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
    [volume_ setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [volume_ setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
	[volume_ setMinimumValueImage:[UIImage imageNamed:@"SpeakerSoft.tif"]];
	[volume_ setMaximumValueImage:[UIImage imageNamed:@"SpeakerLoud.tif"]];
		
}

/*
- (MPVolumeView *)create_Custom_VolumeBar: (CGRect)frame
{
	// create a frame to hold the MPVolumeView
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:frame] autorelease];
	[volumeView sizeToFit];
	
	// Find the volume view slider - we'll need to reference it in volumeChanged:
	for (UIView *view in [volumeView subviews]){
		if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
			volumeviewslider_ = view;
		}
	}
	
	UIImage *stetchLeftTrack = [[UIImage imageNamed:@"leftslide.png"]
								stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"rightslide.png"]
								 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	//    [customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
    [volumeviewslider_ setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [volumeviewslider_ setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
	[volumeviewslider_ setMinimumValueImage:[UIImage imageNamed:@"SpeakerSoft.tif"]];
	[volumeviewslider_ setMaximumValueImage:[UIImage imageNamed:@"SpeakerLoud.tif"]];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
										  selector:@selector(volumeChanged:) 
										  name:@"AVSystemController_SystemVolumeDidChangeNotification" 
										  object:nil];
	
	return volumeView;
}


- (void) volumeChanged:(NSNotification *)notify
{
	//NSLog(@"volume changed");
	[volumeviewslider_ _updateVolumeFromAVSystemController];
}
*/

- (void)loadView 
{
	
	UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 436.0)];
	mainview.frame = CGRectMake(0.0, 0.0, 320.0, 436.0);
	mainview.alpha = 1.000;
	mainview.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	mainview.backgroundColor = [UIColor colorWithRed:0.114 green:0.110 blue:0.090 alpha:1.000];
	mainview.clearsContextBeforeDrawing = YES;
	mainview.clipsToBounds = NO;
	mainview.contentMode = UIViewContentModeScaleToFill;
	mainview.hidden = NO;
	mainview.multipleTouchEnabled = NO;
	mainview.opaque = YES;
	mainview.tag = 0;
	mainview.userInteractionEnabled = YES;

	progbar_ = [[UIProgressView alloc] initWithFrame:CGRectMake(18.0, 340.0, 284.0, 23.0)];
	//progbar_ = [[UIProgressView alloc] initWithFrame:CGRectMake(18.0, 396.0, 200.0, 23.0)];
	progbar_.alpha = 1.000;
	progbar_.clearsContextBeforeDrawing = YES;
	progbar_.clipsToBounds = YES;
	progbar_.progressViewStyle = UIProgressViewStyleDefault;
	progbar_.contentMode = UIViewContentModeScaleToFill;
	progbar_.multipleTouchEnabled = YES;
	progbar_.opaque = NO;
	progbar_.tag = 0;
	progbar_.userInteractionEnabled = YES;
	progbar_.progress = 0.000;
	
	CGRect volframe = CGRectMake(81.0, 305.0, 147.0, 23.0);
	[self create_Custom_UISlider:volframe];
	//MPVolumeView *volumeview = [self create_Custom_VolumeBar:volframe];
 	
	UILabel *volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 305.0, 55.0, 21.0)];
	volumeLabel.adjustsFontSizeToFitWidth = YES;
	volumeLabel.alpha = 1.000;
	volumeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	volumeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	volumeLabel.clearsContextBeforeDrawing = YES;
	volumeLabel.clipsToBounds = YES;
	volumeLabel.contentMode = UIViewContentModeScaleToFill;
	volumeLabel.enabled = YES;
	volumeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.000];
	volumeLabel.hidden = NO;
	volumeLabel.lineBreakMode = UILineBreakModeTailTruncation;
	volumeLabel.minimumFontSize = 10.000;
	volumeLabel.multipleTouchEnabled = NO;
	volumeLabel.numberOfLines = 1;
	volumeLabel.opaque = NO;
	volumeLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	volumeLabel.tag = 0;
	volumeLabel.text = @"Volume";
	volumeLabel.textAlignment = UITextAlignmentCenter;
	volumeLabel.textColor = [UIColor colorWithRed:0.913 green:0.913 blue:0.913 alpha:1.000];
	volumeLabel.backgroundColor = [UIColor clearColor];
	volumeLabel.userInteractionEnabled = NO;
	
	trackinfo_ = [[UITextView alloc] initWithFrame:CGRectMake(34.0, 270.0, 240.0, 34.0)];
	trackinfo_.alpha = 1.000;
	trackinfo_.alwaysBounceHorizontal = NO;
	trackinfo_.alwaysBounceVertical = NO;
	trackinfo_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	trackinfo_.bounces = YES;
	trackinfo_.bouncesZoom = NO;
	trackinfo_.canCancelContentTouches = NO;
	trackinfo_.clearsContextBeforeDrawing = YES;
	trackinfo_.clipsToBounds = YES;
	trackinfo_.contentMode = UIViewContentModeScaleToFill;
	trackinfo_.delaysContentTouches = NO;
	trackinfo_.directionalLockEnabled = NO;
	trackinfo_.editable = YES;
	trackinfo_.font = [UIFont fontWithName:@"Helvetica" size:17.000];
	trackinfo_.hidden = NO;
	trackinfo_.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	trackinfo_.maximumZoomScale = 0.000;
	trackinfo_.minimumZoomScale = 0.000;
	trackinfo_.multipleTouchEnabled = NO;
	trackinfo_.opaque = NO;
	trackinfo_.pagingEnabled = NO;
	trackinfo_.scrollEnabled = YES;
	trackinfo_.showsHorizontalScrollIndicator = NO;
	trackinfo_.showsVerticalScrollIndicator = YES;
	trackinfo_.tag = 0;
	trackinfo_.text = @"";
	trackinfo_.textAlignment = UITextAlignmentLeft;
	trackinfo_.backgroundColor = [UIColor clearColor];
	trackinfo_.textColor = [UIColor colorWithRed:0.913 green:0.913 blue:0.913 alpha:1.000];
	trackinfo_.userInteractionEnabled = NO;
	
	
	toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 392.0, 320.0, 44.0)];
	//toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 360.0, 320.0, 44.0)];
	toolbar_.alpha = 1.000;
	toolbar_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	toolbar_.barStyle = UIBarStyleBlackTranslucent;
	toolbar_.clearsContextBeforeDrawing = NO;
	toolbar_.clipsToBounds = NO;
	toolbar_.contentMode = UIViewContentModeBottom;
	toolbar_.hidden = NO;
	toolbar_.multipleTouchEnabled = NO;
	toolbar_.opaque = NO;
	toolbar_.tag = 0;
	toolbar_.userInteractionEnabled = YES;
	toolbar_.backgroundColor = [UIColor clearColor];
	
	flexbeg_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	flexbeg_.enabled = YES;
	flexbeg_.style = UIBarButtonItemStylePlain;
	flexbeg_.tag = 0;
	flexbeg_.width = 0.000;
	
	prev_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind 
														  target:self	action:@selector(prev:)];
	prev_.enabled = YES;
	prev_.style = UIBarButtonItemStylePlain;
	prev_.tag = 0;
	prev_.width = 0.000;
	
	fixedprev_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
															target:nil action:nil];
	fixedprev_.enabled = YES;
	fixedprev_.style = UIBarButtonItemStylePlain;
	fixedprev_.tag = 0;
	fixedprev_.width = 20.000;
	
	stop_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
														  target:self action:@selector(stop:)];
	stop_.enabled = YES;
	stop_.style = UIBarButtonItemStylePlain;
	stop_.tag = 0;
	stop_.width = 0.000;
	
	pause_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause 
														   target:self action:@selector(pause:)];
	pause_.enabled = YES;
	pause_.style = UIBarButtonItemStylePlain;
	pause_.tag = 0;
	pause_.width = 0.000;
	
	fixedpause_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
															target:nil action:nil];
	fixedpause_.enabled = YES;
	fixedpause_.style = UIBarButtonItemStylePlain;
	fixedpause_.tag = 0;
	fixedpause_.width = 20.000;
	
	play_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
														  target:self action:@selector(play:)];
	play_.enabled = YES;
	play_.style = UIBarButtonItemStylePlain;
	play_.tag = 0;
	play_.width = 0.000;
		
	
	fixedplay_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedplay_.enabled = YES;
	fixedplay_.style = UIBarButtonItemStylePlain;
	fixedplay_.tag = 0;
	fixedplay_.width = 20.000;
	
	next_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward 
														  target:self action:@selector(next:)];
	next_.enabled = YES;
	next_.style = UIBarButtonItemStylePlain;
	next_.tag = 0;
	next_.width = 0.000;

	flexend_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	flexend_.enabled = YES;
	flexend_.style = UIBarButtonItemStylePlain;
	flexend_.tag = 0;
	flexend_.width = 0.000;
	
	albumcover_ = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 55.0, 280.0, 176.0)];
	albumcover_.frame                      = CGRectMake(20.0, 55.0, 280.0, 176.0);
	albumcover_.alpha                      = 1.000;
	albumcover_.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	albumcover_.clearsContextBeforeDrawing = NO;
	albumcover_.clipsToBounds              = NO;
	albumcover_.contentMode                = UIViewContentModeScaleAspectFill;
	albumcover_.hidden                     = NO;
	albumcover_.image                      = nil;
	albumcover_.multipleTouchEnabled       = NO;
	albumcover_.opaque                     = NO;
	albumcover_.tag                        = 0;
	albumcover_.userInteractionEnabled     = NO;
	
	AppData *app = [AppData get];
   	if( [app isrunning] ) {
		[toolbar_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_, stop_, 
							fixedpause_, pause_,  fixedplay_, next_, flexend_, nil]]; 
	}
	else {
		[toolbar_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_, stop_, 
							fixedpause_, play_,  fixedplay_, next_, flexend_, nil]];
	}
	[mainview addSubview:toolbar_];
	[mainview addSubview:albumcover_];
	[mainview addSubview:progbar_];
	[mainview addSubview:volume_];
	//[mainview addSubview:volumeLabel];
	//[mainview addSubview:volumeview];
	[mainview addSubview:trackinfo_];
	
	self.view = mainview;	
}


- (void)artworkReady:(NSObject*)notification
{
	AppData *app = [AppData get];
	UIImage *img = app.artwork_;
	if( img ) {
		albumcover_.image = img;
	} else {
		albumcover_.image = [UIImage imageNamed:@"airband.png"];
	}
	[img drawInRect: CGRectMake(0.0f, 0.0f, 100.0f, 60.0f)]; // Draw in a custom rect.

	//UIImageView *imageView = [ [ UIImageView alloc ] initWithImage: albumcover_.image];
	//imageView.frame = CGRectMake(20.0, 55.0, 280.0, 176.0);
	//[self.view addSubview: imageView]; // Draw the image in self.view.

	trackinfo_.text = app.currentTrackTitle_;
}

- (void)viewDidLoad 
{
	AppData *app = [AppData get];
	printf("C: %d", [app isrunning] );

	if( [app isrunning] ) {
		[toolbar_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_, 
							pause_,  fixedplay_, next_, flexend_, nil]]; 
	}
	else {
		[toolbar_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_, 
							play_,  fixedplay_, next_, flexend_, nil]];
	}
   	// setup timer.
	if( 1 )
	{
		[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.5 
										 target:self 
									   selector:@selector(myTimerFireMethod:)
									   userInfo:NULL repeats:YES ];
	}
}

- (void)nextTrack
{
    AppData *app = [AppData get];
    
    int index = [app currentTrackIndex_];
    if( ++index >= ([app.trackList_ count]-1) ) 
        index = 0;
    
    [app setCurrentTrackIndex_:index];
    NSDictionary *d = [app.trackList_ objectAtIndex:index];
    [app playTrack:d];
}

- (void)prevTrack
{
    AppData *app = [AppData get];
    
    int index = [app currentTrackIndex_];
    if( --index <=  0) 
        index = [app.trackList_ count] - 2;
    
    [app setCurrentTrackIndex_:index];
    NSDictionary *d = [app.trackList_ objectAtIndex:index];
    [app playTrack:d];
}


- (void)myTimerFireMethod:(NSTimer*)theTimer
{
	AppData *app = [AppData get];
    //printf("C: %d %d", [app.trackList_ count], [app currentTrackIndex_]);
   	if( [app isrunning] ) {
		float cur = [app percent]/44.1;
        float len = [app tracklength];
		//printf( "myTimer fired, percent: %f %f\n", cur, len );
        if( cur >= len ) {
			//[progbar_ setValue:0.0 animated:YES];
            [progbar_ setProgress:0.0];
			[self nextTrack];
            //[app stop];
        }
		else {
			float per = cur/len;
			//[progbar_ setValue:per animated:YES];
			[progbar_ setProgress:per];
		}
	}
	
	/*
	if( 0 ){
		[UIView beginAnimations:@"thump" context:nil];
		[UIView setAnimationDuration:2.9];	
		self.transform = CGAffineTransformMakeRotation(.5-drand48());
		self.alpha = 1-.1*drand48();
		[UIView setAnimationRepeatAutoreverses:YES];			
		[UIView commitAnimations];	
	}
	 */
}


- (void) titleAvailable:(NSNotification*)notification
{
	NSDictionary *d     = notification.userInfo;
	NSString *title     = [d objectForKey:@"trackTitle"];

	trackinfo_.text = title;
}



- (void)viewDidAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(artworkReady:) 
												 name:@"artworkReady" 
											   object:nil];	

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(titleAvailable:) 
												 name:@"titleAvailable" 
											   object:nil];	
	[self artworkReady:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction) setvolume:(id)sender
{	
	[[AppData get] setvolume:[volume_ value]];
}


-(IBAction) random:(id)sender
{
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	int index = drand48() * [fullList count];
	
	NSDictionary *d = [fullList objectAtIndex:index];
	trackinfo_.text = [d objectForKey:@"albumTitle"];
	
	[app play:d];
}
	

-(IBAction) taptap:(id)sender
{
}

-(IBAction) play:(id)sender
{
	AppData *app = [AppData get];

	if( paused_ ) {
		[app resume];
		[toolbar_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_,
							pause_,  fixedplay_, next_, flexend_, nil]];
	}
    else {
		int index = [app currentTrackIndex_];
		NSDictionary *d = [app.trackList_ objectAtIndex:index];
		[app playTrack:d];
	}
}

-(IBAction) next:(id)sender
{
    [self nextTrack];
}

-(IBAction) prev:(id)sender
{
    [self prevTrack];
}


-(IBAction) pause:(id)sender
{
	paused_ = true;
	
	[toolbar_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_,
						play_,  fixedplay_, next_, flexend_, nil]];
	[[AppData get] pause];
	//[[AppData get] stop];
}

-(IBAction) stop:(id)sender
{
	paused_ = false;
	[[AppData get] stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}



/**
 UIActionSheet
 
- (void)loadFlipsideViewController {
	PreferencesViewController *viewController = [[PreferencesViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];
	self.preferencesViewController = viewController;
	preferencesViewController.rootViewController = self;
	[viewController release];
}


- (IBAction)toggleView:(id)sender {	
	// This method is called when the info or Done button is pressed.
	// It flips the displayed view from the main view to the flipside view and vice-versa.
	
	if (preferencesViewController == nil) {
		[self loadFlipsideViewController];
	}
	
	UIView *mainView = metronomeViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight) forView:self.view cache:YES];
	
	UIView *flipsideView = preferencesViewController.view;
	if ([mainView superview] != nil) {
		[mainView removeFromSuperview];
		[self.view addSubview:flipsideView];
	} else {
		[flipsideView removeFromSuperview];
		[self.view addSubview:mainView];
	}
	[UIView commitAnimations];
}

**/


@end
