//
//  TracklistController.h
//  airband
//
//  Created by Ram Sampath on 5/13/09.
//  Copyright 2009 Centroid PIC/Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface TracklistController : UIViewController< UITableViewDelegate, UITableViewDataSource >
@interface TracklistController: UITableView
{
    //IBOutlet UITableView  *table_;  
}

-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//@property(readonly) UITableView *table_;

@end
