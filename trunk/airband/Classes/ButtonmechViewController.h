//
//  buttonmechViewController.h
//  buttonmech
//
//  Created by Scot Shinderman on 4/11/09.
//  Copyright Imageworks 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonmechViewController : UIViewController {
	IBOutlet  UIButton *volume_;
	UIImage *image_;
	CGPoint dragStart_;
}

@end

