#import "AudioToolbox/AudioToolbox.h"
#import "appdata.h"
#import "ArtistViewController.h"
#import "PlaylistTracksController.h"
#import "NowPlayingController.h"


#define kMaxRows 50


#pragma mark ------------------------------------------------
#pragma mark cell for our table
#pragma mark ------------------------------------------------

@interface ArtistCell : UITableViewCell
{
	NSDictionary	*dataDictionary;
	UILabel			*nameLabel;
	UILabel			*trackcountLabel;
}

@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *trackcountLabel;

@end


@implementation ArtistCell
@synthesize dataDictionary, nameLabel, trackcountLabel;

#define LEFT_COLUMN_OFFSET		10
#define LEFT_COLUMN_WIDTH		220		
#define UPPER_ROW_TOP			0
#define CELL_HEIGHT				50


- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:aRect reuseIdentifier:identifier];
	if (self)
	{
		// you can do this here specifically or at the table level for all cells
		self.accessoryType = UITableViewCellAccessoryNone;
		
		// Create label views to contain the various pieces of text that make up the cell.
		// Add these as subviews.
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];	// layoutSubViews will decide the final frame
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.opaque = NO;
		nameLabel.textColor = [UIColor whiteColor];
		nameLabel.highlightedTextColor = [UIColor whiteColor];
		nameLabel.font = [UIFont boldSystemFontOfSize:18];
		[self.contentView addSubview:nameLabel];
		
		trackcountLabel = [[UILabel alloc] initWithFrame:CGRectZero];	// layoutSubViews will decide the final frame
		trackcountLabel.backgroundColor = [UIColor clearColor];
		trackcountLabel.opaque = NO;
		trackcountLabel.textColor = [UIColor grayColor];
		trackcountLabel.highlightedTextColor = [UIColor whiteColor];
		trackcountLabel.font = [UIFont systemFontOfSize:14];
		[self.contentView addSubview:trackcountLabel];
	}
	
	return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
    CGRect contentRect = [self.contentView bounds];
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    CGRect frame = CGRectMake(contentRect.origin.x + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, 
							  LEFT_COLUMN_WIDTH, CELL_HEIGHT);
	nameLabel.frame = frame;
	
	frame = CGRectMake(contentRect.origin.x + contentRect.size.width - 50.0 + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, 
					   LEFT_COLUMN_WIDTH, CELL_HEIGHT);
	trackcountLabel.frame = frame;
	
	self.accessoryType = UITableViewCellAccessoryNone;	
}

