

#import <UIKit/UIKit.h>

@interface AlbumInfo: NSObject
{
    UIImage   *art;
    NSInteger index;
    NSString  *albumIdReq;
    NSString  *artistName;
}

@property (readwrite, retain) UIImage *art;
@property (readwrite, assign) NSInteger index;
@property (readwrite, retain) NSString *albumIdReq;
@property (readwrite, retain) NSString *artistName;


@end
