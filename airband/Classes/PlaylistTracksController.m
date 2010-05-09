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

#define kScreenWidth 320

@implementation PlaylistTracksController

@synthesize table_;
@synthesize playlist_;
@synthesize artist_;
@synthesize albumtracks_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		playlist_ = nil;
		artist_ = nil;
		albumtracks_ = nil;
	}

	return self;
}


- (id) init
{
    loadingView_  = nil;
    progressView_ = nil;
    playlist_     = nil;
    albumtracks_  = nil;
    artist_       = nil;
    clearTable_   = true;
    
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
    
    //
    // remove myself
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void) newlistReady:(id)object
{
    //
    // Remove the loadingView which should remove the progressView_ as well
    //
    [loadingView_ removeView];
    //
    // So we can comfortably set the progressView_ to nil
    //
    progressView_ = nil;
    //
    // set it to nil 
    //
    loadingView_ = nil;
    
    //
    // 
    //
    clearTable_ = false;
    
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
	
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(connectionFailed:) 
												 name:@"connectionFAIL"
											   object:nil];
    
	UINavigationBar *bar = [self navigationController].navigationBar;
	bar.barStyle = UIBarStyleBlackOpaque;;

	AppData *app = [AppData get];	
	
    //
    // Just in case the progressView has not been released by now, release it
    //
    if( progressView_ ) 
        [progressView_ removeFromSuperview];
    
    progressView_                 = [[[UILabel alloc] initWithFrame:CGRectMake( kScreenWidth/2 - 250/2, 
                                                                               100, 250, 100)] retain];
    progressView_.backgroundColor = [UIColor clearColor];
    progressView_.backgroundColor = [UIColor clearColor];
    progressView_.alpha           = 1.0;
    [self.view addSubview:progressView_];
    //
    // release the progressView as self.view should take care of it by now
    //
    [progressView_ release];
    
    // 
    // clear out all entries
    //
    [table_ reloadData];

	if( artist_ ) {
        // 
        // [NOTE] retain the loadingView, but this is not the usual recommended practice, but this case is 
        // special due to callbacks involved.
        // 
        loadingView_ = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Album List..."] retain]; 
        if( artist_  ) {
            NSString *req = [artist_ objectForKey:@"artistId"];
            [app getAlbumListAsync:req];
        }
        else {
            [app getAlbumList];
        }
	} 
    else if( albumtracks_ ) {
        loadingView_ = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Album Tracks..."] retain]; 
		NSString *req = [albumtracks_ objectForKey:@"albumId"];
		[app getTrackListAsync:req];		
	} 
    else if( playlist_ ) {
        loadingView_  = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Playlist Tracks..."] retain]; 
		NSString *req = [playlist_ objectForKey:@"playlistId"];
		NSString *enc = [req stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];  //NSUTF8StringEncoding	
		[app getPlayListTracksAsync:enc];		
	}
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
	[super dealloc];
}

