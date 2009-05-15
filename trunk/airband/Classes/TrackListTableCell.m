//
//


#import "TracklistTableCell.h"


@implementation TracklistTableCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		columns = [NSMutableArray arrayWithCapacity:5];
		[columns retain];
        
        /*
        UILabel *titleLabel = [self newLabelForMainText:YES];
        titleLabel.textAlignment = UITextAlignmentLeft; // default
        [myContentView addSubview: titleLabel];
        [titleLabel release];
        */
        //self.backgroundView = [[[UIImageView alloc] initWithImage:rowBackground] autorelease];
        self.backgroundColor = [UIColor clearColor];
        //self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:@"yellow_bar.png"] autorelease];
        
	}
	return self;
}


- (void)addColumn:(CGFloat)position 
{
	[columns addObject:[NSNumber numberWithFloat:position]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	[super setSelected:selected animated:animated];

    // Configure the view for the selected state
    // Add an image view to display a picture
    /*
    UIView *myContentView = self.contentView;

    UIImageView *imageView = [[UIImageView alloc] initWithImage: [ UIImage imageNamed: @"yellow_bar.png" ] ];
    [myContentView addSubview:imageView];
    [imageView release];
     */
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
	[super dealloc];
	[columns dealloc];
}


@end
