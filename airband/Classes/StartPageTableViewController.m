
#import "appdata.h"
#import "StartPageTableViewController.h"


@implementation StartPageTableViewController
@synthesize toolbar;
@synthesize pages;
@synthesize selectedArray;
@synthesize inPseudoEditMode;
@synthesize selectedImage;
@synthesize unselectedImage;
@synthesize deleteButton;

#define kBgColor   [UIColor colorWithRed:0.212 green:0.212 blue:0.212 alpha:1.000];


- (void)populateSelectedArray
{
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[pages count]];
	for (int i=0; i < [pages count]; i++)
		[array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
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

    
    tableV                                = [[UITableView alloc] init];
    tableV.delegate                        = self;
    tableV.dataSource                      = self;
    tableV.frame                           = CGRectMake(0, 0, 320, 480);
    tableV.backgroundColor                 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LogoBkgrnd.png"]];
    tableV.separatorStyle                  = UITableViewCellSeparatorStyleNone;

    [mainview addSubview:tableV];
    self.view = mainview;
}


- (void)viewDidLoad 
{
    checkboxArray[0] = TRUE;
    [super viewDidLoad];
}



#pragma mark ------------------------------------------------
#pragma mark UITableView delegates
#pragma mark ------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 3;
}

- (NSInteger)
numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];

    for(NSInteger i = 0; i < 3; i++) {
        checkboxArray[i] = FALSE;
    }
    AppData *app = [AppData get];
    app.startpage_ = row;
    checkboxArray[row] = TRUE;
    [tableV reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	static NSString *CellIdentifier = @"Cell";
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
        UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
    }
    NSInteger row = [indexPath row];
    cell.textLabel.textColor = [UIColor whiteColor];
    AppData *app = [AppData get];

    for(NSInteger i = 0; i < 3; i++) {
        if( i == app.startpage_ )
            checkboxArray[i] = TRUE;
        else {
            checkboxArray[i] = FALSE;
        }
    }
    if( checkboxArray[row] == TRUE )
		cell.imageView.image = [UIImage imageNamed:@"selected.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"unselected.png"];
    if (row  == 0)
	{
        cell.textLabel.text = [NSString stringWithFormat:@"Artists", [indexPath row]];

	}
	else if (row == 1)
	{
        cell.textLabel.text = [NSString stringWithFormat:@"Albums", [indexPath row]];

	}
	else
	{
        cell.textLabel.text = [NSString stringWithFormat:@"Playlists", [indexPath row]];
	}

	
	return cell;
    
}

- (void)dealloc 
{
	[toolbar release];
	[pages release];
	[selectedArray release];
	[selectedImage release];
	[unselectedImage release];
	[deleteButton release];
	[super dealloc];
}


@end