- (void) nowPlaying:(id) sender
{
    NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];    
	nowplayingVC.hidesBottomBarWhenPushed = TRUE;

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
	return UITableViewCellAccessoryNone;
}
*/

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


        
        NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];			
		
        [nowplayingVC setupnavigationitems:self.navigationItem 
									navBar:[self navigationController].navigationBar
								  datadict:d];
        
           
        [self navigationController].navigationBarHidden = FALSE;
 		[[self navigationController] pushViewController:nowplayingVC animated:YES];	
        //
        // reset the application artwork
        [nowplayingVC setArtwork:nil];

        
        [nowplayingVC release];
		
		/*
		PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] initWithNibName:@"PlaylistTracks" bundle:nil];	
		traxcontroller.albumtracks_ = d;
		
		traxcontroller.navigationItem.title = [d objectForKey:@"albumTitle"];
		[traxcontroller.navigationItem 
		 setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
																style:UIBarButtonItemStylePlain 
															   target:nil 
															   action:nil]];
        
		[[self navigationController] pushViewController:traxcontroller animated:YES];
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStyleBordered
                                                                                target:self action:@selector(nowPlaying:)];
		 */
		
	}
	else if( albumtracks_ )
	{		
		NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];

        NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];


        [nowplayingVC setupnavigationitems:self.navigationItem 
                                 navBar:[self navigationController].navigationBar
                                 datadict:d];
        
        [self navigationController].navigationBarHidden = FALSE;

		//[app playTrack:d];

		[[self navigationController] pushViewController:nowplayingVC animated:YES];		
        [nowplayingVC setArtwork:nil];

        
        [app setCurrentTrackIndex_:[indexPath row]];
        [nowplayingVC release];
	}
	else if( playlist_ ) 
	{
		NSDictionary *d = [app.currentTracklist_ objectAtIndex:[indexPath row]];	
        
        NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];

        
        [nowplayingVC setupnavigationitems:self.navigationItem 
                                 navBar:[self navigationController].navigationBar
                                 datadict:d];

        [self navigationController].navigationBarHidden = FALSE;
        
        
		//[app playTrack:d];

		[[self navigationController] pushViewController:nowplayingVC animated:YES];		
        [nowplayingVC setArtwork:nil];

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
	if( !clearTable_ && playlist_ )
		return [app.currentTracklist_ count];
	else if( !clearTable_ && artist_ )
		return [app.albumList_ count];	
	else if( !clearTable_ && albumtracks_ )
		return [app.trackList_ count];
	
	return 0;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"myid2"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"myid2"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	cell.textLabel.textColor            = [UIColor whiteColor];

	AppData *app = [AppData get];
	
	if( playlist_ ) {
		NSDictionary *d = [app.currentTracklist_ objectAtIndex:[indexPath row]];
		cell.textLabel.text = [d objectForKey:@"trackTitle"];
	} else if( albumtracks_ ) {
		NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];
		cell.textLabel.text = [d objectForKey:@"trackTitle"];		
	} else if( artist_ ) {
		NSDictionary *d = [app.albumList_ objectAtIndex:[indexPath row]];
		cell.textLabel.text = [d objectForKey:@"albumTitle"];
	}
		
	return cell;
}
*/

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppData *app = [AppData get];
	
	NSString  *cellMain = nil;
	NSString  *cellExtra = nil;
	
	if( playlist_ ) {
		NSDictionary *d = [app.currentTracklist_ objectAtIndex:[indexPath row]];
		cellMain = [d objectForKey:@"trackTitle"];
	} else if( albumtracks_ ) {
		NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];
		cellMain = [d objectForKey:@"trackTitle"];				
		cellExtra = [d objectForKey:@"albumSize"];
	} else if( artist_ ) {
		NSDictionary *d = [app.albumList_ objectAtIndex:[indexPath row]];
		cellMain = [d objectForKey:@"albumTitle"];
		cellExtra = [NSString stringWithFormat:@"%@ tracks", [d objectForKey:@"trackCount"]];
	}
    
	
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;
	
	static NSString *CellIdentifier = @"Cell";
    const CGFloat LABEL_HEIGHT = 20;

	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
		[[[UITableViewCell alloc]
		  initWithFrame:CGRectZero
		  reuseIdentifier:CellIdentifier]
		 autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
		
		UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
		//cell.accessoryView =
		//[[[UIImageView alloc]
		//  initWithImage:indicatorImage]
		// autorelease];
		
		UIImage *image = [UIImage imageNamed:@"whiteButton.png"];
		
		//
		// Create the label for the top row of text
		//
		topLabel =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake(
					 image.size.width + 2.0 * cell.indentationWidth,
					 0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
					 aTableView.bounds.size.width -
					 image.size.width - 4.0 * cell.indentationWidth
					 - indicatorImage.size.width,
					 LABEL_HEIGHT)]
		 autorelease];		
		[cell.contentView addSubview:topLabel];
		
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		//topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
        topLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		topLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] ];
		
		//
		// Create the label for the top row of text
		//
		bottomLabel =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake(
					 image.size.width + 2.0 * cell.indentationWidth,
					 0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
					 aTableView.bounds.size.width -
					 image.size.width - 4.0 * cell.indentationWidth
					 - indicatorImage.size.width,
					 LABEL_HEIGHT)]
		 autorelease];
		[cell.contentView addSubview:bottomLabel];
		
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
		//bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
        bottomLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
		bottomLabel.highlightedTextColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
	}
	else
	{
		topLabel    = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
	
	topLabel.text = cellMain; //[NSString stringWithFormat:@"Cell at row %ld.", [indexPath row]];
	bottomLabel.text = cellExtra; //[NSString stringWithFormat:@"Some other information.", [indexPath row]];

	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
    //
    // uncomment the following lines after the design is in place
    //
	//cell.backgroundView =	
    //[[[UIImageView alloc] initWithImage:rowBackground] autorelease];
	//cell.selectedBackgroundView =
    //[[[UIImageView alloc] initWithImage:selectionBackground] autorelease];
	
	cell.backgroundView.alpha = 0.75;
    //
    // replace the following with the album artwork
    //
    //UIImage *image = [app.albumArtCache_ loadImage:@"empty_album_art.png"];
    //UIImageView *ciview = [[UIImageView alloc] initWithImage:image];

    //ciview.frame = CGRectMake( 0, 0, 34, 2*LABEL_HEIGHT + 4);
    //[cell addSubview:ciview];
    
    //
    // [NOTE] the following is just a temp image till a more comprehensive 
    // solution for the album art is worked out.
    //

    cell.imageView.image = nil;
    //cell.imageView.image = [app.albumArtCache_.cache_ objectForKey:cellMain];
    if( cell.imageView.image == nil ) {
#ifdef __IPHONE_3_0	
        cell.imageView.image = [app.albumArtCache_ loadImage:@"music_note_gray.png"];
#else
        cell.image = [app.albumArtCache_ loadImage:@"music_note_gray.png"];
#endif
    }
	return cell;
}

@end
