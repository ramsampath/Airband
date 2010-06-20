//
//  AlbumlistController.m
//  airband
//
//  Created by Ram Sampath on 5/22/09.
//  Copyright 2009 Centroid PIC. All rights reserved.
//



#import "appdata.h"
#import "AlbumlistController.h"
#import "PlaylistTracksController.h"
#import "NowPlayingController.h"


#define kMaxRows 100
//#define kBgColor [UIColor colorWithRed:140.0/256 green:152.0/255 blue:88.0/255.0 alpha:1.000];
#define kBgColor   [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1.000];
//#define kBgColor   [UIColor whiteColor];
#define kScreenWidth 320

#pragma mark ------------------------------------------------
#pragma mark cell for our table
#pragma mark ------------------------------------------------

@interface AlbumCell: UITableViewCell
{
	NSDictionary	*dataDictionary;
	UILabel			*nameLabel;
	UILabel			*trackcountLabel;
    UIImageView     *albumartView;
    
    NSMutableDictionary *albumartViewmap_;
}

@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (nonatomic, retain) UILabel      *nameLabel;
@property (nonatomic, retain) UILabel      *trackcountLabel;

@end


@implementation AlbumCell
@synthesize dataDictionary, nameLabel, trackcountLabel;

#define LEFT_COLUMN_OFFSET		10
#define LEFT_COLUMN_WIDTH		220
#define UPPER_ROW_TOP			0
#define CELL_HEIGHT				50


- (id)initWithFrame:(CGRect)aRect 
    reuseIdentifier:(NSString *)identifier tableView:(UITableView *)aTableView image:(UIImage *) albumart
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    if( self ) {
        const NSInteger TOP_LABEL_TAG    = 1001;
        const NSInteger BOTTOM_LABEL_TAG = 1002;
	
        const CGFloat LABEL_HEIGHT       = 22;

        //
        // album artwork
        //

        albumartView = [[UIImageView alloc] initWithImage:albumart];
        albumartView.frame = CGRectMake( 0, 0, 34, 2*LABEL_HEIGHT  );
        [self.contentView addSubview:albumartView];
        [albumartView release];

        //
        // Create the label for the top row of text
        //
        UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
        
        //nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 32, 0, 100, LABEL_HEIGHT)] retain];
        
        nameLabel = [[UILabel alloc]
                     initWithFrame:
                     CGRectMake(
                                albumartView.frame.size.width + 2.0 * self.indentationWidth,
                                0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                                aTableView.bounds.size.width -
                                albumartView.frame.size.width - 4.0 * self.indentationWidth
                                - indicatorImage.size.width,
                                LABEL_HEIGHT)];
        
        [self.contentView addSubview:nameLabel];
        [nameLabel release];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        
        nameLabel.tag                  = TOP_LABEL_TAG;
        nameLabel.backgroundColor      = [UIColor clearColor];
        nameLabel.textColor            = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        nameLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        nameLabel.font                 = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] ];
        
        //
        // Create the label for the top row of text
        //
        trackcountLabel = [[[UILabel alloc] initWithFrame:
                            CGRectMake(
                                       albumartView.frame.size.width + 2.0 * self.indentationWidth,
                                       0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                                       aTableView.bounds.size.width -
                                       albumartView.frame.size.width - 4.0 * self.indentationWidth
                                       - indicatorImage.size.width,
                                       LABEL_HEIGHT)] retain];
        
        [self.contentView addSubview:trackcountLabel];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        
        trackcountLabel.tag                  = BOTTOM_LABEL_TAG;
        trackcountLabel.backgroundColor      = [UIColor clearColor];
        trackcountLabel.textColor            = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        trackcountLabel.highlightedTextColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        trackcountLabel.font                 = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        
        self.backgroundView.alpha = 1.0;
    }
    
	return self;
}

-(void) setCellImage:(UIImage *)albumart
{
    albumartView.image = albumart;
}




