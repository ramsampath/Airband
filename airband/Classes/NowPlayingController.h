//
//  NowPlayingController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NowPlayingController : UIViewController {
	IBOutlet UIToolbar       *toolbar_;
	IBOutlet UIImageView     *albumcover_;
	IBOutlet UISlider        *volume_;

	IBOutlet UIBarButtonItem *prev_;
	IBOutlet UIBarButtonItem *pause_;
	IBOutlet UIBarButtonItem *play_;
	IBOutlet UIBarButtonItem *next_;
	
	IBOutlet UITextView      *trackinfo_;
    IBOutlet UIAlertView     *alert;
    IBOutlet UISlider        *progbar_;
	
	bool     paused_;
}

-(IBAction) setvolume:(id)sender;
-(IBAction) pause:(id)sender;
-(IBAction) stop:(id)sender;
-(IBAction) play:(id)sender;
-(IBAction) next:(id)sender;
-(IBAction) prev:(id)sender;

-(IBAction) random:(id)sender;
-(IBAction) taptap:(id)sender;

@end
