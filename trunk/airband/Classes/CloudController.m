//
//  CloudController.m
//  airband
//
//  Created by Scot Shinderman on 8/31/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import "CloudController.h"
#import "cloudview.h"

@implementation CloudController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */


- (void)viewDidLoad {
	
	//printf( "view: %s\n", [[self.view description] UTF8String] );	
	/*
	 if( [self.view isKindOfClass:[cloudview class]] )
	{
		cloudview *v = (cloudview*) self.view;
		[v setup];
	}
	 */

	// xib stuff is wacked -- doesn't seem to set the correct type (or 
	// call any reasonable init-ish function)
	// so here we're explicitly replacing the view with our own
	
	// self.view = [[cloudview alloc] init];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