- (void)layoutSubviews
{
	[super layoutSubviews];
    CGRect contentRect = [self.contentView bounds];
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    CGRect frame = CGRectMake(contentRect.origin.x + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, 
							  LEFT_COLUMN_WIDTH, CELL_HEIGHT);
	//nameLabel.frame = frame;
	
	frame = CGRectMake(contentRect.origin.x + contentRect.size.width - 50.0 + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, 
					   LEFT_COLUMN_WIDTH, CELL_HEIGHT+5);
	//trackcountLabel.frame = frame;
	
	self.accessoryType = UITableViewCellAccessoryNone;	
}

- (void)dealloc
{
    [albumartView release];

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
	
    NSString  *cellMain  = nil;
	NSString  *cellExtra = nil;
    
    cellMain        = [newDictionary objectForKey:@"albumTitle"];
    cellExtra       = [NSString stringWithFormat:@"%@ tracks", [newDictionary objectForKey:@"trackCount"]];
    
	nameLabel.text       = cellMain; 
	trackcountLabel.text = cellExtra; 

}


@end


#pragma mark ------------------------------------------------
#pragma mark controller
#pragma mark ------------------------------------------------

@implementation AlbumlistController

@synthesize table_, searchfield_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = NSLocalizedString(@"Albums", @"");
		albumList_ = nil;
		activity_  = nil;
	}
	return self;
}


-(id) init
{
    nAlbumActiveSessions_ = 0;
    albumList_            = nil;
    for( unsigned i = 0; i < 26; ++i )
        albumDisplayList_[i]     = nil; 
    activity_              = nil;
	searchActive_          = FALSE;
    
    shuffleview_           = FALSE;

    albumActiveSections_ = nil;
    albumSectionTitles_ = nil;
    return self;
}



- (void)dealloc
{
    [albumList_ dealloc];
    
    for( int i = 0; i < 26; i++ )
        [albumDisplayList_[i] release];

    [albumActiveSections_ release];
    [albumSectionTitles_ release];
    [savedAlbumList_ release];
    
    [sectionBGImage_ release];
	[searchfield_ release];
    
    [azsortbutton_ release];
    [shufflebutton_ release];
    [albumOrgControl_ release];
    
    [activity_ release];
    [fullAlbumList_ release];
    
    if( [loadingView_ retainCount] ) 
        [loadingView_ release];
    
    if( [progressView_ retainCount] )
        [progressView_ release];
    
	[super dealloc];
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIColor *viewbgcolor = kBgColor;
	
    UIView *mainview                    = [[UIView alloc] initWithFrame:CGRectMake( 0.0, 0.0, 320.0, 480.0 )];
	mainview.frame                      = CGRectMake(0.0, 0.0, 320.0, 480.0);
	mainview.alpha                      = 1.000;
    //mainview.autoresizingMask           = UIViewAutoresizingFlexibleTopMargin;
    //
    // the following autoresizing is set to None because the search bar seems to slide under
    // the navigation if autoresizing is used.
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
    mainview.backgroundColor            = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd@2x.png"]];
    albumOrgControl_                   = [[UISegmentedControl alloc] initWithItems:
                                           [NSArray arrayWithObjects:@"A-Z", @"Shuffle", nil]];
	[albumOrgControl_ addTarget:self action:@selector(albumOrgControlAction:) 
               forControlEvents:UIControlEventValueChanged];
	albumOrgControl_.selectedSegmentIndex  = 0.0;	
	albumOrgControl_.segmentedControlStyle = UISegmentedControlStyleBar;
    albumOrgControl_.tintColor             = [UIColor darkGrayColor];
	albumOrgControl_.backgroundColor       = [UIColor clearColor];
    
    azsortbutton_ = [[UIBarButtonItem alloc] initWithCustomView:albumOrgControl_];	
	[azsortbutton_ release];
    
	UIColor *tablecolor = kBgColor;
    
    float h = self.navigationController.navigationBar.bounds.size.height;

	searchfield_ = [[UISearchBar alloc] init];
	//searchfield_.frame                  = CGRectMake( 0.0, 5.0, 320.0, 26.5 );
    searchfield_.frame                  = CGRectMake(0, h, 320, 30.0);
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
    
	table_                                 = [[UITableView alloc] init];
    table_.delegate                        = self;
    table_.dataSource                      = self;
	//table_.frame                           = CGRectMake( 0.0, 40.5, 320.0, 450 );
    table_.frame                           = CGRectMake(0, 0, 320, 480);
	table_.allowsSelectionDuringEditing    = NO;
	table_.alpha                           = 1.0;
	table_.alwaysBounceHorizontal          = NO;
	table_.alwaysBounceVertical            = NO;
	table_.autoresizingMask                = UIViewAutoresizingFlexibleWidth | 
    UIViewAutoresizingFlexibleHeight ;
	table_.backgroundColor                 = tablecolor;
	table_.bounces                         = YES;
	table_.bouncesZoom                     = YES;
	table_.canCancelContentTouches         = YES;
	table_.clearsContextBeforeDrawing      = NO;
	table_.clipsToBounds                   = YES;
	//table_.contentMode                     = UIViewContentModeScaleToFill;
	table_.delaysContentTouches            = YES;
	table_.directionalLockEnabled          = NO;
	table_.hidden                          = NO;
	table_.indicatorStyle                  = UIScrollViewIndicatorStyleDefault;
	table_.maximumZoomScale                = 1.000;
	table_.minimumZoomScale                = 1.000;
	table_.multipleTouchEnabled            = NO;
	table_.opaque                          = NO;
	table_.pagingEnabled                   = NO;
	table_.scrollEnabled                   = YES;
	table_.separatorStyle                  = UITableViewCellSeparatorStyleNone;
	table_.separatorColor                  = kBgColor;
	table_.showsHorizontalScrollIndicator  = YES;
	table_.showsVerticalScrollIndicator    = YES;
	table_.tag                             = 0;
	table_.userInteractionEnabled          = YES;
    table_.backgroundColor                 = [UIColor clearColor];
    
    [mainview addSubview:table_];
	[mainview addSubview:albumOrgControl_];

    
    self.view = mainview;
}


