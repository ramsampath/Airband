//
//  spinbutton.h
//  buttonmech
//
//  Created by Scot Shinderman on 4/12/09.
//  Copyright 2009 Imageworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Spinbutton : UIButton {
	CGPoint dragStart_;
	float angle;
}

@property (readonly) float angle;

@end
