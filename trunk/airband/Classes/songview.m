//
//  songview.m
//  NavBar
//
//  Created by Scot Shinderman on 8/15/08.
//  Copyright 2008 Imageworks. All rights reserved.
//

#import "songview.h"
#import "appdata.h"
#import <QuartzCore/QuartzCore.h>

@implementation songview

@synthesize title_;

- (id) init
{
	if( self = [super init] )
	{
		data_ = nil;
	}
	
	return self;
}



-(id)initWithFrame:(CGRect)frame andTitle:(NSDictionary*)d {
	if (self = [super initWithFrame:frame]) {		
		self.alpha = 0.5;
		image_ = 0;
		data_ = nil;
		title_ = [d retain];
		
		NSString *artist = [d objectForKey:@"artistName"];		
		
		CGRect r= CGRectMake( 0,0, frame.size.width, frame.size.height);		
		UILabel *label = [[UILabel alloc] initWithFrame:r];
		label.text = artist;
		label.backgroundColor = [UIColor blackColor];
		label.textColor = [UIColor colorWithWhite:1 alpha:1];
		[self addSubview:label];		
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {

		self.alpha = 0.5;
		image_ = 0;
		data_ = nil;
		
		
		
		/* these bits of core animation doesn't seem to be available on iphone?
		 
		CALayer *rootLayer = [CALayer layer];
		//rootLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
		//rootLayer.backgroundColor = [Controller color:C_BLACK];
		
		// informative header text		
		CALayer *headerTextLayer = [CATextLayer layer];
		headerTextLayer.name = @"header";
		[headerTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX]];
		[headerTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX]];
		[headerTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY offset:-10]];
		[headerTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"header" attribute:kCAConstraintMaxY offset:-64]];
		headerTextLayer.string = @"Loading Images...";
		headerTextLayer.style = textStyle;
		headerTextLayer.fontSize = 24;
		headerTextLayer.wrapped = YES;
		[rootLayer addSublayer:headerTextLayer];
		
		// the background canvas on which we'll arrange the other layers
		CALayer *containerLayer = [CALayer layer];
		containerLayer.name = @"body";
		[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
		[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth offset:-20]];
		[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"status" attribute:kCAConstraintMaxY offset:10]];
		[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"header" attribute:kCAConstraintMinY offset:-10]];
		[rootLayer addSublayer:containerLayer];

		
		// the central scrolling layer; this will contain the images
		CALayer *bodyLayer = [CAScrollLayer layer];
		bodyLayer.scrollMode = kCAScrollHorizontally;
		bodyLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		bodyLayer.layoutManager = [DesktopImageLayout layoutManager];
		[bodyLayer setValue:[NSValue valueWithSize:NSMakeSize(cellSpacing, cellSpacing)] forKey:@"spacing"];
		[bodyLayer setValue:[NSValue valueWithSize:NSMakeSize(cellSize, cellSize)] forKey:@"desktopImageCellSize"];
		[containerLayer addSublayer:bodyLayer];

		// the footer containing status info...
		CALayer *statusLayer = [CALayer layer];
		statusLayer.name = @"status";
		statusLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
		[statusLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"body" attribute:kCAConstraintMidX]];
		[statusLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"body" attribute:kCAConstraintWidth]];
		[statusLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY offset:10]];
		[statusLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"status" attribute:kCAConstraintMinY offset:32]];
		[rootLayer addSublayer:statusLayer];
		
		//...such as the image count
		CALayer *desktopImageCountLayer = [CATextLayer layer];
		desktopImageCountLayer.name = @"desktopImage-count";
		desktopImageCountLayer.style = textStyle;
		[desktopImageCountLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
		[desktopImageCountLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX]];
		[statusLayer addSublayer:desktopImageCountLayer];
		
		
		[self setLayer:rootLayer];
		//[self setWantsLayer:YES];
		 */
	}
	return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		
	[self.superview bringSubviewToFront:self];
	
	UITouch *t = [touches anyObject];		
	if( t )
	{
		if( [t tapCount] == 2 )
		{
			[UIView beginAnimations:@"subviewDrift" context:NULL];
			CGAffineTransform t	= self.transform;
			self.transform = CGAffineTransformScale( t, 3.0, 3.0 );
			
			AppData *app = [AppData get];
			[app play:title_];
			
			[UIView setAnimationDuration:0.5];
			[UIView commitAnimations];			
		}
	}
}



- (void)drawRect:(CGRect)rect {
	
	return ;
	
	/*
	CGRect	winrect = [self bounds];	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
	{			
		if( image_ )
		{			
			size_t h = CGImageGetHeight( image_ );
			size_t w = CGImageGetWidth( image_ );
			
			CGRect rect = CGRectMake( 0,0, 
									 winrect.size.width,
									 ((float) h * winrect.size.width / (float)w ));
			
			CGContextTranslateCTM( ctx, 0, rect.size.height/2 + winrect.size.height/2 );
			CGContextScaleCTM( ctx, 1, -1 );
			CGContextDrawImage( ctx, rect, image_ );
		}
				
		float white[4] = {1,1,1,1};		
		CGColorRef color = CGColorCreate( CGColorSpaceCreateDeviceRGB(), white);
		CGContextSetFillColorWithColor( ctx, color );
		CGContextShowTextAtPoint( ctx, 0,0, [title_ UTF8String], [title_ length] );
		CGColorRelease(color);
		
	}
	CGContextRestoreGState(ctx);	
	 */
}


- (void)dealloc {	
	[title_ release];
	[data_ release];
	[super dealloc];
}


-(void) setpicture:(CGImageRef)imgref data:(NSData*)data
{
	if( image_ )
	{
		CGImageRelease(image_);
		image_ = 0;		
	}
	
	[data_ release];
	
	data_ = data;
	image_ = imgref;
	[self setNeedsDisplay];
}


@end