- (void)viewDidLoad
{	
    self.table_.tableHeaderView = searchfield_;

	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(albumListReady:) 
                                                 name:@"albumListReady" 
											   object:nil];	
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(connectionFailed:) 
												 name:@"connectionFAIL"
											   object:nil];
	
	UINavigationBar *bar = [self navigationController].navigationBar; 
	bar.barStyle = UIBarStyleBlackOpaque;;

	AppData *app = [AppData get];	

    [app getAlbumList];
    
	if( [albumList_ count] ) {
		return;
	}
	albumList_ = nil;		
        
    //
    // just to make sure that the progress view is released if its not released by now
    //
    if( progressView_ ) 
        [progressView_ removeFromSuperview];
    
    progressView_                 = [[UILabel alloc] initWithFrame:CGRectMake( kScreenWidth/2 - 250/2, 
                                                                              100, 250, 100)];
    progressView_.backgroundColor = [UIColor clearColor];
    progressView_.alpha           = 1.0;
    
    [self.view addSubview:progressView_];
    //
    // release the progressView as self.view should take care of it by now
    //
    [progressView_ release];
    

    // 
    // [NOTE] retain the loadingView, but this is not the usual recommended practice, but this case is 
    // special due to callbacks involved.
    // 
    loadingView_ = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Albums..."] retain];
	
    self.navigationItem.titleView = albumOrgControl_;
    
    sectionBGImage_      = [UIImage imageNamed:@"greenbar.png"];
}


