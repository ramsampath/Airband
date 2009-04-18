//
//  spinbutton.m
//  buttonmech
//
//  Created by Scot Shinderman on 4/12/09.
//  Copyright 2009 Imageworks. All rights reserved.
//

#import "spinbutton.h"


// todo -- flywheel effect, dynamic lighting 

@implementation Spinbutton

@synthesize angle;

- (id) init
{
	self = [super init];
	if (self != nil) {
		// can set this in the .xib etc.
		//UIImage *img = [[UIImage imageNamed:@"volSpinner.png"] retain];
		//[self setImage:img forState:UIControlStateNormal];
		
		angle = 0;
	}
	return self;
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint currentTouchPosition = [touch locationInView:self.superview];
	dragStart_ = currentTouchPosition;
	
	return [super beginTrackingWithTouch:touch withEvent:event];
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	// [note] -- doing the calc in the parent (easier) coord system
	CGPoint currentTouchPosition = [touch locationInView:self.superview];

	float cx = self.frame.origin.x + self.frame.size.width/2;
	float cy = self.frame.origin.y + self.frame.size.height/2;	
	float theta1 = atan2( -(dragStart_.y-cy), dragStart_.x-cx );
	float theta2 = atan2( -(currentTouchPosition.y-cy), currentTouchPosition.x-cx );
	// append the transform
	self.transform = CGAffineTransformRotate( self.transform, theta1-theta2 );
	dragStart_ = currentTouchPosition;
	
	angle += (theta2-theta1);
	
	return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	printf( "final angle: %f\n", angle );
	[super endTrackingWithTouch:touch withEvent:event];
}



@end
