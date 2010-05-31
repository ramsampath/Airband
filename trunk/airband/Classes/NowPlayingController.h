//
//  NowPlayingController.h
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TracklistView.h"
#import "LoadingView.h"
#import "FlowCoverView.h"
#import "SimpleIO.h"


@interface VolumeKnob: UIView
{
    //IBOutlet  UIButton    *volumebutton_;
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

//-(IBAction) initialize;
-(void) setKnobPosition:(float) theta;
-(float) getKnobAngle;
-(void) setVolume:(float) theta;

@end



@interface NowPlayingController: UIViewController <AsyncCallback, FlowCoverViewDelegate,
                 UITableViewDelegate, UITableViewDataSource> 

{
    IBOutlet UIToolbar       *toolbar_;
    IBOutlet UIToolbar       *toolbartop_;
    
    IBOutlet UIView              *albumcovertracksview_;   // album cover/track list view parent
    IBOutlet UIView              *albumcovertracksbview_;  // album cover/info button navigation button view parent
    IBOutlet UIButton            *albumcovertracksb_;      // the navigation bar's right button 
    
    IBOutlet UIImageView         *albumcoverview_;         // the view which holds the album cover
    IBOutlet UIImage             *infoimage_;              // the image which holds the info icon
    IBOutlet UIImage             *emptyalbumartworkimage_; // the image which holds the empty album cover 
    IBOutlet TracklistController *tracklistview_;         

    IBOutlet UISlider        *volume_;                     // unused at the moment
    IBOutlet UIView          *volumeviewslider_;           // ununsed at the moment

    IBOutlet UIButton        *back_;
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
	
    bool                      paused_;
    bool                      flipsideview_;
    
    // progress views
    UIView                   *progressView_;
    LoadingView              *loadingView_;
    
    //
    // The cover flow
    //
    
    UIView              *portraitView;
    UIView              *landscapeView;

    id       detailItem;
    UILabel *detailDescriptionLabel;
	
    UIButton *flickrButton;	
    UITextField *flickrSearch;
	
    FlowCoverView *flowCover;
	
    UIImageView    *imgView;

	
    NSMutableArray *searchList_;
    
    //
    int albumartdisplaycounter_;
}


-(IBAction) setvolume:(id)sender;
-(IBAction) pause:(id)sender;
-(IBAction) stop:(id)sender;
-(IBAction) play:(id)sender;
-(IBAction) next:(id)sender;
-(IBAction) prev:(id)sender;
-(IBAction) setArtwork:(UIImage *)artwork;

-(IBAction) random:(id)sender;
-(IBAction) taptap:(id)sender;
-(IBAction) flipToTracklistView:(id) sender;
-(void) displayPlayButton:(id) sender;
-(void) setupnavigationitems:(UINavigationItem *)sender navBar:(UINavigationBar *)navbar
                    datadict:(NSDictionary *)dict;
-(void) stopLoadingView;
-(void) detectOrientation;
-(void) transformViewToLandscape;


@property( readwrite, retain ) UIView *portraitView;
@property( readwrite, retain ) UIView *landscapeView;

//
//
//

@property (nonatomic, retain)          id             detailItem;
@property (nonatomic, retain) IBOutlet UILabel        *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton       *flickrButton;
@property (nonatomic, retain) IBOutlet UITextField    *flickrSearch;
@property (nonatomic, retain) IBOutlet FlowCoverView  *flowCover;
@property (nonatomic, retain) IBOutlet UIImageView    *imgView;
@property (nonatomic, readonly)        NSMutableArray *searchList_;
@property (readwrite)                  int albumartdisplaycounter_;



@end
