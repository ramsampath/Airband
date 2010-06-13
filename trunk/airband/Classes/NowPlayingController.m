//
//  NowPlayingController.m
//  airband
//
//  Created by Scot Shinderman on 8/27/08.
//  Copyright 2008 Elliptic. All rights reserved.
//

#import <QuartzCore/CAAnimation.h>


#import "NowPlayingController.h"
#import "PlaylistTracksController.h"

#import "appdata.h"
#import "imgcache.h"
#import "AlbumInfo.h"

#import "SimpleIO.h"
#import "UIImageExtras.h"

static NSString *flickrRequestWithKeyword( NSString* keyword );
static NSMutableArray* convertListToRequests( NSData* data );


// IMAGE UTILITY FUNCTIONS
//

// MyCreateBitmapContext: Source based on Apple Sample Code
CGContextRef MyCreateBitmapContext( int pixelsWide, int pixelsHigh )
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate( bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, 
                                    colorSpace, kCGImageAlphaPremultipliedLast );
    if (context== NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );
    
    return context;
}



@implementation UINavigationBar (UINavigationBarCategory)

-(void)setBackgroundImage:(UIImage*)image
{
    if(image == NULL){ //might be called with NULL argument
        return;
    }
    UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
    [self addSubview:aTabBarBackground];
    [self sendSubviewToBack:aTabBarBackground];
    [aTabBarBackground release];
}
@end


@implementation VolumeKnob

@synthesize volumeview_;
@synthesize volume_;


- (id)init
{   
    self = [super initWithFrame:CGRectMake( 0, 300, 100, 100 )];
    
    self.userInteractionEnabled = TRUE;
    
    image_ = [[UIImage imageNamed:@"volume_knob_bigger.png"] retain];

    UIImageView *imageView = [ [ UIImageView alloc ] initWithImage: image_];

    imageView.frame = CGRectMake( 10, 17, self.frame.size.width - 10, self.frame.size.height - 10 );
    [self addSubview:imageView];

    center_.x   = 40 + 10;
    center_.y   = 40 + 17;
    radius_     = 35;
    starttheta_ = M_PI/4;

    volumeknobview_               = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"volume_indicator.png"]];

    float theta = [self getKnobAngle];
    [self setKnobPosition:theta];
    [self addSubview:volumeknobview_];
    
    UIImageView *vplus            = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"volume_plus.png"]];
    vplus.frame                   = CGRectMake( 95, 98, 8, 8 );
    [self addSubview:vplus];
    [vplus release];
    
    UIImageView *vmin             = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"volume_minus.png"]];
    vmin.frame                    = CGRectMake( 10, 100, 8, 4 );
    [self addSubview:vmin];
    [vmin release];
    
    [self addSubview:volumeview_];
    
    return self;
}

#define lerp(x, a, b) ((1-x)*a + x*b)
#define slerp(x, a, b) (sin((1-x)*(M_PI/2 + M_PI))*a + sin( x*(M_PI/2 + M_PI ))*b)

-(float) getKnobAngle
{
    AppData *app = [AppData get];
    float theta  = 0;
    //
    //
    float vol = lerp( [app lastVolume_], 0, M_PI+M_PI/2 );
    if( vol < starttheta_ ) {
        theta = starttheta_ + M_PI + vol;
    }
    else if( vol >= starttheta_ && vol < (M_PI + starttheta_ ) ) {
        theta = -( ( M_PI + starttheta_ - vol ) );
    }
    else if( vol >= (M_PI + starttheta_) ) {
        theta = vol - ( M_PI + starttheta_ );
    }
    
    
    return theta;
}


-(void) setKnobPosition:(float) theta
{
    float xpos = radius_ * cos( theta );
    float ypos = radius_ * sin( theta );
    
    //volumeknobview_.frame  = CGRectMake( 10.5, center_.y + 10, 10, 10 );

    //volumeknobview_
    volumeknobview_.frame = CGRectMake( xpos + center_.x, ypos + center_.y, 
                                        volumeknobview_.frame.size.width, 
                                        volumeknobview_.frame.size.height ); 
}


-(void) setVolume:(float) theta
{
    float value = 0;
    
     if( theta < 0 ) {
        theta = (-theta) + starttheta_;
    }
    else if( theta > 0 && theta <= starttheta_ ) {
        theta = starttheta_ - theta;
    }
    else {
        theta = 2*M_PI - theta  + starttheta_;
    }

    value = theta/(M_PI + 2 *starttheta_);
    value = 1 - value;
    [[AppData get] setvolume:value];
}


//- (void)volButtonDrag:(id)sender event:(id)event
-(void) touchesMoved :(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];   
    
    // [note] -- doing the calc in the parent coord system
    CGPoint currentTouchPosition = [touch locationInView:self];

    float cx = self.frame.size.width/2;
    float cy = self.frame.size.height/2;
    
    float theta1 = atan2( -(dragStart_.y-cy), dragStart_.x-cx );
    //float theta2 = atan2( -(currentTouchPosition.y-cy), currentTouchPosition.x-cx );
    
    float theta  = -theta1 ;

    dragStart_ = currentTouchPosition;

    if( ( theta > starttheta_ && theta < (M_PI - starttheta_) )|| 
       (  theta > 0 && theta < (M_PI - starttheta_) && theta > starttheta_ ) ) 
        return;
    
    
    [self setKnobPosition:theta];
    
    [self setVolume:theta];
    
    return;

}


//- (void)volButtonTapped:(id)sender event:(id)event
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];   
    CGPoint currentTouchPosition = [touch locationInView:self];
    dragStart_ = currentTouchPosition;
    
    return;
}


@end 
// end --- volume knob


@implementation NowPlayingController


