//
//  buttonmechViewController.m
//  buttonmech
//
//  Created by Scot Shinderman on 4/11/09.
//  Copyright Imageworks 2009. All rights reserved.
//

#import "buttonmechViewController.h"

@implementation ButtonmechViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	// create by hand
	//	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

	// use the one in the .xib
	UIButton *button = volume_;
	
	image_ = [[UIImage imageNamed:@"volSpinner.png"] retain];
	
	CGRect frame = CGRectMake(0.0, 0.0, image_.size.width, image_.size.height);
	button.frame = frame;	// match the button's size with the image size
	
	//[button setBackgroundImage:image_ forState:UIControlStateNormal];
	[button setImage:image_ forState:UIControlStateNormal];
	
	// set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
	[button addTarget:self action:@selector(volButtonTapped:event:) 
	 forControlEvents:UIControlEventTouchDown];

	[button addTarget:self action:@selector(volButtonDrag:event:) 
	 forControlEvents:UIControlEventTouchDragInside];

	button.backgroundColor = [UIColor clearColor];	
}


- (void)volButtonDrag:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];	
	
	// [note] -- doing the calc in the parent coord system
	CGPoint currentTouchPosition = [touch locationInView:volume_.superview];
	//float cx=image_.size.width/2.0;
	//float cy=image_.size.height/2.0;
	float cx = volume_.frame.origin.x + volume_.frame.size.width/2;
	float cy = volume_.frame.origin.y + volume_.frame.size.height/2;
	
	float theta1 = atan2( -(dragStart_.y-cy), dragStart_.x-cx );
	float theta2 = atan2( -(currentTouchPosition.y-cy), currentTouchPosition.x-cx );
	// append the transform
	volume_.transform = CGAffineTransformRotate( volume_.transform, theta1-theta2 );
	dragStart_ = currentTouchPosition;
}

- (void)volButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];	
	CGPoint currentTouchPosition = [touch locationInView:volume_.superview];
	dragStart_ = currentTouchPosition;
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
