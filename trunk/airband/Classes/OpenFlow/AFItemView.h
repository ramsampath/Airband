/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import <UIKit/UIKit.h>


@interface AFItemView : UIView {
    UIImageView		*imageView;
    UILabel         *albumLabel;
    UILabel         *artistLabel;
    int				number;
    CGFloat			horizontalPosition;
    CGFloat			verticalPosition;
    CGFloat			originalImageHeight;
}

@property int number;
@property (nonatomic, readonly) CGFloat horizontalPosition;
@property (nonatomic, readonly) CGFloat verticalPosition;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel     *albumLabel;
@property (nonatomic, readonly) UILabel     *artistLabel;

- (void)setImage:(UIImage *)newImage originalImageHeight:(CGFloat)imageHeight reflectionFraction:(CGFloat)reflectionFraction;
- (void)setAlbum:(NSString *)alabel;
- (void)setArtist:(NSString *)alabel;
- (CGSize)calculateNewSize:(CGSize)originalImageSize boundingBox:(CGSize)boundingBox;

@end