@synthesize portraitView;
@synthesize landscapeView;
@synthesize detailItem, detailDescriptionLabel;
@synthesize flickrButton;
@synthesize flickrSearch;
@synthesize imgView;
@synthesize searchList_;
@synthesize albumartdisplaycounter_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Initialization code
    }

    return self;
}

-(id)init 
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = TRUE;
    }
    albumartdisplaycounter_ = 0;
    
    return self;
}



- (void)viewDidUnload 
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)loadView 
{
    UIView *mainview          = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 480)];
    mainview.alpha            = 1.000;
    mainview.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
                                UIViewAutoresizingFlexibleBottomMargin | 
                                UIViewAutoresizingFlexibleTopMargin;
    mainview.backgroundColor  = [UIColor colorWithRed:0.114 green:0.110 blue:0.090 alpha:1.000];
    mainview.clearsContextBeforeDrawing = YES;
    mainview.clipsToBounds              = NO;
    mainview.contentMode                = UIViewContentModeScaleToFill;
    mainview.hidden                     = NO;
    mainview.multipleTouchEnabled       = NO;
    mainview.opaque                     = YES;
    mainview.tag                        = 0;
    mainview.userInteractionEnabled     = YES;
    mainview.backgroundColor            = [UIColor 
                                           colorWithPatternImage:[UIImage 
                                           imageNamed:@"now_playing_background.png"]];

    //UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,640)];
    //UIImage *grad = [UIImage imageNamed:@"gradientBackground.png"];
    //image.image = grad;
    
    UIImage *stetchLeftTrack  = [[UIImage imageNamed:@"leftslide.png"]
                                stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stetchLeftTrack2 = [[UIImage imageNamed:@"yellowslide.png"]
                                stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"rightslide.png"]
                                 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stetchRightTrack2 = [[UIImage imageNamed:@"rightslide_transp.png"]
                                 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    
    progbar_ = [[UISlider alloc] initWithFrame:CGRectMake( 140.0, 305.0, 170.0, 8.0 )];
    progbar_.backgroundColor            = [UIColor clearColor];

    [progbar_ setThumbImage:nil forState:UIControlStateNormal];
    [progbar_ setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [progbar_ setMaximumTrackImage:stetchRightTrack2 forState:UIControlStateNormal];
    progbar_.alpha                      = 1.0;
    progbar_.clearsContextBeforeDrawing = YES;
    progbar_.clipsToBounds              = NO;
    progbar_.contentMode                = UIViewContentModeScaleToFill;
    progbar_.multipleTouchEnabled       = YES;
    progbar_.opaque                     = YES;
    progbar_.tag                        = 0;
    progbar_.userInteractionEnabled     = NO;
    progbar_.minimumValue               = 0.0;
    progbar_.maximumValue               = 1.0;
    progbar_.value                      = 0.000;

    progbar2_ = [[UISlider alloc] initWithFrame:CGRectMake( 140.0, 305.0, 170.0, 8.0 )];
    progbar2_.backgroundColor            = [UIColor clearColor];
    [progbar2_ setThumbImage:nil forState:UIControlStateNormal];
    [progbar2_ setMinimumTrackImage:stetchLeftTrack2 forState:UIControlStateNormal];
    [progbar2_ setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    progbar2_.alpha                      = 1.0;
    progbar2_.clearsContextBeforeDrawing = YES;
    progbar2_.clipsToBounds              = NO;
    progbar2_.contentMode                = UIViewContentModeScaleToFill;
    progbar2_.multipleTouchEnabled       = YES;
    progbar2_.opaque                     = YES;
    progbar2_.tag                        = 0;
    progbar2_.userInteractionEnabled     = NO;
    progbar2_.minimumValue               = 0.0;
    progbar2_.maximumValue               = 1.0;
    progbar2_.value                      = 0.000;   
    
    CGRect volframe = CGRectMake( 81.0, 305.0, 147.0, 23.0 );
    [self create_Custom_UISlider:volframe];
        
    UIImageView *btbg             = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_toolbar_background.png"]];
    btbg.frame                    = CGRectMake(0, 300, 320, 120);
    [mainview addSubview:btbg];
    [btbg release];

    volumeknob_ = [[VolumeKnob alloc] init];
    //[volumeknob_ initialize];
    //[mainview addSubview:volumeknob_.volumeview_];
    [mainview addSubview:volumeknob_];
    
    trackinfo_                     = [[UIView alloc] initWithFrame:CGRectMake( 140.0, 310.0, 170.0, 140.0 )];
    trackinfo_.backgroundColor     = [UIColor clearColor];
    
    alabel_                        =  [[UILabel alloc] 
                                      initWithFrame:CGRectMake(0 , 30 , 320 , 10)]; 
    alabel_.text                   = [dict_ objectForKey:@"artistName"];
    alabel_.font                   = [UIFont fontWithName:@"Arial" size:12.0];
    alabel_.textAlignment          = UITextAlignmentLeft;
    alabel_.backgroundColor        = [UIColor clearColor];
    alabel_.textColor              = [UIColor grayColor];
    [trackinfo_ addSubview: alabel_];
    
    allabel_                        =  [[UILabel alloc] 
                                       initWithFrame:CGRectMake(0 , 50 , 320 , 15)]; 
    allabel_.text                   = [dict_ objectForKey:@"albumTitle"];
    allabel_.font                   = [UIFont fontWithName:@"Arial" size:12.0];
    allabel_.textAlignment          = UITextAlignmentLeft;
    allabel_.backgroundColor        = [UIColor clearColor];
    allabel_.textColor              = [UIColor whiteColor];
    [trackinfo_ addSubview: allabel_];
    
    tlabel_                        =  [[UILabel alloc] 
                                      initWithFrame:CGRectMake(0 , 75 , 320 , 15)]; 
    tlabel_.text                   = [dict_ objectForKey:@"trackTitle"];
    tlabel_.font                   = [UIFont fontWithName:@"Arial" size:12.0];
    tlabel_.textAlignment          = UITextAlignmentLeft;
    tlabel_.backgroundColor        = [UIColor clearColor];
    tlabel_.textColor              = [UIColor grayColor];
    [trackinfo_ addSubview: tlabel_];
        
    //toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 382.0, 320.0, 44.0)];
    toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 300.0, 320.0, 100.0)];
    toolbar_.alpha = 1.000;
    //toolbar_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //toolbar_.barStyle = UIBarStyleBlackTranslucent;

    toolbar_.clearsContextBeforeDrawing = NO;
    toolbar_.clipsToBounds              = NO;
    toolbar_.contentMode            = UIViewContentModeBottom;
    toolbar_.hidden                 = NO;
    toolbar_.multipleTouchEnabled   = NO;
    toolbar_.opaque                 = NO;
    toolbar_.tag                    = 0;
    toolbar_.userInteractionEnabled = YES;
    toolbar_.backgroundColor = [UIColor clearColor];

    back_ = [UIButton alloc];
    back_.enabled = YES;
    back_.tag     = 0;

    albumcovertracksview_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 300.0)];
    albumcoverview_ = [[UIImageView alloc] initWithFrame:albumcovertracksview_.frame];
    albumcoverview_.alpha                      = 1.000;
    //albumcoverview_.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    albumcoverview_.clearsContextBeforeDrawing = NO;
    albumcoverview_.clipsToBounds              = NO;
    //albumcoverview_.contentMode                = UIViewContentModeScaleAspectFill;
    albumcoverview_.hidden                     = NO;
    albumcoverview_.image                      = nil;
    albumcoverview_.multipleTouchEnabled       = NO;
    albumcoverview_.opaque                     = NO;
    albumcoverview_.tag                        = 0;
    albumcoverview_.userInteractionEnabled     = NO;
    
    [albumcovertracksview_ addSubview:albumcoverview_];

    
    busyimg_ = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    busyimg_.image = [UIImage imageNamed:@"busySpinner.png"];
    busyimg_.opaque  = NO;
    busyimg_.alpha = 0;
    busyimg_.hidden = NO;
    
    AppData *app = [AppData get];
    if( !app ) return;
    
    [volume_ setValue:[app lastVolume_]];
    
    CGRect r = CGRectMake( albumcoverview_.frame.origin.x, albumcoverview_.frame.origin.y, 
                           albumcoverview_.frame.size.width, albumcoverview_.frame.size.height );
    tracklistview_ = [[TracklistController alloc] initWithFrame:r];
    tracklistview_.dataSource = self;
    tracklistview_.delegate   = self;

    [mainview addSubview:albumcovertracksview_];
    [mainview addSubview:progbar2_];
    [mainview addSubview:progbar_];
    [mainview addSubview:trackinfo_];
    [mainview addSubview:busyimg_];

    emptyalbumartworkimage_ = [UIImage imageNamed:@"empty_album_art.png"];

    CGRect fframe = CGRectMake( 0, 0, 480, 320 );

    afFlowCover = [[AFOpenFlowView alloc] initWithFrame:fframe];
    afFlowCover.frame = fframe;
    
    //self.landscapeView = flowCover;
    
    afFlowCover.viewDelegate  = self;
    afFlowCover.dataSource    = self;
    self.landscapeView        = afFlowCover;
     
    //[self transformViewToLandscape];
    [afFlowCover setUpInitialState];
  
    self.view         = mainview;
    self.portraitView = mainview;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(detectOrientation) 
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];

    //
    //
    flipsideview_ = true;
     // hacky -- let's listen for errors
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(connectionError:) 
                                                 name:@"connectionError"
                                               object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(connectionFailed:) 
                                                 name:@"connectionFailed"
                                               object:nil];
}

