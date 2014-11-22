#import "UIView+Util.h"

@implementation UIView (Util)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)sizeWidth
{
    return self.frame.size.width;
}

- (void)setSizeWidth:(CGFloat)sizeWidth
{
    CGRect frame = self.frame;
    frame.size.width = sizeWidth;
    self.frame = frame;
}

- (CGFloat)sizeHeight
{
    return self.frame.size.height;
}

- (void)setSizeHeight:(CGFloat)sizeHeight
{
    CGRect frame = self.frame;
    frame.size.height = sizeHeight;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)frameBottom
{
    return self.originY + self.sizeHeight;
}

- (CGFloat)frameRight
{
    return self.originX + self.sizeWidth;
}

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView = nil;
            imageView.layer.sublayers = nil;
            imageView.image= nil;
            [imageView removeFromSuperview];
        }
    }
}

- (void)showWithFadeAnimaton
{
    [self setAlpha:0];
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        [wself setAlpha:1];
    }];
}

- (void)closeWithFadeAnimaton
{
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        [wself setAlpha:0];
    } completion:^(BOOL finished) {
        [wself removeFromSuperview];
    }];
}

- (UIImage *)imageFromView
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
