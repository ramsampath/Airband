#import "AudioToolbox/AudioToolbox.h"
#import "appdata.h"
#import "ArtistViewController.h"
#import "PlaylistTracksController.h"
#import "NowPlayingController.h"


#define kMaxRows 200
//#define kBgColor [UIColor colorWithRed:140.0/256 green:152.0/255 blue:88.0/255.0 alpha:1.000];
#define kBgColor   [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1.000];
//#define kBgColor   [UIColor whiteColor];
#define kScreenHeight 480
#define kScreenWidth  320


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
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	if (self)
	{
		// you can do this here specifically or at the table level for all cells
		self.accessoryType = UITableViewCellAccessoryNone;
		
		// Create label views to contain the various pieces of text that make up the cell.
		// Add these as subviews.
		nameLabel                      = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLabel.backgroundColor      = [UIColor clearColor];
		nameLabel.opaque               = NO;
		nameLabel.textColor            = [UIColor whiteColor];
		nameLabel.highlightedTextColor = [UIColor whiteColor];
		nameLabel.font                 = [UIFont boldSystemFontOfSize:18];
		[self.contentView addSubview:nameLabel];
        [nameLabel release];
		
		trackcountLabel                      = [[UILabel alloc] initWithFrame:CGRectZero];
		trackcountLabel.backgroundColor      = [UIColor clearColor];
		trackcountLabel.opaque               = NO;
		trackcountLabel.textColor            = [UIColor grayColor];
		trackcountLabel.highlightedTextColor = [UIColor whiteColor];
		trackcountLabel.font                 = [UIFont systemFontOfSize:14];
        
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];

		[self.contentView addSubview:trackcountLabel];
        [trackcountLabel release];
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
					   LEFT_COLUMN_WIDTH, CELL_HEIGHT+5);
	trackcountLabel.frame = frame;
	
	self.accessoryType = UITableViewCellAccessoryNone;	
}

- (void)dealloc
{
	[nameLabel       release];
	[trackcountLabel release];
	[dataDictionary  release];
    [super           dealloc];
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
		artistList_        = nil;
		activity_          = nil;
	}
	return self;
}


-(id) init
{
    nArtistActiveSessions_ = 0;
    artistList_            = nil;
    for( unsigned i = 0; i < 26; ++i )
        artistDisplayList_[i]     = nil; 
    activity_              = nil;
	searchActive_ = FALSE;

    shuffleview_ = FALSE;
    
    artistActiveSections_ = nil;
    artistSectionTitles_  = nil;
    
    return self;
}



