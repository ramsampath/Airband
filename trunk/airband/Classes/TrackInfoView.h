
#import <UIKit/UIKit.h>


@interface TrackInfoView : UIView {
    UILabel  *album;
    UILabel  *artist;
    UILabel  *song;
}

@property (nonatomic, retain) UILabel *album;
@property (nonatomic, retain) UILabel *artist;
@property (nonatomic, retain) UILabel *song;

@end
