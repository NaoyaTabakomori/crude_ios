//
//  Utils.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/22.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIColor *)colorWithColorCode:(NSString *)code alpha:(double)alpha
{
    NSScanner *scanner = [NSScanner scannerWithString:code];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"#"];
    unsigned int w = 0;
    [scanner scanHexInt:&w];
    
    return [UIColor colorWithRed:((w >> 16) & 0x00ff) / 255.0
                           green:((w >> 8) & 0x00ff) / 255.0
                            blue:((w) & 0x00ff) / 255.0
                           alpha:(CGFloat)alpha];
}

@end
