//
//  ClippingView.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/12/11.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "ClippingView.h"

static const NSInteger kCircleOneSide = 25;
enum {
    kTagCircle = 1,
    kTagMainView
};

@interface ClippingView()
@property (strong, nonatomic) UIView *circle;
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
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             frame.size.width - kCircleOneSide / 2,
                                                             frame.size.height - kCircleOneSide / 2)];
    [self.mainView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [self addSubview:self.mainView];
    [self.mainView setTag:kTagMainView];
    UIPanGestureRecognizer *panGestureMainView = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(draggedView:)];
    [self.mainView addGestureRecognizer:panGestureMainView];

    self.circle = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - kCircleOneSide,
                                                           frame.size.height - kCircleOneSide,
                                                           kCircleOneSide,
                                                           kCircleOneSide)];
    [self.circle makeCircle];
    [self.circle setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [self addSubview:self.circle];
    [self.circle setTag:kTagCircle];
    UIPanGestureRecognizer *panGestureCircle = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(draggedView:)];
    [self.circle addGestureRecognizer:panGestureCircle];
}

- (void)draggedView:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.view.tag == kTagCircle) {
        CGPoint location = [panGesture translationInView:self];
        CGPoint movedPoint = CGPointMake(self.circle.centerX + location.x, self.circle.centerY + location.y);
        [self setSize:CGSizeMake(self.sizeWidth + location.x,
                                 self.sizeHeight + location.y)];
        [self.mainView setSize:CGSizeMake(self.mainView.sizeWidth + location.x,
                                          self.mainView.sizeHeight + location.y)];
        [self.circle setCenter:movedPoint];
        
#warning 領域の上限・下限は設定できるようにしておきたい
//        [self setSize:CGSizeMake(MAX(self.sizeWidth + movedPoint.x - self.circle.centerX, kCircleOneSide * 1.5),
//                                 MAX(self.sizeHeight + movedPoint.y - self.circle.centerY, kCircleOneSide * 1.5))];
//        [self.mainView setSize:CGSizeMake(MAX(self.mainView.sizeWidth + movedPoint.x - self.circle.centerX, kCircleOneSide),
//                                          MAX(self.mainView.sizeHeight + movedPoint.y - self.circle.centerY, kCircleOneSide))];
//        if (movedPoint.x > kCircleOneSide && movedPoint.y > kCircleOneSide) {
//            [self.circle setCenter:movedPoint];
//        }
        
        [panGesture setTranslation:CGPointZero inView:self];
    } else if (panGesture.view.tag == kTagMainView) {
        CGPoint location = [panGesture translationInView:self];
        [self setCenter:CGPointMake(self.centerX + location.x,
                                    self.centerY + location.y)];
        [self.mainView setOrigin:CGPointZero];
        [self.circle setCenter:CGPointMake(self.mainView.sizeWidth,
                                           self.mainView.sizeHeight)];
        [panGesture setTranslation:CGPointZero inView:self];
    }
}

@end
