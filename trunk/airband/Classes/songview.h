//
//  songview.h
//  NavBar
//
//  Created by Scot Shinderman on 8/15/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface songview : UIView {
	CGImageRef image_;
	NSData *data_;
	NSDictionary *title_;
}

@property (retain) NSDictionary* title_;

-(id)initWithFrame:(CGRect)frame andTitle:(NSDictionary*)dictionary;
-(void) setpicture:(CGImageRef)imgref data:(NSData*)data;

@end
