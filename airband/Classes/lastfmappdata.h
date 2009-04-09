#import <UIKit/UIKit.h>
#import "xmlhelp.h"
#import "appdata.h"

#pragma mark	-------------------------------------------------
#pragma mark	LastFMAppData
#pragma mark	-------------------------------------------------

@interface LastFMAppData : AppData
{
	NSString *apiID_;
	NSString *secret_;
	NSString *favartist_;
}


+ (LastFMAppData*) get;
@end


