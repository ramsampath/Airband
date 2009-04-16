//
//  NowPlayingController.m
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import "NowPlayingController.h"
#import "appdata.h"

@implementation NowPlayingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
 */
/*
- (void)loadView {
 }
*/


- (void)artworkReady:(NSObject*)notification
{
	AppData *app = [AppData get];
	UIImage *img = app.artwork_;
	if( img ) {
		albumcover_.image = img;
	} else {
		albumcover_.image = [UIImage imageNamed:@"airband.png"];
	}
	
	trackinfo_.text = app.currentTrackTitle_;
}

- (void)viewDidLoad 
{
    
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
            [self nextTrack];
            //[app stop];
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
    
    int index = [app currentTrackIndex_];
    NSDictionary *d = [app.trackList_ objectAtIndex:index];
    [app playTrack:d];
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
