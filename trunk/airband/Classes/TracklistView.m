//
//  TracklistController.m
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC/Elliptic All rights reserved.
//

#import "TracklistView.h"
#import "TracklistTableCell.h"
#import "appdata.h"
#import "imgcache.h"

@implementation TracklistController


#define FIRST_CELL_IDENTIFIER @"TrailItemCell" 
#define SECOND_CELL_IDENTIFIER @"RegularCell" 

-(id) initWithFrame:(CGRect )frame
{
    [super initWithFrame:frame];
    
    UITableView *table_ = self;
    
    table_.allowsSelectionDuringEditing = NO;
    self.backgroundColor              = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tracklist_background@2x.png"]];    
    table_.alpha                      = 1.000;
    table_.alwaysBounceHorizontal     = NO;
    table_.alwaysBounceVertical       = NO;
    table_.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table_.bounces                    = YES;
    table_.bouncesZoom                = YES;
    table_.canCancelContentTouches    = YES;
    table_.clearsContextBeforeDrawing = NO;
    table_.clipsToBounds              = YES;
    table_.contentMode                = UIViewContentModeScaleToFill;
    table_.delaysContentTouches       = YES;
    table_.directionalLockEnabled     = NO;
    table_.hidden                     = NO;
    table_.indicatorStyle             = UIScrollViewIndicatorStyleDefault;
    table_.maximumZoomScale           = 1.000;
    table_.minimumZoomScale           = 1.000;
    table_.multipleTouchEnabled       = NO;
    table_.opaque                     = NO;
    table_.pagingEnabled              = NO;
    table_.scrollEnabled              = YES;
    table_.separatorStyle             = UITableViewCellSeparatorStyleNone;
    table_.showsHorizontalScrollIndicator = YES;
    table_.showsVerticalScrollIndicator   = YES;
    table_.tag                        = 0;
    table_.userInteractionEnabled     = YES;

    return self;
}



- (void)viewDidLoad 
{
}


- (void)highlightTrack:(int) tracknum
{
}


-(NSInteger) numberOfSectionsInTableView
{
	return 1;
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section 
{
	self.separatorStyle = UITableViewCellSeparatorStyleNone;

    AppData *app = [AppData get];
    return [app.trackList_ count];
}


-(UITableViewCell *) cellForRowAtIndexPath:(NSIndexPath *) indexPath
{	
	//NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
	
    NSString *MyIdentifier = @"MyIdentifier";
    
	TracklistTableCell *cell = (TracklistTableCell *)[self dequeueReusableCellWithIdentifier:MyIdentifier];

	if (cell == nil) {
		cell = [[[TracklistTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}

    [cell setTrackLabels:[indexPath row]];
    
	return cell;
}

-(void) scrollToTrack:(int) tracknum
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tracknum inSection:0];
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // play the track selected
    AppData *app    = [AppData get];
    NSDictionary *d = [app.trackList_ objectAtIndex:[indexPath row]];

    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [app playTrack:d];
    [self reloadData];

    return;
}

- (void)viewWillDisappear:(BOOL)animated 
{
}

- (void)viewDidDisappear:(BOOL)animated 
{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
	[super dealloc];
}


@end

