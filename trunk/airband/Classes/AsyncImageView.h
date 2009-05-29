//
//  AsyncImageView.h
//  airband
//
//  Created by Ram Sampath on 5/28/09.
//  Copyright 2009 Centroid PIC. All rights reserved.
//


//
//  AsyncImageView.h
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import <UIKit/UIKit.h>



@interface AsyncImageView: UIView 
{
}

- (void)loadImageFromURL:(NSString*)url;
- (void)loadImage:(NSString *) artwork;
- (void)imageReady:(UIImage *)img;

- (UIImage*) image;

@end