- (void)dealloc
{
    [artistList_ release];
    [artistActiveSections_ release];
    [artistSectionTitles_ release];
    [savedArtistList_ release];

    for( int i = 0; i < 27; i++ ) {
        [artistDisplayList_[i] removeAllObjects];
        [artistDisplayList_[i] release];
    }

	[super dealloc];
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	UIColor *viewbgcolor                = kBgColor;
	
	UIView *mainview                    = [[UIView alloc] initWithFrame:CGRectMake( 0.0, 0.0, 320.0, 480.0 )];
	mainview.frame                      = CGRectMake(0.0, 0.0, 320.0, 480.0);
	mainview.alpha                      = 1.000;
	//mainview.autoresizingMask           = UIViewAutoresizingFlexibleTopMargin;
    //
    // the autoresizing is set to None to prevent the table to slide under the navigation bar
    //
    mainview.autoresizingMask           = UIViewAutoresizingNone;
    
	mainview.backgroundColor            = viewbgcolor;
	mainview.clearsContextBeforeDrawing = YES;
	mainview.clipsToBounds              = NO;
	mainview.contentMode                = UIViewContentModeScaleToFill;
	mainview.hidden                     = NO;
	mainview.multipleTouchEnabled       = NO;
	mainview.opaque                     = YES;
	mainview.tag                        = 0;
	mainview.userInteractionEnabled     = YES;
    mainview.backgroundColor            = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd.png"]];
    artistOrgControl_                   = [[UISegmentedControl alloc] initWithItems:
                                          [NSArray arrayWithObjects:@"A-Z", @"Shuffle", nil]];
	[artistOrgControl_ addTarget:self action:@selector(artistOrgControlAction:) 
                forControlEvents:UIControlEventValueChanged];
	artistOrgControl_.selectedSegmentIndex  = 0.0;	
	artistOrgControl_.segmentedControlStyle = UISegmentedControlStyleBar;
    artistOrgControl_.tintColor             = [UIColor darkGrayColor];
	artistOrgControl_.backgroundColor       = [UIColor clearColor];
    
    
    azsortbutton_ = [[UIBarButtonItem alloc] initWithCustomView:artistOrgControl_];	
	[azsortbutton_ release];
    
    
	UIColor *tablecolor                         = kBgColor;


	artistTable_                                 = [[UITableView alloc] init];
    artistTable_.delegate                        = self;
    artistTable_.dataSource                      = self;
	//artistTable_.frame                           = CGRectMake( 0.0, 40.5, 320.0, 450 );
    float h = self.navigationController.navigationBar.bounds.size.height;

    artistTable_.frame                           = CGRectMake( 0.0, 0.0, 320, 480 );
	artistTable_.allowsSelectionDuringEditing    = NO;
	artistTable_.alpha                           = 1.0;
	artistTable_.alwaysBounceHorizontal          = NO;
	artistTable_.alwaysBounceVertical            = NO;
	artistTable_.autoresizingMask                = UIViewAutoresizingFlexibleWidth | 
    UIViewAutoresizingFlexibleHeight ;
	artistTable_.backgroundColor                 = tablecolor;
	artistTable_.bounces                         = YES;
	artistTable_.bouncesZoom                     = YES;
	artistTable_.canCancelContentTouches         = YES;
	artistTable_.clearsContextBeforeDrawing      = NO;
	artistTable_.clipsToBounds                   = YES;
	//artistTable_.contentMode                     = UIViewContentModeScaleToFill;
	artistTable_.delaysContentTouches            = YES;
	artistTable_.directionalLockEnabled          = NO;
	artistTable_.hidden                          = NO;
	artistTable_.indicatorStyle                  = UIScrollViewIndicatorStyleDefault;
	artistTable_.maximumZoomScale                = 1.000;
	artistTable_.minimumZoomScale                = 1.000;
	artistTable_.multipleTouchEnabled            = NO;
	artistTable_.opaque                          = NO;
	artistTable_.pagingEnabled                   = NO;
	artistTable_.scrollEnabled                   = YES;
	artistTable_.separatorStyle                  = UITableViewCellSeparatorStyleNone;
	artistTable_.separatorColor                  = kBgColor;
	artistTable_.showsHorizontalScrollIndicator  = YES;
	artistTable_.showsVerticalScrollIndicator    = YES;
	artistTable_.tag                             = 0;
	artistTable_.userInteractionEnabled          = YES;
    artistTable_.backgroundColor                 = [UIColor clearColor];


    searchfield_ = [[UISearchBar alloc] init];
	//searchfield_.frame                  = CGRectMake( 0.0, 5.0, 320.0, 26.5 );
    searchfield_.frame                  = CGRectMake(0, h, 320, 30);
	searchfield_.alpha                  = 1.000;
	searchfield_.barStyle               = UIBarStyleBlackTranslucent;
	searchfield_.backgroundColor        = kBgColor;
	searchfield_.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchfield_.autocorrectionType     = UITextAutocorrectionTypeNo;
	searchfield_.autoresizingMask       = UIViewAutoresizingFlexibleRightMargin | 
    UIViewAutoresizingFlexibleBottomMargin;
	searchfield_.placeholder            = @"search";
	searchfield_.userInteractionEnabled = YES;
    
    //
	// don't get in the way of user typing
    //
    searchfield_.autocorrectionType     = UITextAutocorrectionTypeNo;
    searchfield_.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchfield_.tintColor              = kBgColor;
    searchfield_.showsCancelButton      = NO;
	searchfield_.delegate               = self;
	UIView  *subView;
	NSArray *subViews = [searchfield_ subviews];
	for( subView in subViews ) {
		if( [subView isKindOfClass:[UITextField class]] ) {
			UITextField *tf                  = (UITextField*)subView;
			tf.delegate                      = self;
			tf.enablesReturnKeyAutomatically = NO;
		}
        
	}
    //[artistTable_ addSubview:searchfield_];

	[mainview addSubview:artistTable_];
    [artistTable_ release];
    
	//[mainview addSubview:searchfield_];
	[mainview addSubview:artistOrgControl_];
    [artistOrgControl_ release];
    
    self.view = mainview;
}


