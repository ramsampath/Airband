//
//  TracklistTableCell.h
//  airband
//
//  Created by Ram Sampath on 5/13/09.
//  Copyright 2009 Centroid PIC/Elliptic All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AsyncImageView.h"


@interface TracklistTableCell : UITableViewCell 
{
	NSMutableArray* columns;
    
    UILabel*        tracknumlabel_;
    UILabel*        tracknamelabel_;
    UILabel*        tracklenlabel_;
    
    AsyncImageView* highlightimgview_;
    
    int             currentlyPlayingTrack_;
}

@property(readonly) UILabel* tracknumlabel_;
@property(readonly) UILabel* tracknamelabel_;
@property(readonly) UILabel* tracklenlabel_;

@property(readwrite) int currentlyPlayingTrack_;

-(void)addColumn:(CGFloat)position;
-(void)highlight:(BOOL) highlighted;

-(void)setTrackLabels:(int) row;


@end
