//
//  AsyncImageView.m
//  airband
//
//  Created by Ram Sampath on 5/28/09.
//  Copyright 2009 Centroid PIC/Elliptic. All rights reserved.
//


//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import "AsyncImageView.h"
#import "imgcache.h"
#import "appdata.h"



@interface ArtworkReady : NSObject<ProtocolAsyncImage>
{
}
@end


@implementation ArtworkReady

-(void) imageReady:(UIImage*)img   userData:(id)userData
{
	if( !img) 
        return;
    else {
        AsyncImageView *aimageview = (AsyncImageView *) userData;
        [aimageview imageReady:img];
    }
}


-(void) failed:(id)userdata error:(NSError*)error
{
	//printf( "image failed\n" );
}

@end



// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@implementation AsyncImageView

- (void)dealloc 
{
    [super dealloc];
}

//
// the URL/imagecache connection calls this once all the data has downloaded
//
-(void) imageReady:(UIImage*)img
{
	//so self data now has the complete image 
    
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
	
	//make an image view for the image
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:img] autorelease];
    
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
    
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
}



- (void)loadImageFromURL:(NSString *)url
{    
    static imagecache   *ic = nil;
	static ArtworkReady *myt = nil;
	
    AppData *app = [AppData get];
    if( !ic ) {
        if( app ) 
            ic  = app.albumArtCache_;
        myt = [[[ArtworkReady alloc] init] retain];
    }
    
    if( ic ) {
        UIImage *img = [ic loadWithURL:url callback:nil callbackdata:self];
		if( img ) {
			[self imageReady:img];
		}
    }
	//TODO error handling, what if connection_ is nil?
}


- (void) loadImage: (NSString *)imagename
{
    AppData *app = [AppData get];
    
    UIImage *image = [app.albumArtCache_ loadImage:imagename];
    [self imageReady:image];
}


//
//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image 
{
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

@end