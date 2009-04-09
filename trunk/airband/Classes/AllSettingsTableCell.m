//
//  AllSettingsTableCell.m
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC. All rights reserved.
//

#import "AllSettingsTableCell.h"
#import "SettingsController.h"


@implementation AllSettingsTableCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.textAlignment = UITextAlignmentLeft;
    }
    return self;
}

-(void)setCellDataWithString:(NSString	*)labelString {
	self.text = labelString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    // Push the detail view controller	
    [super setSelected:selected animated:animated];


}


- (void)dealloc {
    [super dealloc];
}


@end