- (void)viewDidDisappear:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = FALSE;
    
    UINavigationBar *bar          = [self navigationController].navigationBar;
	bar.barStyle                  = UIBarStyleBlackOpaque;

    //[self reload];

    AppData *app = [AppData get];
    if( [app isrunning] )
        [self navigationController].navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                                                                initWithTitle:@"Now Playing"
                                                                                style:UIBarButtonItemStylePlain
                                                                                target:self action:@selector(nowPlaying:)];
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
	if( [albumList_ count] == 0 ) return;
	[app play:[albumList_ objectAtIndex:index]];
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
	int num = [table_ numberOfRowsInSection:0];
	if( !num )  {
		[self retry];
		return;
	}
	
	int index = num * drand48();
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	[table_ selectRowAtIndexPath:indexPath animated:YES 
                        scrollPosition:UITableViewScrollPositionMiddle];
	
	[self play:index];
}


-(void) albumListReady:(id) feh
{
	AppData *app   = [AppData get];
	fullAlbumList_ = [app.albumList_ copy];
	
    [self reload];
    
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
    // Remove ourselves to be notified when a new album list is ready because 
    // once we know that all the albums have been loaded here we dont need to know
    // about it anymore
    //
        
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void) albumOrgControlAction:(id)sender
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
	//[albumList_ release];
	//albumList_ = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];
    shuffleview_ = TRUE;

    [albumList_ removeAllObjects];    // clear the filtered array first
    for( unsigned i = 0; i < 27; i++ ) {
        [albumDisplayList_[i] removeAllObjects];
    }
    [albumActiveSections_ removeAllObjects];
    
    albumDisplayList_[ 0 ] = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];
    
	NSArray* fullList = fullAlbumList_;
	int num = [fullList count];	
	if( num > kMaxRows )
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
		[albumDisplayList_[0] addObject:[fullList objectAtIndex:index]];	
		[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}        
    
	if( [self.table_ numberOfRowsInSection:0] ) {
		[self.table_ reloadData];
	}
	else {
		[self.table_ beginUpdates];
		[self.table_ insertRowsAtIndexPaths:indexPath 
         withRowAnimation:UITableViewRowAnimationFade];
		[self.table_ endUpdates];    			
	}
    
    [albumActiveSections_ addObject:albumDisplayList_[0]];
    
    [indexPath      release];
    [shuffleIndices release];
    
    [self.table_ reloadData];
}


- (IBAction) reload 
{
    shuffleview_ = FALSE;

	NSArray* fullList = fullAlbumList_;
    if( fullList == nil ) return;
    
	int num = [fullList count];	
	//if( num > kMaxRows )
	//	num = kMaxRows;
    
    [albumList_ removeAllObjects];    // clear the filtered array first
    
    for( unsigned i = 0; i < 27; i++ ) {
        [albumDisplayList_[i] removeAllObjects];
    }
    
    for( unsigned i = 0; i < 27; ++i ) {
        albumDisplayList_[ i ] = [[NSMutableArray arrayWithCapacity:kMaxRows] retain];
    }
    
    for( unsigned i=0;  i < num; ++i ) {
        NSString *albumname = [[fullList objectAtIndex:i] objectForKey:@"albumTitle"];
        //char index = ([artistname cStringUsingEncoding: NSASCIIStringEncoding]) [ 0 ];
        char index = [albumname UTF8String][0];
        if( index >= 'a' && index <= 'z' ) 
            index = index - 'a' + 'A';
        
        if( index >= 'A' && index <= 'Z' ) {
            index -= 'A';
            [albumDisplayList_[( int ) index] addObject: [fullList objectAtIndex:i]];
        }
        else {
            [albumDisplayList_[ 26 ] addObject: [fullList objectAtIndex:i]];
        }
        [albumList_ addObject:[fullList objectAtIndex:i]];
    }
    //
    // Create the secions
    //  
    nAlbumActiveSessions_ = 0; 
    if( albumActiveSections_ ) [albumActiveSections_ release];
    if( albumSectionTitles_ ) [albumSectionTitles_ release];
    
    albumActiveSections_  = [[NSMutableArray alloc] init];
    albumSectionTitles_   = [[NSMutableArray alloc] init];
    
    for( unsigned i = 0; i < 27; i++ ) {
        if( [albumDisplayList_[i] count] > 0 ) {
            nAlbumActiveSessions_++;
            [albumActiveSections_ addObject: albumDisplayList_[i]];
            if( i < 26 ) {
                [albumSectionTitles_ addObject:[NSString stringWithFormat:@"%c", i + 65]];
            }
            else {
                [albumSectionTitles_ addObject:@"0-9"];
            }
        }
    }
    [table_ reloadData];
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
    
    self.navigationItem.hidesBackButton = TRUE;

    [[self navigationController] pushViewController:nowplayingVC animated:YES];		
    
    [nowplayingVC release];
    return;
}


