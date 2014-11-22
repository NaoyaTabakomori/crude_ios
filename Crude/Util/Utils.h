//
//  Utils.h
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/22.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (UIColor *)colorWithColorCode:(NSString *)code alpha:(double)alpha;
+ (void)setBackBarButtonItemNonTitle:(UIViewController *)con;

@end
