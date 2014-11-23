//
//  EditViewController.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/22.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "EditViewController.h"
#import "CompleteViewController.h"
#import "MaterialViewController.h"

enum {
    kTagTarget,
    kTagMaterial
};

@interface EditViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (assign, nonatomic) NSInteger selectedMode;
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"編集";
    [Utils setBackBarButtonItemNonTitle:self];
    [self.segmentedControl setTintColor:kNavBarColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.collageImage) {
        [self.collageImageView setImage:self.collageImage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changedSegment:(id)sender
{
    if (self.segmentedControl.selectedSegmentIndex == kTagTarget) {
        
    } else if (self.segmentedControl.selectedSegmentIndex == kTagMaterial) {
        
    }
}

- (IBAction)tappedAlbumButton:(id)sender
{
    UIImagePickerController *con = [UIImagePickerController new];
    con.delegate = self;
    con.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:con animated:YES completion:nil];
}

- (IBAction)tappedMaterialButton:(id)sender
{
    MaterialViewController *con = [[MaterialViewController alloc] initWithStyle:UITableViewStylePlain];
    con.title = @"素材";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:navi animated:YES completion:nil];
}

- (IBAction)tappedCompleteButton:(id)sender
{
//    CompleteViewController *con = [CompleteViewController new];
//    con.collageImage = self.collageImageView.image;
    CompleteViewController *con = (CompleteViewController *)self.presentingViewController;
    con.collageImage = self.collageImageView.image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.collageImageView setImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
