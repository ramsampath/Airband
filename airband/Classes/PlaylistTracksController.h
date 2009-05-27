//
//  PlaylistTracksController.h
//  airband
//
//  Created by Scot Shinderman on 9/7/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface PlaylistTracksController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet  UITableView* table_;
	// playlist tracks
	NSDictionary* playlist_;
	// used to display artist albums
	NSDictionary* artist_;	
	// used to display particular album tracks
	NSDictionary* albumtracks_;
    
    LoadingView *loadingView_;
    UIView      *progressView_;
}

@property (nonatomic, retain) UITableView* table_;
@property (nonatomic, retain) NSDictionary* playlist_;
@property (nonatomic, retain) NSDictionary* artist_;
@property (nonatomic, retain) NSDictionary* albumtracks_;

- (void) nowPlaying:(id) sender;

@end
