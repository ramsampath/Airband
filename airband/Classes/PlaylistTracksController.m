//
//  PlaylistTracksController.m
//  airband
//
//  Created by Scot Shinderman on 9/7/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import "PlaylistTracksController.h"
#import "NowPlayingController.h"
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
 */
- (void)loadView 
{
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 387.0)];
    mainview.frame = CGRectMake(0.0, 0.0, 320.0, 387.0);
    mainview.alpha = 1.000;
    mainview.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    //mainview.backgroundColor = [UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.000];
    mainview.clearsContextBeforeDrawing = NO;
    mainview.clipsToBounds = NO;
    mainview.contentMode = UIViewContentModeScaleAspectFit;
    mainview.hidden = NO;
    mainview.multipleTouchEnabled = NO;
    mainview.opaque = YES;
    mainview.tag = 0;
    mainview.userInteractionEnabled = YES;
    mainview.backgroundColor            = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd.png"]];

    table_ = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 387.0)
                style:UITableViewStylePlain];
    table_.delegate                       = self;
    table_.dataSource                     = self;
    table_.allowsSelectionDuringEditing   = NO;
    table_.alpha                          = 1.000;
    table_.alwaysBounceHorizontal         = NO;
    table_.alwaysBounceVertical           = NO;
    table_.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //table_.backgroundColor                = [UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.000];
    table_.backgroundColor                = [UIColor clearColor];
    table_.bounces                        = YES;
    table_.bouncesZoom                    = YES;
    table_.canCancelContentTouches        = YES;
    table_.clearsContextBeforeDrawing     = NO;
    table_.clipsToBounds                  = YES;
    table_.contentMode                    = UIViewContentModeBottom;
    table_.delaysContentTouches           = YES;
    table_.directionalLockEnabled         = NO;
    table_.hidden                         = NO;
    table_.indicatorStyle                 = UIScrollViewIndicatorStyleDefault;
    table_.maximumZoomScale               = 1.000;
    table_.minimumZoomScale               = 1.000;
    table_.multipleTouchEnabled           = NO;
    table_.opaque                         = NO;
    table_.pagingEnabled                  = NO;
    table_.scrollEnabled                  = YES;
    table_.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    table_.showsHorizontalScrollIndicator = YES;
    table_.showsVerticalScrollIndicator   = YES;
    table_.tag = 0;
    table_.userInteractionEnabled         = YES;
    
    [mainview addSubview:table_];
    
    self.view = mainview;
}


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
	
	UINavigationBar *bar = [self navigationController].navigationBar;
	bar.barStyle = UIBarStyleBlackOpaque;;

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

- (void) nowPlaying:(id) sender
{
      NowPlayingController *nowplayingVC = [[NowPlayingController alloc] initWithNibName:@"NowPlayingArranged" bundle:nil];    
    
	nowplayingVC.hidesBottomBarWhenPushed = TRUE;
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
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStyleBordered
                                                                                target:self action:@selector(nowPlaying:)];
        
		[[self navigationController] pushViewController:traxcontroller animated:YES];
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStyleBordered
                                                                                target:self action:@selector(nowPlaying:)];
	}
	else if( albumtracks_ )
	{

		NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];
        //NowPlayingController *nowplayingVC = [[NowPlayingController alloc] initWithNibName:@"NowPlayingArranged" bundle:nil];
        NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];
        nowplayingVC.navigationItem.title = [d objectForKey:@""];

		[nowplayingVC.navigationItem 
		 setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
																style:UIBarButtonItemStylePlain 
															   target:nil 
															   action:nil]];
        [self navigationController].navigationBarHidden = FALSE;
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStyleBordered
                                                                                target:self action:@selector(nowPlaying:)];
		[app playTrack:d];

		[[self navigationController] pushViewController:nowplayingVC animated:YES];		
        

        
        [app setCurrentTrackIndex_:[indexPath row]];
        [nowplayingVC release];
	}
	else if( playlist_ ) 
	{
		NSDictionary *d = [app.currentTracklist_ objectAtIndex:[indexPath row]];	
        
        //NowPlayingController *nowplayingVC = [[NowPlayingController alloc] initWithNibName:@"NowPlayingArranged" bundle:nil];
        NowPlayingController *nowplayingVC = [NowPlayingController alloc];
        
        nowplayingVC.navigationItem.title = [d objectForKey:@""];
		[nowplayingVC.navigationItem 
		 setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
																style:UIBarButtonItemStylePlain 
															   target:nil 
															   action:nil]];        
        [self navigationController].navigationBarHidden = FALSE;
		[app playTrack:d];

		[[self navigationController] pushViewController:nowplayingVC animated:YES];		

        [nowplayingVC release];
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
    cell.textColor            = [UIColor whiteColor];

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