- (void)viewDidLoad 
{
    AppData *app = [AppData get];
    
    [volume_ setValue:[app lastVolume_]];
    
    // setup timer.
    if( 1 ) {
        [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.5 
                                         target:self 
                                       selector:@selector(myTimerFireMethod:)
                                       userInfo:NULL repeats:YES ];
    }   
    
    // 
    // setup play/pause notifications to change the buttons appropriately
    //
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(displayPauseButton:) 
                                                 name:@"appPlaying" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(displayPlayButton:) 
                                                 name:@"appPaused" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(displayPauseButton:) 
                                                 name:@"appResumed" 
                                               object:nil];
}





/*
 flip the displayed view from the main view to the flipside(song list) view and vice-versa.
 */

- (void) toggleView 
{
}


-(IBAction) flipToTracklistView:(id) sender
{
    AppData *app = [AppData get];
    
    //
    // Animate the artwork to track list
    //
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    
    [UIView setAnimationTransition:([self.view superview] ? 
                                    UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) 
                           forView:albumcovertracksview_ cache:YES];
    
    
    if ([tracklistview_ superview])
    {
        [tracklistview_ removeFromSuperview];
        [albumcovertracksview_ addSubview:albumcoverview_];
        flipsideview_ = true;
    }
    else
    {
        [albumcoverview_ removeFromSuperview];
        [albumcovertracksview_ addSubview:tracklistview_];
        flipsideview_ = false;
    }
    
    
    [UIView commitAnimations];  
    
    // 
    // Animate the navigation button to the opposite of the artwork animation
    //
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    
    
    [UIView setAnimationTransition:([self.view superview] ? 
                                    UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) 
                           forView:albumcovertracksbview_ cache:YES];
    
    if( flipsideview_ == true ) {
        [albumcovertracksb_ addTarget:self action:@selector(flipToTracklistView:) 
                     forControlEvents:UIControlEventTouchUpInside];
        [albumcovertracksb_ setBackgroundImage:infoimage_ forState:UIControlStateNormal];
        
        [albumcovertracksb_ addTarget:self action:@selector(flipToTracklistView:) 
                     forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        UIImage *image = app.artwork_;
        if( image == nil )
            image = emptyalbumartworkimage_;
        [albumcovertracksb_ setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    [UIView commitAnimations];  
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(artworkReady:) 
                                                 name:@"artworkReady" 
                                               object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(titleAvailable:) 
                                                 name:@"titleAvailable" 
                                               object:nil]; 
	
    albumartchangetimer_ =  [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)7
                                                             target:self 
                                                           selector:@selector(albumArtChange:)
                                                           userInfo:NULL repeats:YES ];
    
    UIImage *backimage    = [UIImage imageNamed:@"back_arrow.png"];
    UIBarButtonItem *b = [[[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)] autorelease];
    self.navigationItem.leftBarButtonItem  = b;
    
    self.navigationItem.hidesBackButton = TRUE;
    AppData *app = [AppData get];
    
    if( [app isPaused] )
        [toolbartop_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_,
                               play_,  fixedplay_, next_, flexend_, nil]];
    else {
        [toolbartop_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_,
                               pause_,  fixedplay_, next_, flexend_, nil]];
    }
    
    albumartdisplaycounter_ = 0;
    
    
    tlabel_.text  = app.currentTrackTitle_;
    alabel_.text  = app.currentArtist_;
    allabel_.text = app.currentAlbum_;

    [self setArtwork:app.artwork_ animated:NO];
    //
    // Restore the titles
    //
    [self titleAvailable:nil];
}


