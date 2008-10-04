//
//  PlaylistController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Imageworks. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface PlaylistController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet  UITableView* table_;
}

@property (nonatomic, retain) UITableView* table_;

@end