- (void)viewDidLoad
{		
	AppData *app      = [AppData get];
	NSArray* fullList = app.fullArtistList_;
    /*
	if( fullList ) {
		[self reload];
	}
    */
    self.artistTable_.tableHeaderView = searchfield_;
    [searchfield_ release];

	UINavigationBar *bar          = [self navigationController].navigationBar;
	bar.barStyle                  = UIBarStyleBlackOpaque;
    self.navigationItem.titleView = artistOrgControl_;	
    sectionBGImage_               = [UIImage imageNamed:@"greenbar.png"];
	
    /*
	if( [artistList_ count] ) {
		return;
	}
	
	artistList_ = nil;	
	*/
    
    //
    // if artistlist is not yet avaliable request the artist list
    //
    if( !fullList ) {

        //
        // Just in case the progressView has not been released by now, release it
        //
        if( progressView_ )
            [progressView_ removeFromSuperview];
        
        progressView_                 = [[[UILabel alloc] initWithFrame:CGRectMake( kScreenWidth/2 - 250/2, 
                                                                                  100, 250, 100)] retain];
        progressView_.backgroundColor = [UIColor clearColor];
        progressView_.alpha           = 1.0;
        [self.view addSubview:progressView_];
        //
        // release the progressView_ because self.view should have taken care of it by now
        //
        [progressView_ release];


        // 
        // [NOTE] retain the loadingView, but this is not the usual recommended practice, but this case is 
        // special due to callbacks involved.
        // 
        loadingView_ = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Artists..."] retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(artistListReady:) 
                                                     name:@"artistListReady" 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(connectionFailed:) 
                                                     name:@"connectionFAIL"
                                                   object:nil];
    }
    [app getArtistList];

/*
	UIView *v = self.view;
	activity_ = [[UIActivityIndicatorView alloc] 
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activity_.center = v.center;
	activity_.hidesWhenStopped = TRUE;
	[v addSubview:activity_];
	[v bringSubviewToFront:activity_];
	[activity_ startAnimating];
	
	[UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:10.0];	
	activity_.transform = CGAffineTransformMakeScale( 1.25,1.25 );
	[UIView commitAnimations];	
	*/
	
}


- (void)viewDidDisappear:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = FALSE;
    [self navigationController].navigationBar.barStyle = UIBarStyleBlackOpaque;
    //[self reload];
    [artistTable_ reloadData];
    
    AppData *app = [AppData get];
    if( [app isrunning] )
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(nowPlaying:)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return YES;
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	if( ![app login] ) {
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
	[artistTable_ selectRowAtIndexPath:indexPath animated:YES 
                        scrollPosition:UITableViewScrollPositionMiddle];
	
	[self play:index];
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
    // remove myself since we dont need to know anymore till the next time.
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) artistListReady:(id) feh
{
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;	
	dbgtext_.text = [NSString stringWithFormat:@"%d Artists", [fullList count]];	
	
	//[self shuffle];
    [self reload];
    
    //
    // Remove the loadingView which should remove the progressView_ as well
    //
    [loadingView_ removeView];
    //
    // So we can comfortably set the progressView_ to nil
    //
    progressView_ = nil;
    //
    // loading view would have been released by now so comfortably set it to nil 
    //
    loadingView_ = nil;
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

- (void) artistOrgControlAction:(id)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self reload];
            break;
        case 1:
            [self shuffle];
            break;
        default:
            break;
    }
	//NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);
}


-(IBAction) shuffle
{
	//[artistList_ release];
	//artistList_ = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];
    shuffleview_ = TRUE;
    
    [artistList_ removeAllObjects];    // clear the filtered array first
    for( unsigned i = 0; i < 27; i++ ) {
        [artistDisplayList_[i] removeAllObjects];
    }
    [artistActiveSections_  removeAllObjects];
    
    artistDisplayList_[ 0 ] = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];

	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	int num = [fullList count];	

	if( num>kMaxRows )
		num = kMaxRows;
	
	srand48( [NSDate timeIntervalSinceReferenceDate] );
	
	NSMutableArray *indexPath      = [[[NSMutableArray alloc] init] retain];
	NSMutableArray *shuffleIndices = [[[NSMutableArray alloc] init] retain];
	
	for( unsigned i=0;  i < num; ++i ) { 
		int index  = (int) (drand48() * [fullList count]);
		if( [self findindex:shuffleIndices index:index] ) {
			while( [self findindex:shuffleIndices index:index] ) {
				index = (int) (drand48() * [fullList count]);
			}
		}
		[shuffleIndices	addObject:[NSString stringWithFormat:@"%d", index]];
		[artistDisplayList_[0] addObject:[fullList objectAtIndex:index]];	
		[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}        
    
	if( [self.artistTable_ numberOfRowsInSection:0] ) {
		[self.artistTable_ reloadData];
	}
	else {
		[self.artistTable_ beginUpdates];
		[self.artistTable_ insertRowsAtIndexPaths:indexPath 
			 withRowAnimation:UITableViewRowAnimationFade];
		[self.artistTable_ endUpdates];    			
	}

    [artistActiveSections_ addObject: artistDisplayList_[0]];
    [artistTable_ reloadData];
    
    [indexPath      release];
    [shuffleIndices release];
}


