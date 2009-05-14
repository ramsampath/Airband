//
//  TracklistTableCell.h
//  airband
//
//  Created by Ram Sampath on 5/13/09.
//  Copyright 2009 Centroid PIC/Elliptic All rights reserved.
//


#import <UIKit/UIKit.h>


@interface TracklistTableCell : UITableViewCell {

	NSMutableArray *columns;
}

- (void)addColumn:(CGFloat)position;

@end
