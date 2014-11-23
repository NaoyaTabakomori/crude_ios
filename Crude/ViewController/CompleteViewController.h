//
//  CompleteViewController.h
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/22.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *collageImageView;
@property (weak, nonatomic) IBOutlet UIButton *startCollageButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *changeAncestorButton;
@property (weak, nonatomic) IBOutlet UIButton *changeParentButton;

@property (strong, nonatomic) UIImage *collageImage;

@end
