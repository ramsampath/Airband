//
//  PlaylistController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"



@interface PlaylistController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet  UITableView  *table_;
    LoadingView            *loadingView_;
    UIView                 *progressView_;
}

@property (nonatomic, retain) UITableView* table_;

@end