- (void)dealloc
{
	[nameLabel release];
	[trackcountLabel release];
	[dataDictionary release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	// when the selected state changes, set the highlighted state of the labels accordingly
	nameLabel.highlighted = selected;
}

- (void)setDataDictionary:(NSDictionary *)newDictionary
{
	if (dataDictionary == newDictionary) {
		return;
	}	
	
	[dataDictionary release];
	dataDictionary = [newDictionary retain];
	
	// update value in subviews
	nameLabel.text 	     = [newDictionary objectForKey:@"artistName"];
	//printf(" Name : %s\n", [nameLabel.text UTF8String]);
	trackcountLabel.text = [newDictionary objectForKey:@"trackCount"];
}

@end




#pragma mark ------------------------------------------------
#pragma mark controller
#pragma mark ------------------------------------------------

@implementation ArtistViewController

@synthesize artistTable_, searchfield_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = NSLocalizedString(@"Artists", @"");
		artistList_ = nil;
		activity_ = nil;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	UIColor *viewbgcolor = [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1.000];

	UIButton *view18 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	view18.frame = CGRectMake(88.0, 20.0, 67.0, 27.0);
	view18.adjustsImageWhenDisabled = YES;
	view18.adjustsImageWhenHighlighted = YES;
	view18.alpha = 0.400;
	view18.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	view18.clearsContextBeforeDrawing = NO;
	view18.clipsToBounds = NO;
	view18.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	view18.contentMode = UIViewContentModeScaleToFill;
	view18.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	view18.enabled = YES;
	view18.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
	view18.hidden = NO;
	view18.highlighted = NO;
	view18.multipleTouchEnabled = NO;
	view18.opaque = NO;
	view18.reversesTitleShadowWhenHighlighted = NO;
	view18.selected = NO;
	view18.showsTouchWhenHighlighted = NO;
	view18.tag = 0;
	view18.userInteractionEnabled = YES;
	[view18 setTitle:@"Random" forState:UIControlStateDisabled];
	[view18 setTitle:@"Random" forState:UIControlStateHighlighted];
	[view18 setTitle:@"Random" forState:UIControlStateNormal];
	[view18 setTitle:@"Random" forState:UIControlStateSelected];
	[view18 setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[view18 setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[view18 setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[view18 setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[view18 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[view18 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[view18 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[view18 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[view18 addTarget:self action:@selector(random) forControlEvents:UIControlEventTouchUpInside];
	
	
	/*
	UISegmentedControl *view18 = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Random", @""), nil]];
	view18.frame = CGRectMake(88.0, 20.0, 67.0, 27.0);
	view18.momentary = YES;
	view18.segmentedControlStyle = UISegmentedControlStyleBar;
	view18.tintColor = viewbgcolor;
	self.navigationItem.titleView = view18;
	[view18 addTarget:self action:@selector(random) forControlEvents:UIControlEventValueChanged];
    */
	
	
	UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
	view1.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	view1.alpha = 1.000;
	view1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	view1.backgroundColor = viewbgcolor;
	view1.clearsContextBeforeDrawing = YES;
	view1.clipsToBounds = NO;
	view1.contentMode = UIViewContentModeScaleToFill;
	view1.hidden = NO;
	view1.multipleTouchEnabled = NO;
	view1.opaque = YES;
	view1.tag = 0;
	view1.userInteractionEnabled = YES;
	
	UIButton *view20 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	view20.frame = CGRectMake(14.0, 20.0, 66.0, 27.0);
	view20.adjustsImageWhenDisabled = YES;
	view20.adjustsImageWhenHighlighted = YES;
	view20.alpha = 0.400;
	view20.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	view20.backgroundColor = [UIColor colorWithRed:0.543 green:0.133 blue:0.114 alpha:0.000];
	view20.clearsContextBeforeDrawing = NO;
	view20.clipsToBounds = NO;
	view20.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	view20.contentMode = UIViewContentModeScaleToFill;
	view20.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	view20.enabled = YES;
	view20.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
	view20.hidden = NO;
	view20.highlighted = NO;
	view20.multipleTouchEnabled = NO;
	view20.opaque = NO;
	view20.reversesTitleShadowWhenHighlighted = NO;
	view20.selected = NO;
	view20.showsTouchWhenHighlighted = NO;
	view20.tag = 0;
	view20.userInteractionEnabled = YES;
	[view20 setTitle:@"play" forState:UIControlStateDisabled];
	[view20 setTitle:@"play" forState:UIControlStateHighlighted];
	[view20 setTitle:@"play" forState:UIControlStateNormal];
	[view20 setTitle:@"play" forState:UIControlStateSelected];
	[view20 setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[view20 setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[view20 setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[view20 setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[view20 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[view20 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[view20 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[view20 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[view20 addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];

	UIButton *view25 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	view25.frame = CGRectMake(226.0, 20.0, 74.0, 27.0);
	view25.adjustsImageWhenDisabled = YES;
	view25.adjustsImageWhenHighlighted = YES;
	view25.alpha = 0.400;
	view25.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	view25.clearsContextBeforeDrawing = NO;
	view25.clipsToBounds = NO;
	view25.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	view25.contentMode = UIViewContentModeScaleToFill;
	view25.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	view25.enabled = YES;
	view25.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
	view25.hidden = NO;
	view25.highlighted = NO;
	view25.multipleTouchEnabled = NO;
	view25.opaque = NO;
	view25.reversesTitleShadowWhenHighlighted = NO;
	view25.selected = NO;
	view25.showsTouchWhenHighlighted = NO;
	view25.tag = 0;
	view25.userInteractionEnabled = YES;
	[view25 setTitle:@"shuffle" forState:UIControlStateDisabled];
	[view25 setTitle:@"shuffle" forState:UIControlStateHighlighted];
	[view25 setTitle:@"shuffle" forState:UIControlStateNormal];
	[view25 setTitle:@"shuffle" forState:UIControlStateSelected];
	[view25 setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[view25 setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[view25 setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[view25 setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[view25 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[view25 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[view25 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[view25 setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[view25 addTarget:self action:@selector(shuffle) forControlEvents:UIControlEventTouchUpInside];

	UIColor *tablecolor = [UIColor colorWithRed:0.304 green:0.304 blue:0.304 alpha:1.000];
	
	searchfield_ = [[UISearchBar alloc] initWithFrame:CGRectMake(163.0, 55.0, 137.0, 26.5)];
	//searchfield_.frame = CGRectMake(163.0, 55.0, 137.0, 26.5);
	searchfield_.frame = CGRectMake(0, 55.0, 320.0, 26.5);
	searchfield_.alpha = 1.000;
	searchfield_.barStyle = UIBarStyleBlackTranslucent;
	searchfield_.backgroundColor = nil;
	searchfield_.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchfield_.autocorrectionType = UITextAutocorrectionTypeNo;
	searchfield_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	//searchfield_.backgroundColor = [UIColor colorWithRed:0.712 green:0.471 blue:0.280 alpha:0.000];
	searchfield_.placeholder = @"search";
	searchfield_.userInteractionEnabled = YES;
	// don't get in the way of user typing
    searchfield_.autocorrectionType = UITextAutocorrectionTypeNo;
    searchfield_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchfield_.showsCancelButton = NO;
	searchfield_.delegate = self;

	artistTable_ = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 89.5, 320.0, 390.5) style:UITableViewStylePlain];
	
    artistTable_.delegate = self;
    artistTable_.dataSource = self;
	
	artistTable_.frame = CGRectMake(0.0, 89.5, 320.0, 390.5);
	artistTable_.allowsSelectionDuringEditing = NO;
	artistTable_.alpha = 0.908;
	artistTable_.alwaysBounceHorizontal = NO;
	artistTable_.alwaysBounceVertical = NO;
	artistTable_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	artistTable_.backgroundColor = tablecolor;
	artistTable_.bounces = YES;
	artistTable_.bouncesZoom = YES;
	artistTable_.canCancelContentTouches = YES;
	artistTable_.clearsContextBeforeDrawing = NO;
	artistTable_.clipsToBounds = YES;
	artistTable_.contentMode = UIViewContentModeScaleToFill;
	artistTable_.delaysContentTouches = YES;
	artistTable_.directionalLockEnabled = NO;
	artistTable_.hidden = NO;
	artistTable_.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	artistTable_.maximumZoomScale = 1.000;
	artistTable_.minimumZoomScale = 1.000;
	artistTable_.multipleTouchEnabled = NO;
	artistTable_.opaque = NO;
	artistTable_.pagingEnabled = NO;
	artistTable_.scrollEnabled = YES;
	artistTable_.sectionIndexMinimumDisplayRowCount = 0;
	artistTable_.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	artistTable_.showsHorizontalScrollIndicator = YES;
	artistTable_.showsVerticalScrollIndicator = YES;
	artistTable_.tag = 0;
	artistTable_.userInteractionEnabled = YES;
	
	[view1 addSubview:artistTable_];
	[view1 addSubview:view20];
	[view1 addSubview:view18];
	[view1 addSubview:view25];
	[view1 addSubview:searchfield_];
	
    self.view = view1;
	
}


- (void)viewDidLoad
{	
	if( [artistList_ count] ) {
		return;
	}
	
	artistList_ = nil;				
	//dbgtext_.text = @"greetings";	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(artistListReady:) 
												 name:@"artistListReady" 
											   object:nil];	
	
	
	UIView *v = self.view;
	activity_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activity_.center = v.center;
	activity_.hidesWhenStopped = TRUE;
	[v addSubview:activity_];
	[v bringSubviewToFront:activity_];
	[activity_ startAnimating];
	
	[UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:5.0];	
	activity_.transform = CGAffineTransformMakeScale(1.5,1.5);
	
	UINavigationBar *bar = [self navigationController].navigationBar;
	bar.barStyle = UIBarStyleBlackOpaque;;
	[UIView commitAnimations];	
}


- (void)viewDidDisappear:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = FALSE;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(IBAction) pause
{
	//[g_audio pause];
}

-(IBAction) search
{
}

- (void) play:(int)index
{
	AppData *app = [AppData get];
	if( [artistList_ count] == 0 ) return;
	[app play:[artistList_ objectAtIndex:index]];
}


- (void) retry
{
	AppData *app = [AppData get];
	if( ![app login] )
	{
		// go to settings screen.
		UITabBarController *tabc = (UITabBarController *) self.navigationController;
		tabc.selectedIndex = 3;
	}	
}

-(IBAction) random
{
	int num = [artistTable_ numberOfRowsInSection:0];
	if( !num )  {
		[self retry];
		return;
	}
	
	int index = num * drand48();
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[artistTable_ selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	
	[self play:index];
}


-(void) artistListReady:(id) feh
{
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;	
	dbgtext_.text = [NSString stringWithFormat:@"%d artists", [fullList count]];	
	
	[self shuffle];			
	[activity_ stopAnimating];	
}

-(id) findindex:(NSArray *)shuffleIndices index:(int) index
{
	NSEnumerator *enume = [shuffleIndices objectEnumerator];
	
	id anObject;
	while( anObject = [enume nextObject]) {
		if ([anObject intValue] == index) return anObject;
	}
	return nil;
}

-(IBAction) shuffle
{
	[artistList_ release];
	artistList_ = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];

	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	int num = [fullList count];	
	if(num>kMaxRows)
		num = kMaxRows;
	
	srand48( [NSDate timeIntervalSinceReferenceDate] );
	
	NSMutableArray *indexPath = [[[NSMutableArray alloc] init] retain];  // autorelease?
	int i;
	NSMutableArray *shuffleIndices = [[[NSMutableArray alloc] init] retain];
	
	for( i=0;  i<num; ++i ) { 
		int index  = (int) (drand48() * [fullList count]);
		if( [self findindex:shuffleIndices index:index] ) {
			while ([self findindex:shuffleIndices index:index]) {
				index = (int) (drand48() * [fullList count]);
			}
		}
		[shuffleIndices	addObject:[NSString stringWithFormat:@"%d", index]];
		[artistList_ addObject:[fullList objectAtIndex:index]];	
		//printf("Adding artist %s index: %d\n", [[[app.fullArtistList_ objectAtIndex:index] objectForKey:@"artistName"] UTF8String], i);
		[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}        
	
	if( [self.artistTable_ numberOfRowsInSection:0] )
	{
		[self.artistTable_ reloadData];
	}
	else
	{
		[self.artistTable_ beginUpdates];
		[self.artistTable_ insertRowsAtIndexPaths:indexPath 
			 withRowAnimation:UITableViewRowAnimationFade];
		[self.artistTable_ endUpdates];    			
	}
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
	[searchfield_ resignFirstResponder];
	if( [artistList_ count] == 0 ) return;
	
	NSDictionary *d = [artistList_ objectAtIndex:[indexPath row]];
	
	PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] initWithNibName:@"PlaylistTracks" bundle:nil];	
	traxcontroller.artist_ = d;
	
	traxcontroller.navigationItem.title = [d objectForKey:@"artistName"];
	[traxcontroller.navigationItem 
	setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playlist.png"] 
														style:UIBarButtonItemStylePlain 
														target:nil 
														action:nil]];
	
	[self navigationController].navigationBarHidden = FALSE;

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


#pragma mark UITableView datasource methods

- (NSInteger)
numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int c = [artistList_ count];
	return (c>kMaxRows) ? kMaxRows : c;
}


#define kCellIdentifier			@"MyId3"

- (UITableViewCell*)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ArtistCell *cell = (ArtistCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[ArtistCell alloc] initWithFrame:CGRectZero 
								  reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	cell.dataDictionary = [[artistList_ objectAtIndex:indexPath.row] retain];
	
	return cell;
}


#pragma mark ------------------------------------------------
#pragma mark textfield callback, delegate routines
#pragma mark ------------------------------------------------

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
	
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	
    // flush and save the current list content in case the user cancels the search later
    [savedArtistList_ removeAllObjects];

	NSDictionary *artist;
	for (artist in fullList) {
		NSString *name = [artist objectForKey:@"artistName"];
		[savedArtistList_ addObject:name];
	}
    //[savedArtistList_ addObjectsFromArray: fullList];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchfield_.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [artistList_ removeAllObjects];    // clear the filtered array first
    
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	
	if( [searchText length] == 0 )
	{
		[searchBar resignFirstResponder];
		[self shuffle];
		return;
	}
	
    // search the table content for cell titles that match "searchText"
    // if found add to the mutable array and force the table to reload
    //

	NSDictionary *artist;
	for (artist in fullList) {
		NSString *name = [artist objectForKey:@"artistName"];
		NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if( r.location == NSNotFound || r.length == 0 )
			continue;
		[artistList_ addObject:artist];
	}
    
	[artistTable_ reloadData];
}


// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the saved list content
    if (searchBar.text.length > 0) {
        [artistList_ removeAllObjects];
        [artistList_ addObjectsFromArray: savedArtistList_];
    }
    
    [artistTable_ reloadData];
    
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}


// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


//- (IBAction)searchfield_:(UISearchBar *)searchBar textDidChange(NSString *)searchText
//-(IBAction) textfieldchanged:(id)sender
/*
{	
	printf ("here\n");
	[artistList_ removeAllObjects];

	NSString *search = searchfield_.text;
	if( [search length] == 0 )
	{
		[self shuffle];
		return;
	}
	
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	
	NSDictionary *artist;
	for (artist in fullList) {
		NSString *name = [artist objectForKey:@"artistName"];
		NSRange r = [name rangeOfString:search options:NSCaseInsensitiveSearch];
		if( r.location == NSNotFound || r.length == 0 )
			continue;
		[artistList_ addObject:artist];
	}
	
	[artistTable_ reloadData];
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)thetextField {
	[thetextField resignFirstResponder];
	return YES;
}

@end
