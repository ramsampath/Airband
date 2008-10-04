//
//  PlaylistTracksController.m
//  airband
//
//  Created by Scot Shinderman on 9/7/08.
//  Copyright 2008 Imageworks. All rights reserved.
//

#import "PlaylistTracksController.h"
#import "appdata.h"

@implementation PlaylistTracksController

@synthesize table_;
@synthesize playlist_;
@synthesize artist_;
@synthesize albumtracks_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		playlist_ = nil;
		artist_ = nil;
		albumtracks_ = nil;
	}
	return self;
}

/* Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {}
 */

- (void) newlistReady:(id)object
{	
	if( [table_ numberOfRowsInSection:0] ) {
		[table_ reloadData];
	} else {
		
		AppData *app = [AppData get];
		int num=0;
		
		if( playlist_ )
			num = [app.currentTracklist_ count];	
		else if( artist_ )
			num = [app.albumList_ count];
		else if( albumtracks_ )
			num = [app.trackList_ count];
			
		NSMutableArray *indexPath = [[[NSMutableArray alloc] init] retain];  // autorelease?	
		int i;
		for (i=0;  i<num; ++i) {
			[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		}        
		
		
		[table_ beginUpdates];
		[table_	insertRowsAtIndexPaths:indexPath 
					  withRowAnimation:UITableViewRowAnimationFade];
		[table_ endUpdates];    			
	}	
}


- (void)viewDidLoad 
{		
	NSString *waitfor;
	if( artist_ ) {
		waitfor = @"albumListReady";
	} else if( playlist_ ) {
		waitfor = @"playListTracksReady";
	} else if( albumtracks_ ) {
		waitfor = @"trackListReady";
	}
			
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(newlistReady:) 
												 name:waitfor 
											   object:nil];	
	
	
	AppData *app = [AppData get];	
	
	if( artist_ ) {
		NSString *req = [artist_ objectForKey:@"artistId"];
		[app getAlbumListAsync:req];
	} else if( albumtracks_ ) {
		NSString *req = [albumtracks_ objectForKey:@"albumId"];
		[app getTrackListAsync:req];		
	} else if( playlist_ ) {
		NSString *req = [playlist_ objectForKey:@"playlistId"];
		NSString *enc = [req stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];  //NSUTF8StringEncoding	
		[app getPlayListTracksAsync:enc];		
	}
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



#pragma mark ------------------------------------------------
#pragma mark UITableView delegates
#pragma mark ------------------------------------------------

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Create a view controller with the title as its navigation title and push it.
    NSUInteger row = indexPath.row;
    if (row == NSNotFound) 
		return;

	AppData *app = [AppData get];
	
	if( artist_ ) 
	{
		NSDictionary *d = [app.albumList_ objectAtIndex:[indexPath row]];
		
		PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] initWithNibName:@"PlaylistTracks" bundle:nil];	
		traxcontroller.albumtracks_ = d;
		
		traxcontroller.navigationItem.title = [d objectForKey:@"albumTitle"];
		[traxcontroller.navigationItem 
		 setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
																style:UIBarButtonItemStylePlain 
															   target:nil 
															   action:nil]];
		
		[[self navigationController] pushViewController:traxcontroller animated:YES];		
	}
	else if( albumtracks_ )
	{
		NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];	
		[app playTrack:d];
	}
	else if( playlist_ ) 
	{
		NSDictionary *d = [app.currentTracklist_ objectAtIndex:[indexPath row]];	
		[app playTrack:d];
	}
}

#pragma mark UITableView datasource methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	AppData *app = [AppData get];		
	if( playlist_ )
		return [app.currentTracklist_ count];
	else if( artist_ )
		return [app.albumList_ count];	
	else if( albumtracks_ )
		return [app.trackList_ count];
	
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"myid2"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"myid2"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	AppData *app = [AppData get];
	
	if( playlist_ ) {
		NSDictionary *d = [app.currentTracklist_ objectAtIndex:[indexPath row]];
		cell.text = [d objectForKey:@"trackTitle"];
	} else if( albumtracks_ ) {
		NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];
		cell.text = [d objectForKey:@"trackTitle"];		
	} else if( artist_ ) {
		NSDictionary *d = [app.albumList_ objectAtIndex:[indexPath row]];
		cell.text = [d objectForKey:@"albumTitle"];
	}
		
	return cell;
}

@end