- (IBAction) reload 
{
    
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
    
    shuffleview_ = FALSE;
    
    if( fullList == nil ) return;
    
	int num = [fullList count];	
	//if( num > kMaxRows )
	//	num = kMaxRows;

    [artistList_ removeAllObjects];    // clear the filtered array first

    for( unsigned i = 0; i < 27; i++ ) {
        [artistDisplayList_[i] removeAllObjects];
    }

    for( unsigned i = 0; i < 27; ++i ) {
        artistDisplayList_[ i ] = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];
    }
    
    for( unsigned i=0;  i < num; ++i ) {
        NSString *artistname = [[fullList objectAtIndex:i] objectForKey:@"artistName"];
        //char index = ([artistname cStringUsingEncoding: NSASCIIStringEncoding]) [ 0 ];
        char index = [artistname UTF8String][0];
        if( index >= 'a' && index <= 'z' ) 
	  index = index - 'a' + 'A';
        
        if( index >= 'A' && index <= 'Z' ) {
            index -= 'A';
            [artistDisplayList_[( int ) index] addObject: [fullList objectAtIndex:i]];
        }
        else {
            [artistDisplayList_[ 26 ] addObject: [fullList objectAtIndex:i]];
        }
        [artistList_ addObject:[fullList objectAtIndex:i]];
    }
    //
    // Create the secions
    //  
    nArtistActiveSessions_ = 0; 
    if( artistActiveSections_ ) [artistActiveSections_ release];
    if( artistSectionTitles_ )  [artistSectionTitles_ release];
    
    artistActiveSections_  = [[NSMutableArray alloc] init];
    artistSectionTitles_   = [[NSMutableArray alloc] init];

    for( unsigned i = 0; i < 27; i++ ) {
        if( [artistDisplayList_[i] count] > 0 ) {
            nArtistActiveSessions_++;
            [artistActiveSections_ addObject: artistDisplayList_[i]];
            if( i < 26 ) {
                [artistSectionTitles_ addObject:[NSString stringWithFormat:@"%c", i + 65]];
            }
            else {
                [artistSectionTitles_ addObject:@"0-9"];
            }
        }
    }
    [self.artistTable_ reloadData];
}


- (void) nowPlaying:(id) sender
{
    //NowPlayingController *nowplayingVC = [[NowPlayingController alloc] 
    //                                      initWithNibName:@"NowPlayingArranged" bundle:nil];
    
    NowPlayingController *nowplayingVC = [NowPlayingController alloc];
    
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

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *) tableView 
{
    return [NSMutableArray arrayWithObjects: @"{search}",
                      @"A", @"B", @"C", @"D", @"E", @"F",
                      @"G", @"H", @"I", @"J", @"K", @"L",
                      @"M", @"N", @"O", @"P", @"Q", @"R",
                      @"S", @"T", @"U", @"V", @"W", @"X",
                      @"Y", @"Z", @"#", nil ];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index {
    //NSLog([NSString stringWithFormat:@"clicked index : %i",index]);
    if (index == 0) {
        [tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
        return -1;
    }
    return index  - 1;
}

/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[searchfield_ resignFirstResponder];
	//if( [artistList_ count] == 0 ) return;
    if( artistActiveSections_ == nil ) return;

	//NSDictionary *d = [artistList_ objectAtIndex:[indexPath row]];
    NSString *secTitle = [artistSectionTitles_ objectAtIndex:indexPath.section];

    unichar buffer[1];
    NSRange r;
    r.location = 0;
    r.length   = 1;
    [secTitle getCharacters:buffer range:r];
    NSInteger sectionIndex = buffer[0] - 65;
	
	if( sectionIndex<0 ) {
		sectionIndex = sizeof(artistDisplayList_)/sizeof(artistDisplayList_[0]) - 1;
	}
		
	if( sectionIndex<0 || sectionIndex >= 27 ) {
		//printf( "outta bounds: %d\n", sectionIndex );
		return;
	}
		
	NSDictionary *d = [artistDisplayList_[sectionIndex] objectAtIndex:indexPath.row];
	//PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] 
    //                                            initWithNibName:@"PlaylistTracks" bundle:nil];
    PlaylistTracksController *traxcontroller = [[PlaylistTracksController alloc] init];

	traxcontroller.artist_ = d;
	
	traxcontroller.navigationItem.title = [d objectForKey:@"artistName"];

	
	[self navigationController].navigationBarHidden = FALSE;

	[[self navigationController] pushViewController:traxcontroller animated:YES];
    [traxcontroller release];
         
}


#pragma mark UITableView datasource methods


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger) section
{
    if( [artistSectionTitles_ count] == 0 ) 
        return nil;
    else {
        NSString *rst = [ artistSectionTitles_ objectAtIndex:section];
        return rst;
    }
}
 

