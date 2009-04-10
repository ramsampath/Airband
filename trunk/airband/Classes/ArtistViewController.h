#import <UIKit/UIKit.h>
#import "xmlhelp.h"
#import "songview.h"

@interface ArtistViewController : 
	UIViewController< UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate >
{
	NSMutableArray *artistList_;
	
	IBOutlet UITableView	*artistTable_;  
	IBOutlet UIButton* shuffle_;
	IBOutlet UILabel *dbgtext_;
	IBOutlet UITextField *searchfield_;
		
	UIActivityIndicatorView	*activity_;
}

-(IBAction) shuffle;
-(IBAction) pause;
-(IBAction) search;
-(IBAction) random;
-(IBAction) textfieldchanged:(id)sender;
-(void) play:(int)index;

@property (nonatomic, retain) UITableView *artistTable_;


@end
