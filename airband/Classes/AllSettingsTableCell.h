//
//  AllSettingsTableCell.h
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllSettingsTableCell : UITableViewCell {
	IBOutlet UILabel *label;
}

-(void) setCellDataWithString:(NSString	*)labelstring;

@end
