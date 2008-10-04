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
