//
//  UINavigationController+Util.h
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/23.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Util)
- (void)pushOrPopViewController:(UIViewController *)nextVC animated:(BOOL)animated;
@end