- (NSInteger)
numberOfSectionsInTableView:(UITableView *)tableView
{
    if( shuffleview_ ) return 1;
    
    if( [artistSectionTitles_ count] == 0 )
        return 1;
    else if( searchActive_ )
		return 1;
	else
        return nArtistActiveSessions_;
}

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( artistActiveSections_ && section<[artistActiveSections_ count]) {
        NSInteger ns = [[artistActiveSections_ objectAtIndex:section] count];
        return ns;
    }
    else return 0;
}


- (UIView *)tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger)section 
{	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24)] 
                          autorelease];

	UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, -1, tableView.bounds.size.width, 24)];
	sectionTitle.backgroundColor = [UIColor clearColor];
	sectionTitle.font            = [UIFont boldSystemFontOfSize:18];
	sectionTitle.textColor       = [UIColor whiteColor];
	sectionTitle.shadowColor     = [UIColor colorWithRed:.373 green:.141 blue:.024 alpha:1];
	sectionTitle.shadowOffset    = CGSizeMake(0, 1);
	if( searchActive_ ) {
		sectionTitle.text		= [NSString stringWithFormat:@"Search: %d items", [[artistActiveSections_ objectAtIndex:0] count]];
	} else {
        if( shuffleview_ ) 
            sectionTitle.text        = @"Random Artists";
        else {
            if( section < [artistSectionTitles_ count] ) 
                sectionTitle.text        = [artistSectionTitles_ objectAtIndex:section];
        }
	}
    
    UIImageView *sectionBG       = [[UIImageView alloc] initWithImage:sectionBGImage_];

    [headerView addSubview:sectionBG];
    [sectionBG release];

	[headerView addSubview:sectionTitle];
	[sectionTitle release];
    
	return headerView;
}


#define kCellIdentifier			@"MyId3"

- (UITableViewCell*)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger row = indexPath.row;
    //NSInteger sec = indexPath.section;
    //NSString *cellIdentifier = [NSString stringWithFormat:@"%d%d", row, sec ];
    NSString *cellIdentifier = kCellIdentifier;

    ArtistCell *cell = (ArtistCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
        cell = [[[ArtistCell alloc] initWithFrame:CGRectZero 
								  reuseIdentifier:cellIdentifier] autorelease];
	}
	// get the view controller's info dictionary based on the indexPath's row
	//cell.dataDictionary = [[artistList_ objectAtIndex:indexPath.row] retain];
    if( artistActiveSections_ ) {
        cell.dataDictionary = [[artistActiveSections_ 
                                objectAtIndex:indexPath.section] 
                               objectAtIndex:indexPath.row];
    }
    
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
    for( unsigned i = 0; i < 27; i++ ) {
        [artistDisplayList_[i] removeAllObjects];
    }
    
    //[artistSectionTitles_ removeAllObjects];
    
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;
	
	if( [searchText length] == 0 ) {
		searchActive_ = FALSE;
		UIView * subView;
		NSArray * subViews = [searchBar subviews];
		for(subView in subViews) {
			if( [subView isKindOfClass:[UITextField class]] ) {
				UITextField *tf  = (UITextField*)subView;
				[tf resignFirstResponder];
				tf.returnKeyType = UIReturnKeyDone;
			}
		}
		[searchBar resignFirstResponder];
        if( shuffleview_ )
            [self shuffle];
        else
            [self reload];
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
        unichar buffer[1];
        r.location = 0;
        r.length   = 1;
        [name getCharacters:buffer range:r];
        NSInteger sectionIndex = buffer[0] - 65;
        
		if (sectionIndex<0||sectionIndex>=27)
			continue;
		
        //[artistDisplayList_[sectionIndex] addObject:artist];
        [artistDisplayList_[0] addObject:artist];
	}
    
	searchActive_ = TRUE;
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
	[artistList_ removeAllObjects];

	NSString *search = searchfield_.text;
	if( [search length] == 0 ) {
		[self reload];
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