- (void) viewDidDisappear:(BOOL)animated
{
    AppData *app = [AppData get];
    
    tlabel_.text  = app.currentTrackTitle_;
    alabel_.text  = app.currentArtist_;
    allabel_.text = app.currentAlbum_;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [albumartchangetimer_ invalidate];
}


-(void) transformViewToLandscape
{
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];


    // unknown, portrait, portrait u/d, landscape L, landscape R
    CGAffineTransform  transform = CGAffineTransformMakeRotation(M_PI/2);
    
    NSInteger rotationDirection;
    
    if( currentOrientation == UIDeviceOrientationLandscapeLeft ){
        rotationDirection = 1;
    } else {
        rotationDirection = -1;
    }
    
    CGRect myFrame = CGRectMake( 0, 0, 480, 320 );
     [self.landscapeView setFrame: myFrame];
    CGPoint center = CGPointMake(myFrame.size.height/2.0, myFrame.size.width/2.0);
    //CGPoint center = CGPointMake(0,320);

    [self.landscapeView setCenter: center];
    [self.landscapeView setTransform: transform];
    [self.landscapeView setBounds:myFrame];
}


- (void)albumArtChange:(NSTimer *)theTimer
{
    AppData *app = [AppData get];
    
    NSInteger n = [app.albumartimages_ count];
    if( albumartdisplaycounter_ > [app.albumartimages_ count] - 1 )
        albumartdisplaycounter_ /= [app.albumartimages_ count];

    if( flipsideview_ && n ) {

		/* there is nothing animating here yet... */
     
        if( [app.albumartimages_ count] != 0 ) {
            UIImage *image = [app.albumartimages_ objectAtIndex:albumartdisplaycounter_];
            albumcoverview_.image = image;
            [imgView setImage:image];
        }
        [UIView setAnimationDelegate:self];        
		 
        UIImage *image = [app.albumartimages_ objectAtIndex:albumartdisplaycounter_];
        albumcoverview_.image = image;
        [imgView setImage:image];
               
        albumartdisplaycounter_ = (albumartdisplaycounter_+1) % n;
    } else {
		albumartdisplaycounter_ = 0;
	}	
}

- (void)resetArtwork
{
    albumcoverview_.image = emptyalbumartworkimage_;
    AppData *app          = [AppData get];
    app.artwork_          = emptyalbumartworkimage_;
    [app.albumartimages_ removeAllObjects];
}


