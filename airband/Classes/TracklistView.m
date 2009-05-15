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

@implementation TracklistController


#define LABEL_TAG 1 
#define VALUE_TAG 2 
#define FIRST_CELL_IDENTIFIER @"TrailItemCell" 
#define SECOND_CELL_IDENTIFIER @"RegularCell" 

-(id) initWithFrame:(CGRect )frame
{
    [super initWithFrame:frame];
    
    UITableView *table_ = self;
    
    table_.allowsSelectionDuringEditing = NO;
    self.backgroundColor              = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tracklist_background.png"]];    
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
	NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
	
	TracklistTableCell *cell = (TracklistTableCell *)[self dequeueReusableCellWithIdentifier:MyIdentifier];

    AppData *app = [AppData get];

	if (cell == nil) {
		cell = [[[TracklistTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		
		UILabel *label = [[UILabel	alloc] initWithFrame:CGRectMake(0.0, 0, 30.0, 
														   self.rowHeight)]; 
		[cell addColumn:50];
		label.tag              = LABEL_TAG; 
		label.font             = [UIFont boldSystemFontOfSize:12];
		label.text             = [NSString stringWithFormat:@"%d", indexPath.row + 1];
		label.textAlignment    = UITextAlignmentRight; 
		label.textColor        = [UIColor whiteColor];
        label.backgroundColor  = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
                                 UIViewAutoresizingFlexibleHeight; 
        
        if( [app currentTrackIndex_] == [indexPath row] ) {
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:@"currently_playing_arrow.png"];
            UIImageView *currentlyplayingview = [[UIImageView alloc] initWithImage:image];
            currentlyplayingview.frame = CGRectMake(0, 20, 5, 5);
            [label addSubview:currentlyplayingview];
        }
         
		[cell.contentView addSubview:label]; 

        label =  [[UILabel	alloc] initWithFrame:CGRectMake( 60.0, 0, 200.0, 
															self.rowHeight ) ]; 
        [cell addColumn:240];
		label.tag              = VALUE_TAG; 
		label.font             = [UIFont boldSystemFontOfSize:12.0];
		label.textAlignment    = UITextAlignmentLeft; 
		label.textColor        = [UIColor whiteColor]; 
        label.backgroundColor  = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
                                 UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:label]; 

        NSDictionary *d        = [app.trackList_ objectAtIndex:[indexPath row]];
        NSString *tracktitle   = [d objectForKey:@"trackTitle"];
        label.text             = tracktitle;
        
        NSString *tracklength  = [d objectForKey:@"trackLength"];
        float len  = [tracklength floatValue];
        float sec  = (len/1000); // convert from ms to s
        float min  = sec/60;
        int   imin = (int)  min ;
        float fsec  = (sec - imin*60) ;
        int   isec = (int) floor( fsec );
        label =  [[UILabel	alloc] initWithFrame:CGRectMake( 260.0, 0, 60.0, 
															self.rowHeight )];
        label.textColor       = [UIColor whiteColor];
        label.textAlignment   = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.text            = [NSString stringWithFormat:@"%2d:%02d", imin, isec];
        [cell.contentView addSubview:label];
	}


	return cell;
}


-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // play the track selected
    AppData *app = [AppData get];
    NSDictionary *d        = [app.trackList_ objectAtIndex:[indexPath row]];

    [app playTrack:d];
    
    return;
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
	[super dealloc];
}


@end

