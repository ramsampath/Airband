//
//  PlaylistTracksController.h
//  airband
//
//  Created by Ram Sampath on 5/22/09.
//  Copyright 2009 Centroid PIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface AlbumlistController: UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate> {
	IBOutlet  UITableView *table_;
    
    NSMutableArray *albumList_;
    NSMutableArray *albumDisplayList_[27];
    NSMutableArray *albumActiveSections_;
    unsigned        nAlbumActiveSessions_;
    NSMutableArray *albumSectionTitles_;
    
    NSMutableArray *savedAlbumList_;    // the saved content in case the user cancels a search

    
	// used to display particular album tracks
    UIImage               *sectionBGImage_;
	IBOutlet UISearchBar  *searchfield_;     
    
    IBOutlet UIBarButtonItem    *azsortbutton_;
    IBOutlet UIBarButtonItem    *shufflebutton_;
    IBOutlet UISegmentedControl *albumOrgControl_;
    
    UIActivityIndicatorView	    *activity_;	
	BOOL                         searchActive_;
    
    NSArray                     *fullAlbumList_;

    LoadingView                 *loadingView_;
}

@property (nonatomic, retain) UITableView* table_;
@property (nonatomic, retain) UISearchBar *searchfield_;


-(IBAction) shuffle;
-(IBAction) reload;
-(IBAction) search;
-(IBAction) random;
//-(IBAction) textfieldchanged:(id)sender;
-(void) play:(int)index;

- (void) nowPlaying:(id) sender;

@end