- (void) trackListReady:(id)object
{
    //AppData *app = [AppData get];
    

    //NSDictionary *d = [app.trackList_ objectAtIndex:0];

    //[app playTrack:d];

    return;
}



#pragma mark -
#pragma mark UITableView delegates
#pragma mark -

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *) tableView 
{
    return [NSMutableArray arrayWithObjects:
            @"{search}",
            @"A", @"B", @"C", @"D", @"E", @"F",
            @"G", @"H", @"I", @"J", @"K", @"L",
            @"M", @"N", @"O", @"P", @"Q", @"R",
            @"S", @"T", @"U", @"V", @"W", @"X",
            @"Y", @"Z", @"#", nil ];
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
	//if( [albumList_ count] == 0 ) return;
    if( albumActiveSections_ == nil ) return;
    
	//NSDictionary *d = [albumList_ objectAtIndex:[indexPath row]];
    NSString *secTitle = [albumSectionTitles_ objectAtIndex:indexPath.section];
    
    unichar buffer[1];
    NSRange r;
    r.location = 0;
    r.length   = 1;
    [secTitle getCharacters:buffer range:r];
    NSInteger sectionIndex = buffer[0] - 65;
	
	if( sectionIndex<0 ) {
		sectionIndex = sizeof(albumDisplayList_)/sizeof(albumDisplayList_[0]) - 1;
	}
    
	if( sectionIndex<0 || sectionIndex >= 27 ) {
		//printf( "outta bounds: %d\n", sectionIndex );
		return;
	}

	NSDictionary *d = [albumDisplayList_[sectionIndex] objectAtIndex:indexPath.row];
    AppData *app = [AppData get];
    
    if( app.coverflowDisplayType_ == 1 )
        [app.images_ removeAllObjects];
    
    NowPlayingController *nowplayingVC = [[NowPlayingController alloc] init];
    app.currentAlbum_ = [d objectForKey:@"albumTitle"];

    [nowplayingVC setupnavigationitems:self.navigationItem 
                                navBar:[self navigationController].navigationBar
                              datadict:d];
    
    [self navigationController].navigationBarHidden = FALSE;

    [[self navigationController] pushViewController:nowplayingVC animated:YES];		
    
    [nowplayingVC release];
}


#pragma mark UITableView datasource


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger) section
{
    if( [albumSectionTitles_ count] == 0 ) 
        return nil;
    else {
        NSString *rst = [albumSectionTitles_ objectAtIndex:section];
        return rst;
    }
    
    return nil;
}