- (void)setArtwork:(UIImage *)image animated:(BOOL)animated
{
    albumartdisplaycounter_ = 0;
    AppData *app = [AppData get];
    
    //NSLog( @"Setting Artwork for %s\n", [allabel_.text UTF8String]);
    if( allabel_.text == nil ) return;
    
    @synchronized( self ) {
        // 
        // Save the album art to history
        //
        AlbumInfo *ainfo = [app.albumHistory_ objectForKey:allabel_.text];
        if( ainfo == nil ) {
            ainfo = [[AlbumInfo alloc] init];
            if( image ) {
                CGImageRef cgImage = [image CGImage];
                CGImageRef ncgImage = CGImageCreateCopy(cgImage);
                // Make a new image from the CG Reference
                UIImage *cimg = [[UIImage alloc] initWithCGImage:ncgImage];
                UIImage *img  = [cimg rescaleImageToSize:CGSizeMake(255, 255)];
                ainfo.art     = img;
                
            }
            else {
                UIImage *img = [emptyalbumartworkimage_ rescaleImageToSize:CGSizeMake(255, 255)];
                ainfo.art    = img;
            }
            ainfo.artistName = [dict_ objectForKey:@"artistName"];
            ainfo.albumIdReq = [dict_ objectForKey:@"albumId"];
            ainfo.index      = [app.albumHistory_ count];
            [app.albumHistory_ setValue:ainfo forKey:allabel_.text];
            [ainfo release];
        }
        else {
            if( image ) {
                CGImageRef cgImage = [image CGImage];
                CGImageRef ncgImage = CGImageCreateCopy(cgImage);
                UIImage *cimg = [[UIImage alloc] initWithCGImage:ncgImage];
                UIImage *img  = [cimg rescaleImageToSize:CGSizeMake(255, 255)];
                ainfo.art        = img;
            }
        }
        
        // 
        // Update the landscape view
        //
        [afFlowCover setNumberOfImages:[app.albumHistory_ count]];
        [afFlowCover forceUpdateCoverImage:[afFlowCover coverForIndex:ainfo.index]];
        [afFlowCover setSelectedCover:ainfo.index];
        [afFlowCover centerOnSelectedCover:YES];
        
        //
        // Now update the portrait view
        //
        if( image ) {
            //
            // Add to the list of albums played so far
            //
            
            // 
            // if viewing the album art at the moment transition the album art to the new artwork
            //
            if( flipsideview_ == true ) {
                if( animated ) {
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:albumcovertracksview_ cache:YES];
                }
            }
            albumcoverview_.image = image;
            if( flipsideview_ == true ) {
                if( animated )
                    [UIView commitAnimations];
            }
            
            // 
            // if viewing the track list at the moment transition the navigation button's album artwork to the new one
            //
            if( flipsideview_ == false ) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:1];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                                       forView:albumcovertracksbview_ cache:YES];
                [albumcovertracksb_ setBackgroundImage:image forState:UIControlStateNormal];
                [UIView commitAnimations];
            }
            //
            // if the cover flow display type is album art add this
            // album art
            //
            [app.albumartimages_ removeAllObjects];
            [imgView setImage:ainfo.art];
        } else {
            [self resetArtwork];
        }
    }
}


- (void)artworkReady:(NSObject*)notification
{
    AppData *app = [AppData get];
    UIImage *img = app.artwork_;
    
    //
    // save the artwork in the image cache
    //
    //[app.albumArtCache_.cache_ setObject:img forKey:app.currentAlbum_];
 
    tlabel_.text  = app.currentTrackTitle_;
    alabel_.text  = app.currentArtist_;
    allabel_.text = app.currentAlbum_;

    [self setArtwork:img animated:YES];
}



- (void) trackListReady:(id)object
{           
    [self stopLoadingView];
    
    AppData *app = [AppData get];
    int num = [app.trackList_ count];
    if( !num ) {
        return;
    }

    [app setCurrentTrackIndex_:0];

    NSDictionary *d = [app.trackList_ objectAtIndex:0];
    [app playTrack:d];
    
    //[self setArtwork:app.artwork_ animated:NO];
}

-(void) stopLoadingView
{
    //
    // Remove the loadingView which should remove the progressView_ as well
    //
    [loadingView_ removeView];
    //
    // So we can comfortably set to nil
    //
    progressView_ = nil;
    //
    // set it to nil 
    //
    loadingView_ = nil;
}


- (void) playListTracksReady:(id)object
{           
    [self stopLoadingView];
    
    AppData *app = [AppData get];
    int num = [app.currentTracklist_ count];
    if( !num ) {
        return;
    }
    
    [app setCurrentTrackIndex_:0];
    NSDictionary *d = [app.currentTracklist_ objectAtIndex:0];

    [app playTrack:d];
}

-(void) connectionFailed:(id)object
{
    [self stopLoadingView];
    
    [self displayPlayButton:nil];
    //
    // remove myself as next time another observer will be created.
    //
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(connectionFailed:) 
                                                 name:@"connectionFAIL"
                                               object:nil];
}


-(void) connectionError:(id)object
{
    if ([object isKindOfClass:[NSURLResponse class]])
    { 
        // [todo] -- something fancier?
        //[[AppData get] stop]; 
    }
    
    [self stopLoadingView];

    [self next:nil];
    
    [self displayPlayButton:nil];
    [[[UIAlertView alloc] initWithTitle:@"Airband" 
                                message:@"Problem w/ track, skipping..."
                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];   
}







- (void)nextTrack
{
    AppData *app = [AppData get];
    
    int index = [app currentTrackIndex_];
    if( ++index >= ([app.trackList_ count]) ) 
        index = 0;
    
    [app setCurrentTrackIndex_:index];
    NSDictionary *d = [app.trackList_ objectAtIndex:index];

    [tracklistview_ reloadData];
    [tracklistview_ scrollToTrack:index];
    
    [app playTrack:d];
}


- (void)prevTrack
{
    AppData *app = [AppData get];
    
    int index = [app currentTrackIndex_];
    if( --index <  0) 
        index = [app.trackList_ count] - 1;
    
    [app setCurrentTrackIndex_:index];
    NSDictionary *d = [app.trackList_ objectAtIndex:index];
    
    [tracklistview_ reloadData];
    [tracklistview_ scrollToTrack:index];

    [app playTrack:d];
}


- (void)myTimerFireMethod:(NSTimer*)theTimer
{
    AppData *app = [AppData get];

    if( [app isrunning] ) {
        float cur = [app percent];
        float len = [app tracklength];

        
        if( cur >= len ) {          
            if ([app hasfinished]) {
                [progbar_ setValue:0.0 animated:YES];
                [self nextTrack];               
            }
        }
        else {
            float per = cur/len;
            [progbar_ setValue:per animated:YES];
        }
    
        float approxBitRateMult = 4.0;
        float a = approxBitRateMult * [app trackFileSize] / app.currentTrackFileSize_;
        //albumcoverview_.alpha = a;
        //[progbar2_ setProgress:a];
        progbar2_.value = a;
    }
}


- (void) getReadyForArtwork
{
    AppData *app = [AppData get];

    if( app.coverflowDisplayType_ == 1 ) {
        NSString *search = [NSString stringWithString:app.currentAlbum_];
        if( search != nil ) {
            albumartdisplaycounter_ = 0;
            NSString *req = flickrRequestWithKeyword( search );
            ConnectionInfo *info = [[ConnectionInfo alloc] init];
            info.address_ = req;
            info.delegate_ = self;
            info.userdata_ = @"main";
            
            [[SimpleIO singelton] request:info];    
            [info release];
        }
    }	
}


- (void) titleAvailable:(NSNotification*)notification
{
    [self getReadyForArtwork];	

    if( notification == nil ) return;

    NSDictionary *d     = notification.userInfo;
    NSString *title     = [d objectForKey:@"trackTitle"];
    NSString *artist    = [d objectForKey:@"artistName"];
    NSString *album     = [d objectForKey:@"albumTitle"];

    tlabel_.text  = title;
    alabel_.text  = artist;
    allabel_.text = album;
    

}




-(IBAction) setvolume:(id)sender
{   
    [[AppData get] setvolume:[volume_ value]];
}


-(IBAction) random:(id)sender
{
    AppData *app = [AppData get];
    NSArray* fullList = app.fullArtistList_;
    int index = drand48() * [fullList count];
    
    NSDictionary *d = [fullList objectAtIndex:index];
    //trackinfo_.text = [d objectForKey:@"albumTitle"];
    
    [app play:d];
}
    

-(IBAction) taptap:(id)sender
{
}


-(IBAction) play:(id)sender
{
    AppData *app = [AppData get];

    if( [app isPaused] ) {
        [app resume];
    }
    else {
        int index = [app currentTrackIndex_];
        NSDictionary *d = [app.trackList_ objectAtIndex:index];
        [app playTrack:d];
    }
}


-(IBAction) next:(id)sender
{
    [self nextTrack];
}


-(IBAction) prev:(id)sender
{
    [self prevTrack];
}



- (void) displayPlayButton:(id) sender
{
    [toolbartop_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_,
                           play_,  fixedplay_, next_, flexend_, nil]];
}


