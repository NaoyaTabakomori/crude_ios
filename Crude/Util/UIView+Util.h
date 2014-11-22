#import <UIKit/UIKit.h>

@interface UIView (Util)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat sizeWidth;
@property (nonatomic) CGFloat sizeHeight;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (readonly) CGFloat frameBottom;
@property (readonly) CGFloat frameRight;

+ (id)viewFromXibWithOwner:(id)owner;
- (void)removeAllSubviews;
- (void)showWithFadeAnimaton;
- (void)closeWithFadeAnimaton;
- (UIImage *)imageFromView;

@end
