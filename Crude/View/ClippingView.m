//
//  ClippingView.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/12/11.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "ClippingView.h"

static const NSInteger kCircleOneSide = 44;
enum {
    kTagLtCircle = 1,
    kTagLbCircle,
    kTagRtCircle,
    kTagRbCircle
};

@interface ClippingView()
@property (strong, nonatomic) UIView *ltCircle;
@property (strong, nonatomic) UIView *lbCircle;
@property (strong, nonatomic) UIView *rtCircle;
@property (strong, nonatomic) UIView *rbCircle;
@end

@implementation ClippingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setControls:frame];
    }
    return self;
}

- (void)setControls:(CGRect)frame
{
    UIColor *circleColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
    self.ltCircle = [[UIView alloc] initWithFrame:CGRectMake(- kCircleOneSide / 2,
                                                             - kCircleOneSide / 2,
                                                             kCircleOneSide,
                                                             kCircleOneSide)];
    [self.ltCircle makeCircle];
    [self.ltCircle setBackgroundColor:circleColor];
    [self addSubview:self.ltCircle];
    [self.ltCircle setTag:kTagLtCircle];
    UIPanGestureRecognizer *panGestureLt = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(draggedView:)];
    [self.ltCircle addGestureRecognizer:panGestureLt];
    
    self.lbCircle = [[UIView alloc] initWithFrame:CGRectMake(- kCircleOneSide / 2,
                                                             frame.size.height - kCircleOneSide / 2,
                                                             kCircleOneSide,
                                                             kCircleOneSide)];
    [self.lbCircle makeCircle];
    [self.lbCircle setBackgroundColor:circleColor];
    [self addSubview:self.lbCircle];
    [self.lbCircle setTag:kTagLbCircle];
    UIPanGestureRecognizer *panGestureLb = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(draggedView:)];
    [self.lbCircle addGestureRecognizer:panGestureLb];
    
    self.rtCircle = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - kCircleOneSide / 2,
                                                             - kCircleOneSide / 2,
                                                             kCircleOneSide,
                                                             kCircleOneSide)];
    [self.rtCircle makeCircle];
    [self.rtCircle setBackgroundColor:circleColor];
    [self addSubview:self.rtCircle];
    [self.rtCircle setTag:kTagRtCircle];
    UIPanGestureRecognizer *panGestureRt = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(draggedView:)];
    [self.rtCircle addGestureRecognizer:panGestureRt];

    self.rbCircle = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - kCircleOneSide / 2,
                                                             frame.size.height - kCircleOneSide / 2,
                                                             kCircleOneSide,
                                                             kCircleOneSide)];
    [self.rbCircle makeCircle];
    [self.rbCircle setBackgroundColor:circleColor];
    [self addSubview:self.rbCircle];
    [self.rbCircle setTag:kTagRbCircle];
    UIPanGestureRecognizer *panGestureRb = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(draggedView:)];
    [self.rbCircle addGestureRecognizer:panGestureRb];
}

- (void)drawRect:(CGRect)rect
{
#warning どうするか考える
    self.clippingRect = rect;
}

- (void)draggedView:(UIPanGestureRecognizer *)panGesture
{
#warning 親Viewより離れた位置はGestureRecognizerが感知できない
#warning ドラッグ後にClippingViewのSizeを調整すること
    CGPoint location = [panGesture translationInView:panGesture.view.superview];
    CGPoint movedPoint = CGPointMake(panGesture.view.centerX + location.x, panGesture.view.centerY + location.y);
    [panGesture.view setCenter:movedPoint];
    
//    if (panGesture.view.tag == kTagLtCircle) {
//    
//    } else if (panGesture.view.tag == kTagLbCircle) {
//    
//    } else if (panGesture.view.tag == kTagRtCircle) {
//    
//    } else if (panGesture.view.tag == kTagRbCircle) {
//        
//    }
    
    [panGesture setTranslation:CGPointZero inView:panGesture.view.superview];
}

@end
