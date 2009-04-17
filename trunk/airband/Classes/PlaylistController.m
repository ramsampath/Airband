//
//  PlaylistController.m
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import "PlaylistController.h"
#import "PlaylistTracksController.h"
#import "NowPlayingController.h"

#import "appdata.h"


@implementation PlaylistController

@synthesize table_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
- (void)loadView {}
*/


- (void) playListsReady:(id)object
{
	AppData *app = [AppData get];
	int num = [app.playLists_ count];

	NSMutableArray *indexPath = [[[NSMutableArray alloc] init] retain];  // autorelease?

	int i;
	for (i=0;  i<num; ++i) {
		[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}        
	
	
	if( [table_ numberOfRowsInSection:0] )
	{
		[table_ reloadData];
	}
	else
	{
		[table_ beginUpdates];
		[table_	insertRowsAtIndexPaths:indexPath 
									withRowAnimation:UITableViewRowAnimationFade];
		[table_ endUpdates];    			
	}	
}

- (void)viewDidLoad
{	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(playListsReady:) 
												 name:@"playListsReady" 
											   object:nil];	

	UINavigationBar *bar = [self navigationController].navigationBar;
	bar.barStyle = UIBarStyleBlackOpaque;;

	AppData *app = [AppData get];
	[app getPlayListsAsync];
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


- (void) nowPlaying:(id) sender
{
    NowPlayingController *nowplayingVC = [[NowPlayingController alloc] initWithNibName:@"NowPlayingArranged" bundle:nil];    
    
    [nowplayingVC.navigationItem 
     setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
                                                            style:UIBarButtonItemStylePlain 
                                                           target:nil 
                                                           action:nil]];
    
    [[self navigationController] pushViewController:nowplayingVC animated:YES];		
    
    [nowplayingVC release];
    return;
}

#pragma mark ------------------------------------------------
#pragma mark UITableView delegates
#pragma mark ------------------------------------------------

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Create a view controller with the title as its navigation title and push it.
    NSUInteger row = indexPath.row;
    if (row == NSNotFound) 
		return;
	
	AppData *app = [AppData get];			
	NSDictionary *d = [app.playLists_ objectAtIndex:[indexPath row]];
	
	PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] initWithNibName:@"PlaylistTracks" bundle:nil];	
	traxcontroller.playlist_ = d;
	
	traxcontroller.navigationItem.title = [d objectForKey:@"playlistTitle"];
	[traxcontroller.navigationItem 
	 setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
															style:UIBarButtonItemStylePlain 
														   target:nil 
														   action:nil]];
    [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                            initWithTitle:@"Now Playing"
                                                                            style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(nowPlaying:)];
	[[self navigationController] pushViewController:traxcontroller animated:YES];
}

#pragma mark ------------------------------------------------
#pragma mark UITableView datasource methods
#pragma mark ------------------------------------------------

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	AppData *app = [AppData get];		
	return [app.playLists_ count];
}


 - (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	 UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"myid2"];
	 if (cell == nil) {
		 cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"myid2"] autorelease];
		 cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	 }

	 AppData *app = [AppData get];		
	 NSDictionary *d = [app.playLists_ objectAtIndex:[indexPath row]];
	cell.text = [d objectForKey:@"playlistTitle"];
	 	
	 //NSString *imagePath = [[NSBundle mainBundle] pathForResource:[cell.text lowercaseString]  ofType:@"png"];
	 //UIImage *icon = [UIImage imageWithContentsOfFile:imagePath]; 
	 //cell.image = icon;
	 
	 return cell;
 }


@end
