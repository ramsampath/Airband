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

	UIButton *randomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	randomButton.frame = CGRectMake(88.0, 20.0, 67.0, 27.0);
	randomButton.adjustsImageWhenDisabled = YES;
	randomButton.adjustsImageWhenHighlighted = YES;
	randomButton.alpha = 0.400;
	randomButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	randomButton.clearsContextBeforeDrawing = NO;
	randomButton.clipsToBounds = NO;
	randomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	randomButton.contentMode = UIViewContentModeScaleToFill;
	randomButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	randomButton.enabled = YES;
	randomButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
	randomButton.hidden = NO;
	randomButton.highlighted = NO;
	randomButton.multipleTouchEnabled = NO;
	randomButton.opaque = NO;
	randomButton.reversesTitleShadowWhenHighlighted = NO;
	randomButton.selected = NO;
	randomButton.showsTouchWhenHighlighted = NO;
	randomButton.tag = 0;
	randomButton.userInteractionEnabled = YES;
	[randomButton setTitle:@"Random" forState:UIControlStateDisabled];
	[randomButton setTitle:@"Random" forState:UIControlStateHighlighted];
	[randomButton setTitle:@"Random" forState:UIControlStateNormal];
	[randomButton setTitle:@"Random" forState:UIControlStateSelected];
	[randomButton setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[randomButton setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[randomButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[randomButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[randomButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[randomButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[randomButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[randomButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[randomButton addTarget:self action:@selector(random) forControlEvents:UIControlEventTouchUpInside];
	
	
	/*
	UISegmentedControl *randomButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Random", @""), nil]];
	randomButton.frame = CGRectMake(88.0, 20.0, 67.0, 27.0);
	randomButton.momentary = YES;
	randomButton.segmentedControlStyle = UISegmentedControlStyleBar;
	randomButton.tintColor = viewbgcolor;
	self.navigationItem.titleView = randomButton;
	[randomButton addTarget:self action:@selector(random) forControlEvents:UIControlEventValueChanged];
    */
	
	
	UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
	mainview.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	mainview.alpha = 1.000;
	mainview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	mainview.backgroundColor = viewbgcolor;
	mainview.clearsContextBeforeDrawing = YES;
	mainview.clipsToBounds = NO;
	mainview.contentMode = UIViewContentModeScaleToFill;
	mainview.hidden = NO;
	mainview.multipleTouchEnabled = NO;
	mainview.opaque = YES;
	mainview.tag = 0;
	mainview.userInteractionEnabled = YES;
	
	UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	playButton.frame = CGRectMake(14.0, 20.0, 66.0, 27.0);
	playButton.adjustsImageWhenDisabled = YES;
	playButton.adjustsImageWhenHighlighted = YES;
	playButton.alpha = 0.400;
	playButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	playButton.backgroundColor = [UIColor colorWithRed:0.543 green:0.133 blue:0.114 alpha:0.000];
	playButton.clearsContextBeforeDrawing = NO;
	playButton.clipsToBounds = NO;
	playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	playButton.contentMode = UIViewContentModeScaleToFill;
	playButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	playButton.enabled = YES;
	playButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
	playButton.hidden = NO;
	playButton.highlighted = NO;
	playButton.multipleTouchEnabled = NO;
	playButton.opaque = NO;
	playButton.reversesTitleShadowWhenHighlighted = NO;
	playButton.selected = NO;
	playButton.showsTouchWhenHighlighted = NO;
	playButton.tag = 0;
	playButton.userInteractionEnabled = YES;
	[playButton setTitle:@"play" forState:UIControlStateDisabled];
	[playButton setTitle:@"play" forState:UIControlStateHighlighted];
	[playButton setTitle:@"play" forState:UIControlStateNormal];
	[playButton setTitle:@"play" forState:UIControlStateSelected];
	[playButton setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[playButton setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[playButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[playButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[playButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[playButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[playButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[playButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[playButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];

	UIButton *shuffleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	shuffleButton.frame = CGRectMake(226.0, 20.0, 74.0, 27.0);
	shuffleButton.adjustsImageWhenDisabled = YES;
	shuffleButton.adjustsImageWhenHighlighted = YES;
	shuffleButton.alpha = 0.400;
	shuffleButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	shuffleButton.clearsContextBeforeDrawing = NO;
	shuffleButton.clipsToBounds = NO;
	shuffleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	shuffleButton.contentMode = UIViewContentModeScaleToFill;
	shuffleButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	shuffleButton.enabled = YES;
	shuffleButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.000];
	shuffleButton.hidden = NO;
	shuffleButton.highlighted = NO;
	shuffleButton.multipleTouchEnabled = NO;
	shuffleButton.opaque = NO;
	shuffleButton.reversesTitleShadowWhenHighlighted = NO;
	shuffleButton.selected = NO;
	shuffleButton.showsTouchWhenHighlighted = NO;
	shuffleButton.tag = 0;
	shuffleButton.userInteractionEnabled = YES;
	[shuffleButton setTitle:@"shuffle" forState:UIControlStateDisabled];
	[shuffleButton setTitle:@"shuffle" forState:UIControlStateHighlighted];
	[shuffleButton setTitle:@"shuffle" forState:UIControlStateNormal];
	[shuffleButton setTitle:@"shuffle" forState:UIControlStateSelected];
	[shuffleButton setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
	[shuffleButton setTitleColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
	[shuffleButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[shuffleButton setTitleColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[shuffleButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateDisabled];
	[shuffleButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateHighlighted];
	[shuffleButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateNormal];
	[shuffleButton setTitleShadowColor:[UIColor colorWithWhite:0.000 alpha:1.000] forState:UIControlStateSelected];
	[shuffleButton addTarget:self action:@selector(shuffle:) forControlEvents:UIControlEventTouchUpInside];

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
	UIView * subView;
	NSArray * subViews = [searchfield_ subviews];
	for( subView in subViews )
	{	
		if( [subView isKindOfClass:[UITextField class]] )
		{
			UITextField *tf = (UITextField*)subView;
			tf.delegate = self;
		}
	}
	
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
	
	[mainview addSubview:artistTable_];
	[mainview addSubview:playButton];
	[mainview addSubview:randomButton];
	[mainview addSubview:shuffleButton];
	[mainview addSubview:searchfield_];
	
    self.view = mainview;
	
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
		printf("Here\n");
		UIView * subView;
		NSArray * subViews = [searchBar subviews];
		for(subView in subViews)
		{
			if( [subView isKindOfClass:[UITextField class]] )
			{
				printf("reassign first\n");
				[(UITextField*)subView resignFirstResponder];
			}
		}
		//[searchBar resignFirstResponder];
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


-(IBAction) textfieldchanged:(id)sender
{	
	printf ("here1\n");
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



- (BOOL)textFieldShouldReturn:(UITextField *)thetextField {
	[thetextField resignFirstResponder];
	return YES;
}

@end
