#import <UIKit/UIKit.h>
#import "xmlhelp.h"
#import "songview.h"



@interface ArtistViewController : 
	UIViewController< UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate >
{
	NSMutableArray *artistList_;
	NSMutableArray   *savedArtistList_; // the saved content in case the user cancels a search

	IBOutlet UITableView	*artistTable_;  
	IBOutlet UIButton* shuffle_;
	IBOutlet UILabel *dbgtext_;
	IBOutlet UISearchBar *searchfield_;
	
		
	UIActivityIndicatorView	*activity_;
}



-(IBAction) shuffle;
-(IBAction) pause;
-(IBAction) search;
-(IBAction) random;
//-(IBAction) textfieldchanged:(id)sender;
-(void) play:(int)index;

@property (nonatomic, retain) UITableView *artistTable_;
@property (nonatomic, retain) UISearchBar *searchfield_;


@end
