
#import "Albuminfo.h"


@implementation AlbumInfo

@synthesize art;
@synthesize index;
@synthesize albumIdReq;
@synthesize artistName;

-(id) init
{
    art   = nil;
    index = 0;
    albumIdReq = nil;
    artistName = nil;
    return self;
}



- (void)dealloc
{
    [albumIdReq release];
    [artistName release];
    [art release];
    [super dealloc];
}



@end

