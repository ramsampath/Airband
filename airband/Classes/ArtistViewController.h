#import <UIKit/UIKit.h>
#import "xmlhelp.h"
#import "songview.h"



@interface ArtistViewController : 
	UIViewController< UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate >
{
	NSMutableArray *artistList_;
    NSMutableArray *artistDisplayList_[27];
    NSMutableArray *artistActiveSections_;
    unsigned        nArtistActiveSessions_;
    NSMutableArray *artistSectionTitles_;
    UIImage        *sectionBGImage_;
    
	NSMutableArray *savedArtistList_;    // the saved content in case the user cancels a search

	IBOutlet UITableView      *artistTable_;  
	IBOutlet UIButton         *shuffle_;
	IBOutlet UILabel          *dbgtext_;
	IBOutlet UISearchBar      *searchfield_;
    
    IBOutlet UIBarButtonItem  *azsortbutton_;
    IBOutlet UIBarButtonItem  *shufflebutton_;
    IBOutlet UISegmentedControl *artistOrgControl_;

	UIActivityIndicatorView	*activity_;
}



-(IBAction) shuffle;
-(IBAction) reload;
-(IBAction) search;
-(IBAction) random;
//-(IBAction) textfieldchanged:(id)sender;
-(void) play:(int)index;

@property (nonatomic, retain) UITableView *artistTable_;
@property (nonatomic, retain) UISearchBar *searchfield_;


@end
