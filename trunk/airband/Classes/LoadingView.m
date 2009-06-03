//
//  LoadingView.m
//  airband
//
//  Created by Ram Sampath on 5/22/09.
//  Copyright 2009 Elliptic/Centroid PIC. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>


CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint( path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius );

	// Top left corner
	CGPathAddArcToPoint( path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius );

	// Top right corner
	CGPathAddArcToPoint( path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius );

	// Bottom right corner
	CGPathAddArcToPoint( path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius );

	// Bottom left corner
	CGPathAddArcToPoint( path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius );

	// Close the path at the rounded rect
	CGPathCloseSubpath( path );
	
	return path;
}

@implementation LoadingView

@synthesize loadingLabel_;

//
// loadingViewInView:
//
+ (id)loadingViewInView:(UIView *)aSuperview loadingText:(NSString *)ltext
{
    LoadingView *lview = [LoadingView loadingViewInView:aSuperview loadingText:ltext fontSize:0.0];
    
    return lview;
}

+ (id)loadingViewInView:(UIView *)aSuperview loadingText:(NSString *)ltext fontSize:(float) fontSize
{
	LoadingView *loadingView =
    [[[LoadingView alloc] initWithFrame:[aSuperview bounds] fontSize:fontSize] autorelease];
	if( !loadingView ) {
		return nil;
	}
    
    loadingView.loadingLabel_.text            = NSLocalizedString( ltext, nil );

    if( fontSize == 0 )
        loadingView.loadingLabel_.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    else
        loadingView.loadingLabel_.font = [UIFont boldSystemFontOfSize:fontSize];
    
	loadingView.loadingLabel_.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;

	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
    [aSuperview addSubview:loadingView];
    [loadingView release];

	return loadingView;
}

- (id) initWithFrame:(CGRect) frame fontSize:(float)fontSize
{
    [super initWithFrame:frame];
    
	self.opaque = NO;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	const CGFloat DEFAULT_LABEL_WIDTH  = 280.0;
	const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
	CGRect labelFrame = CGRectMake( 0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT );
	loadingLabel_ = [[[UILabel alloc] initWithFrame:labelFrame] retain];
	loadingLabel_.textColor       = [UIColor whiteColor];
	loadingLabel_.backgroundColor = [UIColor clearColor];
	loadingLabel_.textAlignment   = UITextAlignmentCenter;
    
 
	
	[self addSubview:loadingLabel_];
    
	 activityIndicatorView_ = [[[UIActivityIndicatorView alloc]
                                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
                                                      retain];
    activityIndicatorView_.frame = CGRectMake( activityIndicatorView_.frame.origin.x, 
                                             activityIndicatorView_.frame.origin.y,
                                             20, 20 );
	[self addSubview:activityIndicatorView_];
    
	activityIndicatorView_.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    
	[activityIndicatorView_ startAnimating];
	
	CGFloat totalHeight = loadingLabel_.frame.size.height + activityIndicatorView_.frame.size.height;
	labelFrame.origin.x = floor(0.5 * (self.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (self.frame.size.height - totalHeight));
	loadingLabel_.frame  = labelFrame;
	
	CGRect activityIndicatorRect = activityIndicatorView_.frame;
    
	activityIndicatorRect.origin.x =
    0.5 * (self.frame.size.width - activityIndicatorRect.size.width);

    if( fontSize == 0 )
        activityIndicatorRect.origin.y =
		loadingLabel_.frame.origin.y + loadingLabel_.frame.size.height;
    else {
        activityIndicatorRect.origin.y =
		loadingLabel_.frame.origin.y + self.frame.size.height * fontSize/20.0;
        activityIndicatorRect.size.width  = 18;
        activityIndicatorRect.size.height = 18;
    }
    
	activityIndicatorView_.frame = activityIndicatorRect;
    
    return self;
}



//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];

	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
	rect.size.height -= 1;
	rect.size.width -= 1;
	
	const CGFloat RECT_PADDING = 8.0;
	rect = CGRectInset( rect, RECT_PADDING, RECT_PADDING );
	
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
	CGPathRef roundRectPath = NewPathWithRoundRect( rect, ROUND_RECT_CORNER_RADIUS );
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	const CGFloat BACKGROUND_OPACITY = 0.5;
	CGContextSetRGBFillColor( context, 0, 0, 0, BACKGROUND_OPACITY );
	CGContextAddPath( context, roundRectPath) ;
	CGContextFillPath( context );

	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor( context, 1, 1, 1, STROKE_OPACITY );
	CGContextAddPath( context, roundRectPath );
	CGContextStrokePath( context );
	
	CGPathRelease( roundRectPath );
}

//
// dealloc
//
// Release instance memory.
//
- (void)dealloc
{
    [loadingLabel_ release];
    [activityIndicatorView_ release];

    [super dealloc];
}

@end