- (void) displayPauseButton:(id) sender
{
    [toolbartop_ setItems:[NSArray arrayWithObjects:flexbeg_, prev_, fixedprev_,
                           pause_,  fixedplay_, next_, flexend_, nil]];
}


-(IBAction) pause:(id)sender
{
    paused_ = true;

    [[AppData get] pause];
}

-(IBAction) stop:(id)sender
{
    paused_ = false;
    [[AppData get] stop];
}



-(void) detectOrientation 
{    
    [self performSelector:@selector(updateLandscapeView) withObject:nil afterDelay:0];
}

- (void)updateLandscapeView
{
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.view = self.landscapeView;
        
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.view = self.portraitView;        
    }   
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.view = portraitView;
    }
    else if(self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view = portraitView;
    }
    else {
        self.view = landscapeView;
    }
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark UISlider (Custom)

- (void)create_Custom_UISlider:(CGRect)frame
{
    volume_ = [[UISlider alloc] initWithFrame:frame];
    [volume_ addTarget:self action:@selector(setvolume:) forControlEvents:UIControlEventValueChanged];
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    volume_.backgroundColor = [UIColor clearColor]; 
    
    [volume_ setThumbImage: [UIImage imageNamed:@"slider_ball_bw.png"] forState:UIControlStateNormal];
    
    volume_.minimumValue               = 0.0;
    volume_.maximumValue               = 1.0;
    volume_.continuous                 = YES;
    volume_.value                      = 1.0;
    volume_.alpha                      = 1.000;
    volume_.autoresizingMask           = UIViewAutoresizingFlexibleRightMargin | 
    UIViewAutoresizingFlexibleBottomMargin;
    volume_.clearsContextBeforeDrawing = YES;
    volume_.clipsToBounds              = YES;
    
    
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"leftslide.png"]
                                stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"rightslide.png"]
                                 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    //    [customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
    [volume_ setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [volume_ setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    [volume_ setMinimumValueImage:[UIImage imageNamed:@"SpeakerSoft.tif"]];
    [volume_ setMaximumValueImage:[UIImage imageNamed:@"SpeakerLoud.tif"]];
    
}

- (void)backAction:(id)sender 
{
    SimpleIO *io = [SimpleIO singelton];
    
    [io cancelAll];
    [self.navigationController popViewControllerAnimated:YES]; 
}

-(void) setupnavigationitems:(UINavigationItem *) ni 
                      navBar:(UINavigationBar *) navBar
                    datadict:(NSDictionary *)dict
{
    /*
     UIImage *backimage    = [UIImage imageNamed:@"back_arrow.png"];
     
     UIBarButtonItem *b = [[[UIBarButtonItem alloc] initWithImage:backimage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)] autorelease];
     ni.hidesBackButton = YES;
     ni.leftBarButtonItem  = b;
     */
    
    infoimage_            = [UIImage imageNamed:@"track_info_withbg.png"];
    
    albumcovertracksbview_             = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 32)] retain];
    albumcovertracksb_                 = [[[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 35, 32 )] retain];
    albumcovertracksb_.backgroundColor = [UIColor clearColor];
    
    navBar.barStyle                    = UIBarStyleBlackOpaque;
    
    [albumcovertracksb_ addTarget:self action:@selector(flipToTracklistView:) forControlEvents:UIControlEventTouchUpInside];
    [albumcovertracksb_ setBackgroundImage:infoimage_ forState:UIControlStateNormal];
    [albumcovertracksbview_ addSubview:albumcovertracksb_];
    
    
    UIBarButtonItem *b                      = [[UIBarButtonItem alloc] initWithCustomView:albumcovertracksbview_];
    [self.navigationItem setRightBarButtonItem:b];
    [b release];
    
    toolbartop_ = [[UIToolbar alloc] initWithFrame:CGRectMake( 0.0, 0.0, 0.0, 0.0 )];
    toolbartop_.opaque                 = NO;
    toolbartop_.barStyle               = UIBarStyleBlackOpaque;
    //toolbartop_.backgroundColor        = [UIColor clearColor];
    //[navBar addSubview:toolbartop_];
    
    self.navigationItem.titleView       = toolbartop_;
    self.navigationItem.titleView.frame = CGRectMake( 0, 0, 320, 40 );
    
    pause_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause 
                                                           target:self action:@selector(pause:)];
    pause_.enabled = YES;
    pause_.style   = UIBarButtonItemStylePlain;
    pause_.tag     = 0;
    pause_.width   = 0.000;
    
    flexbeg_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                             target:nil action:nil];
    flexbeg_.enabled = YES;
    flexbeg_.style   = UIBarButtonItemStylePlain;
    flexbeg_.tag     = 0;
    flexbeg_.width   = 0.000;
    
    prev_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind 
                                                          target:self   action:@selector(prev:)];
    prev_.enabled = YES;
    prev_.style   = UIBarButtonItemStylePlain;
    prev_.tag     = 0;
    prev_.width   = 0.000;
    
    fixedprev_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                               target:nil action:nil];
    fixedprev_.enabled = YES;
    fixedprev_.style   = UIBarButtonItemStylePlain;
    fixedprev_.tag     = 0;
    fixedprev_.width   = 30.000;
    
    stop_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                          target:self action:@selector(stop:)];
    stop_.enabled = YES;
    stop_.style   = UIBarButtonItemStylePlain;
    stop_.tag     = 0;
    stop_.width   = 0.000;
    
    pause_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause 
                                                           target:self action:@selector(pause:)];
    pause_.enabled = YES;
    pause_.style   = UIBarButtonItemStylePlain;
    pause_.tag     = 0;
    pause_.width   = 0.000;
    
    fixedpause_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                target:nil action:nil];
    fixedpause_.enabled = YES;
    fixedpause_.style   = UIBarButtonItemStylePlain;
    fixedpause_.tag     = 0;
    fixedpause_.width   = 30.000;
    
    play_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                          target:self action:@selector(play:)];
    play_.enabled = YES;
    play_.style   = UIBarButtonItemStylePlain;
    play_.tag     = 0;
    play_.width   = 0.000;
    
    
    fixedplay_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedplay_.enabled = YES;
    fixedplay_.style   = UIBarButtonItemStylePlain;
    fixedplay_.tag     = 0;
    fixedplay_.width   = 30.000;
    
    next_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward 
                                                          target:self action:@selector(next:)];
    next_.enabled = YES;
    next_.style   = UIBarButtonItemStylePlain;
    next_.tag     = 0;
    next_.width   = 0.000;
    
    flexend_         = [[UIBarButtonItem alloc] 
                        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                        target:nil action:nil];
    flexend_.enabled = YES;
    flexend_.style   = UIBarButtonItemStylePlain;
    flexend_.tag     = 0;
    flexend_.width   = 0.000;
    
    [toolbartop_ setItems:[NSArray arrayWithObjects: flexbeg_, prev_, fixedprev_, 
                           play_,  fixedplay_, next_, flexend_, nil]];
    if( dict ) {
        dict_ = dict;
        
        AppData *app = [AppData get];
        //
        // view loaded, queue up tracklist.
        //
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(trackListReady:) 
                                                     name:@"trackListReady"
                                                   object:nil]; 
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(playListTracksReady:) 
                                                     name:@"playListTracksReady"
                                                   object:nil]; 
        
        NSString *req = [dict_ objectForKey:@"albumId"];
        NSString *playlistid = [dict objectForKey:@"playlistId"];
        
        if( playlistid ) {
            NSString *enc = [playlistid stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            [app getPlayListTracksAsync:enc];
        }
        else {
            [app getTrackListAsync:req];
        }
        
        //
        // setup the progress view
        //
        if( progressView_ ) {
            [progressView_ removeFromSuperview];
            [progressView_ release];
            progressView_ = nil;
        }
        
        progressView_                 = [[[UILabel alloc] initWithFrame:CGRectMake( 30, 100, 250, 100)] retain];
        progressView_.backgroundColor = [UIColor clearColor];
        progressView_.alpha           = 1.0;
        [self.view addSubview:progressView_];
        [progressView_ release];
        
        if( loadingView_ ) [loadingView_ release];
        loadingView_ = nil;
        
        loadingView_ = [[LoadingView loadingViewInView:progressView_ loadingText:@"Loading Track List..."] retain]; 
    }
}

