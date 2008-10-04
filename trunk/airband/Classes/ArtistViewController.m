#import "AudioToolbox/AudioToolbox.h"
#import "appdata.h"
#import "ArtistViewController.h"
#import "PlaylistTracksController.h"


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
	nameLabel.text 	  = [dataDictionary objectForKey:@"artistName"];
	trackcountLabel.text = [dataDictionary objectForKey:@"trackCount"];
}

@end




#pragma mark ------------------------------------------------
#pragma mark controller
#pragma mark ------------------------------------------------

@implementation ArtistViewController

@synthesize artistTable_;

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


- (void)viewDidLoad
{	
	if( [artistList_ count] ) {
		return;
	}
	
	artistList_ = nil;				
	dbgtext_.text = @"greetings";	
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
	[UIView setAnimationDuration:4.0];	
	activity_.transform = CGAffineTransformMakeScale(4,4);
	[UIView commitAnimations];	
}


- (void)viewDidDisappear:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = TRUE;
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
	for (i=0;  i<num; ++i) 
	{
		int index = (int) (drand48() * [fullList count]);
		[artistList_ addObject:[fullList objectAtIndex:index]];		
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
	[[self navigationController] pushViewController:traxcontroller animated:YES];
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

-(IBAction) textfieldchanged:(id)sender
{	
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