- (NSInteger)
numberOfSectionsInTableView:(UITableView *)tableView
{
    if( shuffleview_ ) return 1;
    
    if( [albumSectionTitles_ count] == 0 )
        return 1;
    else if( searchActive_ )
		return 1;
	else
        return nAlbumActiveSessions_;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index 
{
    if( index == 0 ) {
        [tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
        return -1;
    }
    return index  - 1;
}


- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( albumActiveSections_ && section < [albumActiveSections_ count]) {
        NSInteger ns = [[albumActiveSections_ objectAtIndex:section] count];
        return ns;
    }
    else return 0;
}


- (UIView *)tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger)section {
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 24)] 
                          autorelease];
    
	UILabel *sectionTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, -1, tableView.bounds.size.width, 24)] 
                             retain];
	sectionTitle.backgroundColor = [UIColor clearColor];
	sectionTitle.font            = [UIFont boldSystemFontOfSize:18];
	sectionTitle.textColor       = [UIColor whiteColor];
	sectionTitle.shadowColor     = [UIColor colorWithRed:.373 green:.141 blue:.024 alpha:1];
	sectionTitle.shadowOffset    = CGSizeMake(0, 1);
	if( searchActive_ ) {
		sectionTitle.text		= [NSString stringWithFormat:@"Search: %d items", [[albumActiveSections_ objectAtIndex:0] count]];
	} else {
        if( shuffleview_ ) 
            sectionTitle.text   = @"All Albums";
        else {
            if( section < [albumSectionTitles_ count] ) 
                sectionTitle.text        = [albumSectionTitles_ objectAtIndex:section];
        }
	}
    
    UIImageView *sectionBG       = [[[UIImageView alloc] initWithImage:sectionBGImage_] retain];
    
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
    static NSString *CellIdentifier = kCellIdentifier;

    AlbumCell *cell = (AlbumCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AppData *app = [AppData get];

	if( cell == nil ) {
        UIImage *image = [app.albumArtCache_ loadImage:@"empty_album_art.png"];
        cell = [[[AlbumCell alloc] initWithFrame:CGRectZero 
                                reuseIdentifier:CellIdentifier tableView:tableView image:image] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
    else {
        // just update the earlier cell with the new values
        UIImage *image = [app.albumArtCache_ loadImage:@"empty_album_art.png"];
        [cell setCellImage:image];
    }

	
	// get the view controller's info dictionary based on the indexPath's row
	//cell.dataDictionary = [[albumList_ objectAtIndex:indexPath.row] retain];
    if( albumActiveSections_ )
        cell.dataDictionary = [[albumActiveSections_ 
                                objectAtIndex:indexPath.section] 
                               objectAtIndex:indexPath.row];
    
	return cell;
}


#pragma mark ------------------------------------------------
#pragma mark textfield callback, delegate routines
#pragma mark ------------------------------------------------

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
	
	NSArray* fullList = fullAlbumList_;
	
    // flush and save the current list content in case the user cancels the search later
    [savedAlbumList_ removeAllObjects];
    
	NSDictionary *album;
	for( album in fullList ) {
		NSString *name = [album objectForKey:@"albumTitle"];
		[savedAlbumList_ addObject:name];
	}
    //[savedalbumList_ addObjectsFromArray: fullList];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchfield_.showsCancelButton = NO;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [albumList_ removeAllObjects];    // clear the filtered array first
    for( unsigned i = 0; i < 27; i++ ) {
        [albumDisplayList_[i] removeAllObjects];
    }
    
    //[artistSectionTitles_ removeAllObjects];
    
	NSArray* fullList = fullAlbumList_;
	
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
		NSString *name = [artist objectForKey:@"albumTitle"];
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
		
        //[albumDisplayList_[sectionIndex] addObject:artist];
        [albumDisplayList_[0] addObject:artist];
	}
    
	searchActive_ = TRUE;
	[table_ reloadData];
}


// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the saved list content
    if (searchBar.text.length > 0) {
        [albumList_ removeAllObjects];
        [albumList_ addObjectsFromArray: savedAlbumList_];
    }
    
    [table_ reloadData];
    
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
	[albumList_ removeAllObjects];
    
	NSString *search = searchfield_.text;
	if( [search length] == 0 ) {
		[self shuffle];
		return;
	}
	
	NSArray* fullList = fullAlbumList_;
	
	NSDictionary *artist;
	for (artist in fullList) {
		NSString *name = [artist objectForKey:@"albumTitle"];
		NSRange r = [name rangeOfString:search options:NSCaseInsensitiveSearch];
		if( r.location == NSNotFound || r.length == 0 )
			continue;
		[albumList_ addObject:artist];
	}
	
	[table_ reloadData];
}



- (BOOL)textFieldShouldReturn:(UITextField *)thetextField {
	[thetextField resignFirstResponder];
	return YES;
}

@end
