//
//  NowPlayingController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeKnob: NSObject
{
    IBOutlet  UIButton    *volumebutton_;
	UIImage               *image_;
	CGPoint                dragStart_;
    IBOutlet  UIView      *volumeview_;
    IBOutlet  UIImageView *volumeknobview_;
    CGPoint                center_;
    float                  radius_;
    float                  starttheta_;
    float                  volume_;
}

@property(readonly) UIView* volumeview_;
@property(readonly) float   volume_;

-(IBAction) initialize;
-(void) setKnobPosition:(float) theta;
-(void) setVolume:(float) theta;

@end


@interface NowPlayingController : UIViewController {
	IBOutlet UIToolbar       *toolbar_;
    IBOutlet UIToolbar       *toolbartop_;
	IBOutlet UIImageView     *albumcover_;
	IBOutlet UISlider        *volume_;
	IBOutlet UIView          *volumeviewslider_;

    IBOutlet UIButton *back_;
	IBOutlet UIBarButtonItem *prev_;
	IBOutlet UIBarButtonItem *pause_;
	IBOutlet UIBarButtonItem *stop_;
	IBOutlet UIBarButtonItem *play_;
	IBOutlet UIBarButtonItem *next_;
	IBOutlet UIBarButtonItem *flexbeg_;
	
	IBOutlet UIBarButtonItem *fixedprev_;
	IBOutlet UIBarButtonItem *fixedpause_;
	IBOutlet UIBarButtonItem *fixedplay_;
	IBOutlet UIBarButtonItem *flexend_;
	
	
	IBOutlet UIView          *trackinfo_;
    IBOutlet UILabel         *tlabel_;
    IBOutlet UILabel         *alabel_;
    IBOutlet UILabel         *allabel_;
    IBOutlet UIAlertView     *alert;
    IBOutlet UISlider        *progbar_;
    IBOutlet UISlider        *progbar2_;
	
    IBOutlet UINavigationBar *nav_;
	UIImageView              *busyimg_;
    VolumeKnob               *volumeknob_;
    
	// current track info
    NSDictionary             *dict_;
	
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

-(void) setupnavigationitems:(UINavigationItem *)sender navBar:(UINavigationBar *)navbar
                    datadict:(NSDictionary *)dict;

@end
