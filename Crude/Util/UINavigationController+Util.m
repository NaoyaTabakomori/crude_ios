//
//  UINavigationController+Util.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/23.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "UINavigationController+Util.h"

@implementation UINavigationController (Util)

- (void)pushOrPopViewController:(UIViewController *)nextVC animated:(BOOL)animated
{
    for (UIViewController *con in self.viewControllers) {
        if ([con isKindOfClass:[nextVC class]]) {
            [self popToViewController:nextVC animated:animated];
            return;
        }
    }
    
    [self pushViewController:nextVC animated:animated];
}

@end
