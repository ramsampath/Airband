//
//  LoadingView.h
//  airband
//
//  Created by Ram Sampath on 5/22/09.
//  Copyright 2009 Elliptic/Centroid PIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
{

}

+ (id)loadingViewInView:(UIView *)aSuperview loadingText:(NSString *)ltext fontSize:(float) fontSize;
+ (id)loadingViewInView:(UIView *)aSuperview loadingText:(NSString *)ltext;
- (void)removeView;

@end