#pragma mark -
#pragma mark Table View delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    tracklistview_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    AppData *app = [AppData get];
    return [app.trackList_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return( [tracklistview_ cellForRowAtIndexPath:indexPath] );
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    AppData *app = [AppData get];
    
    [app setCurrentTrackIndex_:[indexPath row]];
    [tracklistview_ didSelectRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark Async Delegate



-(void) didFailWithError:(NSError*)err  userData:(id)user 
{
}

-(BOOL) someData:(NSData*)data          userData:(id)user 
{
    return FALSE;
}

//
// helper for image data
//
static void myProviderReleaseData (void *info,const void *data,size_t size)
{
    NSData *d = info;
    [d release];
}


-(void) finishedWithData:(NSData*)data  userData:(id)user 
{
    AppData *app = [AppData get];
    SimpleIO *io = [SimpleIO singelton];
	
    @synchronized( self ) {
        NSString *str = user;
        
        if ([str compare:@"main"] == NSOrderedSame) {
            NSMutableArray *result = convertListToRequests( data );
            if (result) {
                NSString *s;
                for  (s in result) {
                    ConnectionInfo *info = [[ConnectionInfo alloc] init];
                    info.address_ = s;
                    info.delegate_ = self;
                    info.userdata_ = @"picture";   // +s
                    [io request:info];    
                    [info release];
                }
            }
        }
        else {
            NSData *d = [[NSData dataWithData:data] retain];
            CGDataProviderRef provider = CGDataProviderCreateWithData( d, [d bytes],[d length], 
                                                                      myProviderReleaseData );
            CGImageRef imageref = CGImageCreateWithJPEGDataProvider( provider, NULL, true, kCGRenderingIntentDefault );
            if( !imageref ) {
                return;      
            }
            
            CGImageRetain( imageref );
            UIImage *img = [UIImage imageWithCGImage:imageref];
            CGDataProviderRelease( provider );        
            
            CGImageRelease( imageref );
            [app.albumartimages_ addObject:img];
        }
    }
}




#pragma mark -
#pragma mark Cover flow delegates

- (UIImage *)defaultImage 
{
    defaultCoverFlowImage_ = [emptyalbumartworkimage_ cropCenterAndScaleImageToSize:CGSizeMake(255, 255)];
	return defaultCoverFlowImage_;
}

-(void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index 
{
    AppData *app = [AppData get];
    
	if( index >= [app.albumHistory_ count] ) {
        [(AFOpenFlowView *)self.landscapeView setImage:emptyalbumartworkimage_ forIndex:index];
        return;
	}
    
    NSArray *keys = [app.albumHistory_ allKeys];
	// values in foreach loop
	for( NSString *key in keys ) {
        AlbumInfo *i = [app.albumHistory_ objectForKey:key];
        if( i ) {
            if( i.index == index ) {
                [(AFOpenFlowView *)self.landscapeView setImageAndText:i.art
                                                           albumLabel:key
                                                          artistLabel:i.artistName
                                                             forIndex:i.index];
                //[(AFOpenFlowView *)self.landscapeView setImage:i.art forIndex:i.index];
                return;
            }
        }
    }
    [(AFOpenFlowView *)self.landscapeView setImage:emptyalbumartworkimage_ forIndex:index];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index 
{
    AppData *app = [AppData get];
    NSArray *keys = [app.albumHistory_ allKeys];
	// values in foreach loop
	for( NSString *key in keys ) {
        AlbumInfo *i = [app.albumHistory_ objectForKey:key];
        if( i ) {
            if( i.index == index ) {
                NSString *req = i.albumIdReq;
                [app getTrackListAsync:req];
            }
        }
    }
    
}

#pragma end


@end


#pragma mark -

// --------------------------------------------------------------------------------
// helper code for flickr
// --------------------------------------------------------------------------------


@interface FlickrXMLPictDelegate : NSObject {
    NSMutableArray *picts_;
}

@property (readonly) NSMutableArray * picts_;
@end


@implementation FlickrXMLPictDelegate
@synthesize picts_;

- (id) init {
    
    if (self = [super init]) {
        picts_ = [[NSMutableArray arrayWithCapacity:100] retain];
    }
    
    return self;
}

- (void) dealloc {
    [picts_ release];
    [super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict 
{        
    if ([elementName isEqualToString:@"photo"]) 
    {    
        [picts_ addObject:attributeDict];    
    }
}
@end



// --------------------------------------------------------------------------------
// helper functions for flickr requests.
// --------------------------------------------------------------------------------
static NSMutableString* apiPrefix(NSString* method)
{	
    NSMutableString *prefix = [[[NSMutableString alloc] init] autorelease];
    [prefix appendString:@"http://api.flickr.com/services/rest/?method="];
    [prefix appendString:method];
    //[prefix appendString:@"&api_key=30b5b38adcaa90ff3db93e87d2e40fae"];	
    [prefix appendString:@"&api_key=1fcef533bbef1c9136ce74b00fff8af2"];
    return prefix;
}


NSString *flickrRequestWithKeyword(NSString* keyword)
{
    AppData *app = [AppData get];

    [app.albumartimages_ removeAllObjects];
    NSMutableString *keyurl = apiPrefix(@"flickr.photos.search");
    [keyurl appendString:@"&per_page=20&text="];
    [keyurl appendString:keyword];  
    NSString *encoded = [keyurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encoded;
}

/* --------------------------------------------------------------------------------
 Each <item> in the has these elements:
 <photo id="2332251417" owner="8846275@N05" secret="3dc5ca2086" 
 server="3227" farm="4" title="feh" ispublic="1" isfriend="0" isfamily="0" />
 
 http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
 ---------------------------------------------------------------------------------- */
NSMutableArray* convertListToRequests( NSData* data )
{
    if( !data )
        return nil;
	
    NSMutableArray *reqs = [NSMutableArray arrayWithCapacity:500];
    
    FlickrXMLPictDelegate * parseDelegate = [[[FlickrXMLPictDelegate alloc] init] autorelease];
    NSXMLParser * parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    [parser setDelegate:parseDelegate];
    if ([parser parse]) {
        NSDictionary * dict;				
        for (dict in parseDelegate.picts_) 
        {			
            NSString *farm   = [dict objectForKey:@"farm"];
            NSString *server = [dict objectForKey:@"server"];
            NSString *userid = [dict objectForKey:@"id"];
            NSString *secret = [dict objectForKey:@"secret"];
            
            if( farm && server && userid && secret )
            {
                NSString *pictureReq = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", 
                                        farm, server, userid, secret ];
                
                [reqs addObject:pictureReq];
            }
        }
    }
	
    return reqs;
}












