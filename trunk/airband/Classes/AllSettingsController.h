//
//  AllSettingsController.h
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC/Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSettingsController : UIViewController< UITableViewDelegate, UITableViewDataSource > {
	IBOutlet UITableView *table_;
	NSMutableArray *dataArray;
	IBOutlet UINavigationController *navigationController;

}

@property(nonatomic, retain) UITableView *table_;
@property(nonatomic, retain) NSMutableArray *dataArray;

@end
