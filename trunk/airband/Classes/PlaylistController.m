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

#define kBgColor   [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1.000];
#define kScreenWidth 320

@implementation PlaylistController

@synthesize table_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}


- (void)loadView 
{
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
    mainview.frame = CGRectMake(0.0, 0.0, 320.0, 460.0);
    mainview.alpha = 1.000;
    mainview.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    //mainview.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    mainview.clearsContextBeforeDrawing = NO;
    mainview.clipsToBounds = NO;
    mainview.contentMode = UIViewContentModeScaleToFill;
    mainview.hidden = NO;
    mainview.multipleTouchEnabled = NO;
    mainview.opaque = YES;
    mainview.tag = 0;
    mainview.userInteractionEnabled = YES;
    mainview.backgroundColor            = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd.png"]];

    table_ = [[UITableView alloc] 
              initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0) 
              style:UITableViewStylePlain];
    table_.delegate   = self;
    table_.dataSource = self;
    table_.allowsSelectionDuringEditing = NO;
    table_.alpha = 1.000;
    table_.alwaysBounceHorizontal = NO;
    table_.alwaysBounceVertical = NO;
    table_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //table_.backgroundColor = [UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.000];
    table_.backgroundColor = [UIColor clearColor];
    table_.bounces = YES;
    table_.bouncesZoom = YES;
    table_.canCancelContentTouches = YES;
    table_.clearsContextBeforeDrawing = NO;
    table_.clipsToBounds = YES;
    table_.contentMode = UIViewContentModeScaleToFill;
    table_.delaysContentTouches = YES;
    table_.directionalLockEnabled = NO;
    table_.hidden = NO;
    table_.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    table_.maximumZoomScale = 1.000;
    table_.minimumZoomScale = 1.000;
    table_.multipleTouchEnabled = NO;
    table_.opaque = NO;
    table_.pagingEnabled = NO;
    table_.scrollEnabled = YES;
    table_.sectionIndexMinimumDisplayRowCount = 0;
    table_.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_.showsHorizontalScrollIndicator = YES;
    table_.showsVerticalScrollIndicator = YES;
    table_.tag = 0;
    table_.userInteractionEnabled = YES;
    
    [mainview addSubview:table_];

    
    self.view = mainview;
 
}

- (void)viewDidAppear:(BOOL)animated
{
    AppData *app = [AppData get];
    if( [app isrunning] )
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStyleBordered
                                                                                target:self action:@selector(nowPlaying:)];
}


- (void)viewDidLoad
{	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(playListsReady:) 
											name:@"playListsReady" 
											object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(connectionFailed:) 
												 name:@"connectionFailed"
											   object:nil];

	UINavigationBar *bar = [self navigationController].navigationBar;
	bar.barStyle         = UIBarStyleBlackOpaque;
    
    //
    // just to make sure that the progress view is released if its not released by now
    //
    if( progressView_ )
        [progressView_ removeFromSuperview];

    //
    // create a new progressView
    //
    progressView_                 = [[[UILabel alloc] initWithFrame:CGRectMake( kScreenWidth/2 - 250/2, 
                                                                               100, 250, 100)] retain];
    progressView_.backgroundColor = [UIColor clearColor];
    progressView_.backgroundColor = [UIColor clearColor];
    progressView_.alpha           = 1.0;
    
    [self.view addSubview:progressView_];
    //
    // release the progressview now as self.view should take care of it by now
    //
    [progressView_ release];

    //
    // [NOTE] retain the loadingView: this is not the recommendation from memory management
    //  but this is a special case due to callbacks and its made sure that loadingView_ is released later
    //
    loadingView_ = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Playlists..."] retain];
    
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

-(void) connectionFailed:(id)object
{
    //
    // Remove the loadingView which should remove the progressView_ as well
    //
    [loadingView_ removeView];
    //
    // set it to nil comfortably as it would have been released by now
    //
    loadingView_  = nil;
    progressView_ = nil;
}

- (void) playListsReady:(id)object
{
    // 
    // loadingView removeView calls removeFromSuperView which should release the progressView_
    //
    [loadingView_ removeView];
    //
    // so we can comfortably make progressView_ to nil as it should be released by now
    //
    progressView_ = nil;
    //
    // set it to nil 
    //
    loadingView_ = nil;
    
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


- (void) nowPlaying:(id) sender
{
    //NowPlayingController *nowplayingVC = [[NowPlayingController alloc] initWithNibName:@"NowPlayingArranged" bundle:nil];    
    NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];

    [nowplayingVC setupnavigationitems:self.navigationItem 
                                navBar:[self navigationController].navigationBar
                              datadict:nil];
    
    
    [[self navigationController] pushViewController:nowplayingVC animated:YES];		
    
    [nowplayingVC release];
    return;
}

#pragma mark ------------------------------------------------
#pragma mark UITableView delegates
#pragma mark ------------------------------------------------

/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}
 */


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Create a view controller with the title as its navigation title and push it.
    NSUInteger row = indexPath.row;
    if (row == NSNotFound) 
		return;
	
	AppData *app = [AppData get];			
	NSDictionary *d = [app.playLists_ objectAtIndex:[indexPath row]];
	
    /*
    PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] init];

	traxcontroller.playlist_ = d;
	
	traxcontroller.navigationItem.title = [d objectForKey:@"playlistTitle"];
    
    
	[[self navigationController] pushViewController:traxcontroller animated:YES];
     */    
    NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];
    
    [nowplayingVC setupnavigationitems:self.navigationItem 
                                navBar:[self navigationController].navigationBar
                              datadict:d];
    //
    // reset the artwork.
    //
    [nowplayingVC setArtwork:nil];

    [self navigationController].navigationBarHidden = FALSE;
    [[self navigationController] pushViewController:nowplayingVC animated:YES];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
#ifdef __IPHONE_3_0	
	cell.textLabel.textColor  = [UIColor whiteColor];
#else	
    cell.textColor            = [UIColor whiteColor];
#endif

	 AppData *app = [AppData get];		
	 NSDictionary *d = [app.playLists_ objectAtIndex:[indexPath row]];
#ifdef __IPHONE_3_0	
	cell.textLabel.text = [d objectForKey:@"playlistTitle"];
#else	
	 cell.text = [d objectForKey:@"playlistTitle"];
#endif
	 	
	 //NSString *imagePath = [[NSBundle mainBundle] pathForResource:[cell.text lowercaseString]  ofType:@"png"];
	 //UIImage *icon = [UIImage imageWithContentsOfFile:imagePath]; 
	 //cell.image = icon;
	 
	 return cell;
 }


@end
