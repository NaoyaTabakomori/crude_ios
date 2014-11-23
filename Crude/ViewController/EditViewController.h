//
//  EditViewController.h
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/22.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *collageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
@property (weak, nonatomic) IBOutlet UIButton *clipButton;
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMaterialButton;
@property (weak, nonatomic) IBOutlet UIButton *selectAlbumButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (strong, nonatomic) UIImage *collageImage;

@end
