//
//


#import "TracklistTableCell.h"
#import "appdata.h"

@implementation TracklistTableCell

@synthesize tracknumlabel_;
@synthesize tracknamelabel_;
@synthesize tracklenlabel_;
@synthesize currentlyPlayingTrack_;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		columns = [[NSMutableArray arrayWithCapacity:5] retain];
        
        highlightimgview_ = [[[AsyncImageView alloc] initWithFrame:CGRectMake(10, 2, 10, 10)] retain];
        [self.contentView addSubview:highlightimgview_];
        
        tracknumlabel_ = [[[UILabel	alloc] initWithFrame:CGRectMake(0.0, 0, 30.0, 
                                                                    self.bounds.size.height)] retain]; 
        
        [self.contentView addSubview:tracknumlabel_];
        tracknamelabel_ =  [[[UILabel alloc] initWithFrame:CGRectMake( 60.0, 0, 175.0, 
                                                            self.bounds.size.height ) ] retain]; 
        
        [self.contentView addSubview:tracknamelabel_];

        tracklenlabel_ =  [[[UILabel alloc] initWithFrame:CGRectMake( 260.0, 0, 60.0, 
                                                            self.bounds.size.height )] retain];
        
        [self.contentView addSubview:tracklenlabel_];

        [self addColumn:50];
        [self addColumn:250];

        /*
        UILabel *titleLabel = [self newLabelForMainText:YES];
        titleLabel.textAlignment = UITextAlignmentLeft; // default
        [myContentView addSubview: titleLabel];
        [titleLabel release];
        */
        //self.backgroundView = [[[UIImageView alloc] initWithImage:rowBackground] autorelease];
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage: [ UIImage imageNamed: @"yellow_bar.png" ] ];
        self.selectedBackgroundView = imageView;
        [imageView release];
	}
	return self;
}

#define LABEL_TAG 1
#define VALUE_TAG 2 


-(void) setTrackLabels:(int) row
{
    AppData *app = [AppData get];
    
    currentlyPlayingTrack_ = [app currentTrackIndex_];
    
    tracknumlabel_.tag              = LABEL_TAG; 
    tracknumlabel_.font             = [UIFont boldSystemFontOfSize:12];
    tracknumlabel_.text             = [NSString stringWithFormat:@"%d", row + 1];
    tracknumlabel_.textAlignment    = UITextAlignmentRight; 
    tracknumlabel_.textColor        = [UIColor whiteColor];
    tracknumlabel_.backgroundColor  = [UIColor clearColor];
    tracknumlabel_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
    UIViewAutoresizingFlexibleHeight; 

    if( [app currentTrackIndex_] == row ) {
        //printf("c index %d :: row: %d\n", currentlyPlayingTrack_, row);
        [self highlight:YES];
    }
    else {
        [self highlight:NO];
    }

    tracknamelabel_.tag              = VALUE_TAG; 
    tracknamelabel_.font             = [UIFont boldSystemFontOfSize:12.0];
    tracknamelabel_.textAlignment    = UITextAlignmentLeft; 
    tracknamelabel_.textColor        = [UIColor whiteColor]; 
    tracknamelabel_.backgroundColor  = [UIColor clearColor];
    tracknamelabel_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
    UIViewAutoresizingFlexibleHeight; 

    NSDictionary *d        = [app.trackList_ objectAtIndex:row];

    NSString *tracktitle   = [d objectForKey:@"trackTitle"];
    tracknamelabel_.text   = tracktitle;

    NSString *tracklength  = [d objectForKey:@"trackLength"];
    
    float len  = [tracklength floatValue];
    float sec  = (len/1000); // convert from ms to s
    float min  = sec/60;
    int   imin = (int)  min ;
    float fsec  = (sec - imin*60) ;
    int   isec = (int) floor( fsec );
    
    tracklenlabel_.font            = [UIFont boldSystemFontOfSize:12.0];
    tracklenlabel_.textColor       = [UIColor whiteColor];
    tracklenlabel_.textAlignment   = UITextAlignmentLeft;
    tracklenlabel_.backgroundColor = [UIColor clearColor];
    tracklenlabel_.text            = [NSString stringWithFormat:@"%2d:%02d", imin, isec];
    

    
    return;
}


- (void)addColumn:(CGFloat)position 
{
	[columns addObject:[NSNumber numberWithFloat:position]];
}


- (void)highlight:(BOOL) highlighted
{
    if( highlighted == YES ) {
        self.backgroundColor = [UIColor redColor];
        //self.selected = YES;
        //[super setSelected:YES animated:YES];
        //[highlightimgview_ loadImage:@"speaker_loud.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage: [ UIImage imageNamed: @"yellow_bar.png" ] ];
        self.backgroundView = imageView;
        [imageView release];
    }
    else {
        self.backgroundView = nil;
        //self.selected = NO;
        //[super setSelected:NO animated:YES];
    }
}


- (void)drawRect:(CGRect)rect 
{ 
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// just match the color and size of the horizontal line
	CGContextSetRGBStrokeColor( ctx, 0.5, 0.5, 0.5, 1.0 ); 
	CGContextSetLineWidth( ctx, 0.25 );

	for (int i = 0; i < [columns count]; i++) {
		// get the position for the vertical line
		CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
		CGContextMoveToPoint( ctx, f, 0 );
		CGContextAddLineToPoint( ctx, f, self.bounds.size.height );
	}


	CGContextStrokePath( ctx );
	
	[super drawRect:rect];
} 



- (void)dealloc 
{
    [highlightimgview_ release];
    [tracknumlabel_ release];
    [tracknamelabel_ release];
    [tracklenlabel_ release];
    
	[columns release];
	[super dealloc];
}


@end
