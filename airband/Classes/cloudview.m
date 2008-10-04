//
//  cloudview.m
//  airband
//
//  Created by Scot Shinderman on 8/31/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import "cloudview.h"
#import "appdata.h"
#import "songview.h"

@implementation cloudview



- (id) init
{
	printf( "hello from cloudview init\n" );
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	printf( "hello from cloudview initWithFrame\n" );
	if (self = [super initWithFrame:frame]) {	
		[self setup];
	}
	return self;
}


static BOOL g_lame = TRUE;

-(void) setup
{
	AppData *app = [AppData get];
	NSArray* fullList = app.fullArtistList_;

	CGRect	frame = [self bounds];
	
	int index,i; 
	for( i=0; i<20; ++i ) 
	{
		index = drand48() * [fullList count];
		NSDictionary *d = [fullList objectAtIndex:index];		
		
		CGRect r= CGRectMake( drand48()*frame.size.width, 
							 drand48()*frame.size.height, 100, 20 );
		
		songview *sv = [[[songview alloc] initWithFrame:r andTitle:d] autorelease];					
		
		//printf( "subwindow(%d): %s\n", i, [sv.title_ UTF8String] );
		
		[self addSubview:sv];			
		[self bringSubviewToFront:sv];
	}	

	// Configure and start the accelerometer
	//[[UIAccelerometer sharedAccelerometer] setUpdateInterval:.1];
	//[[UIAccelerometer sharedAccelerometer] setDelegate:self];	
}



- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
	if( fabs(acceleration.x)<0.01 && fabs(acceleration.z)<0.01 )
		return;
	
	CGRect	bounds = [self bounds];
	
	[UIView beginAnimations:@"subviewDrift" context:NULL];
	
	NSArray *subs = self.subviews;
	songview *sv;
	for (sv in subs) {		
		CGAffineTransform t	= sv.transform;
		
		t.tx += 20.0*acceleration.x;
		if( t.tx<-200 ) t.tx = -200;
		else if( t.tx > bounds.size.width-10 ) t.tx = bounds.size.width-10;
		
		t.ty -= 20.0*acceleration.z;
		if( t.ty<-200 ) t.ty = -200;
		else if( t.ty > bounds.size.height-20 ) t.ty = bounds.size.height-20;
		
		sv.transform = t;		
	}
	
	[UIView setAnimationDuration:0.05];
	[UIView commitAnimations];
}



- (void)drawRect:(CGRect)rect {

	CGRect	winrect = [self bounds];
	
	// where is the init coming from?
	if( g_lame )
	{
		g_lame = FALSE;
		[self setup];
	}
	
	NSString *s = @"test";
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	CGContextSaveGState(ctx);
	{				
		CGContextClipToRect(ctx, winrect);		
		CGContextClearRect( ctx, winrect);
		
		size_t num_locations = 2;
		CGFloat locations[2] = { 0.0, 1.0 };
		CGFloat components[8] = { 0.2, 0.2, 0.4, 1.0,  // Start color
		0.1, 0.2, 0.9, 1.0 }; // End color
		
		CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();		
		CGGradientRef  myGradient = CGGradientCreateWithColorComponents (myColorSpace, components,
																		 locations, num_locations);		
		
		CGPoint myStartPoint = CGPointMake(5,5), myEndPoint;
		myEndPoint.x = winrect.size.width-5;
		myEndPoint.y = winrect.size.height-5;
		CGContextDrawLinearGradient (ctx, myGradient, myStartPoint, myEndPoint, 0);		
		CGGradientRelease( myGradient );
		
		float white[4] = {1,1,1,1};		
		CGColorRef color = CGColorCreate( CGColorSpaceCreateDeviceRGB(), white);
		CGContextSetFillColorWithColor( ctx, color );
		CGContextShowTextAtPoint( ctx, 20,80, [s UTF8String], [s length] );
		CGColorRelease(color);
	}
	CGContextRestoreGState(ctx);		
}


- (void)dealloc {
	[super dealloc];
}


@end
