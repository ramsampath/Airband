//
//  AllSettingsController.m
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC. All rights reserved.
//

#import "AllSettingsController.h"
#import "SettingsController.h"
#import "AllSettingsTableCell.h"
#import	"PlaylistTracksController.h"

@implementation AllSettingsController

@synthesize table_;
@synthesize dataArray;


- (void)viewDidAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = FALSE;
}

- (void) viewWillAppear{
	[table_ reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
	[table_ setNeedsDisplay];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	table_ = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    table_.delegate = self;
    table_.dataSource = self;
    table_.sectionHeaderHeight = 20.0;
    table_.rowHeight = 40.0;
    CGRect titleRect = CGRectMake( 0, 0, 300, 40 );
	
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
	
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
	tableTitle.textAlignment = UITextAlignmentCenter;
    tableTitle.text = @"Sites";
	
	table_.tableHeaderView = tableTitle;
	
    [tableTitle release];
	self.view = table_;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{	
	// load our data data from a plist file inside our app bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"SettingsData" ofType:@"plist"];
	self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];

}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)
numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{

	return [self.dataArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

	
	UITableViewCell *mp3tunescell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (mp3tunescell == nil) {
		mp3tunescell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		mp3tunescell.accessoryType  = UITableViewCellAccessoryDetailDisclosureButton;
		mp3tunescell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	NSMutableDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
	mp3tunescell.text = [item objectForKey:@"Server"];

	[item setObject:mp3tunescell forKey:@"cell"];	
			
	BOOL checked = [[item objectForKey:@"Selected"] boolValue];
	UIImage *image = (checked) ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
		
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	button.frame = frame;	// match the button's size with the image size
		
	[button setBackgroundImage:image forState:UIControlStateNormal];
		
	// set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	mp3tunescell.accessoryView = button;

	return mp3tunescell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = indexPath.row;
    if (row == NSNotFound) 
		return;
	
	if( row == 0 ) {
		SettingsController *settings = [[SettingsController alloc] initWithNibName:@"Settings" bundle:nil];	
		[[self navigationController] pushViewController:settings animated:YES];
	}
}


- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.table_];
	NSIndexPath *indexPath = [self.table_ indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.table_ accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{	
	BOOL checked = FALSE;
	NSInteger row = indexPath.row;
	
	int i;	
	for (i=0;  i< [self.dataArray count]; ++i) {
		NSMutableDictionary *item = [dataArray objectAtIndex:i];
		if( i == row ) {
			[item setObject:[NSNumber numberWithBool:TRUE] forKey:@"Selected"];
			checked = TRUE;
			printf ("checked true\n");
		}
		else {
			[item setObject:[NSNumber numberWithBool:FALSE] forKey:@"Selected"];
			checked = FALSE;
			printf ("checked false\n");
		}

		printf ("%d\n", checked);

		UITableViewCell *cell = [item objectForKey:@"cell"];
		UIButton *button = (UIButton *)cell.accessoryView;
			
		UIImage *newImage = (checked == FALSE) ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}        
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[dataArray release];
    [super dealloc];
}


@end
