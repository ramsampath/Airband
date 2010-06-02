//
//  AllSettingsTableCell.m
//  airband
//
//  Created by Ram Sampath on 3/26/09.
//  Copyright 2009 Centroid PIC/Elliptic All rights reserved.
//

#import "AllSettingsTableCell.h"
#import "SettingsController.h"


@implementation AllSettingsTableCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
#ifdef __IPHONE_3_0	
		self.textLabel.textAlignment = UITextAlignmentLeft;
#else
		self.textAlignment = UITextAlignmentLeft;
#endif
    }
    return self;
}

-(void)setCellDataWithString:(NSString	*)labelString {
#ifdef __IPHONE_3_0	
	self.textLabel.text = labelString;
#else
	self.text = labelString;
#endif
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    // Push the detail view controller	
    [super setSelected:selected animated:animated];


}


- (void)dealloc {
    [super dealloc];
}


@end
