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
    kTagMaterial,
    kTagClip,
    kTagPaste
};

@interface EditViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (assign, nonatomic) NSInteger selectedMode;
@property (strong, nonatomic) UIView *clippedView;
@property (strong, nonatomic) UIImage *clippedImage;
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"編集";
    self.selectedMode = kTagTarget;
    [Utils setBackBarButtonItemNonTitle:self];
    [self.segmentedControl setTintColor:kNavBarColor];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(draggedView:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(doubleTappedView:)];
    [tapGesture setNumberOfTapsRequired:2];
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(pinchedView:)];
    self.clippedView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.clippedView setTag:kTagClip];
    [self.clippedView setHidden:YES];
    [self.clippedView setBackgroundColor:[Utils colorWithColorCode:@"FFFFFF" alpha:0.6]];
    [self.clippedView addGestureRecognizer:panGesture];
    [self.clippedView addGestureRecognizer:tapGesture];
//    [self.clippedView addGestureRecognizer:pinchGesture];
    [self.view addSubview:self.clippedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //UIImagePickerControllerから戻ってきた時のため
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
        self.selectedMode = kTagTarget;
        [self.collageImageView setHidden:NO];
        [self.materialImageView setHidden:YES];
    } else if (self.segmentedControl.selectedSegmentIndex == kTagMaterial) {
        self.selectedMode = kTagMaterial;
        [self.materialImageView setHidden:NO];
        [self.collageImageView setHidden:YES];
    }
}

- (IBAction)tappedClipButton:(id)sender
{
    [self.clippedView setHidden:NO];
}

- (void)doubleTappedView:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == kTagClip) {
        if (self.selectedMode == kTagTarget) {
            CGRect rect = CGRectMake(self.clippedView.originX - self.collageImageView.originX,
                                     self.clippedView.originY - self.collageImageView.originY,
                                     self.clippedView.sizeWidth,
                                     self.clippedView.sizeHeight);
            self.clippedImage =  [self.collageImageView.image clipImageWithRect:rect
                                                                  imageViewSize:self.collageImageView.frame.size];
            [self.clippedView setHidden:YES];
        } else if (self.selectedMode == kTagMaterial) {
            CGRect rect = CGRectMake(self.clippedView.originX - self.materialImageView.originX,
                                     self.clippedView.originY - self.materialImageView.originY,
                                     self.clippedView.sizeWidth,
                                     self.clippedView.sizeHeight);
            self.clippedImage =  [self.materialImageView.image clipImageWithRect:rect
                                                                   imageViewSize:self.materialImageView.frame.size];
            [self.clippedView setHidden:YES];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"切り取りました"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    } else if (tapGesture.view.tag == kTagPaste) {
        if (self.selectedMode == kTagTarget) {
            UIImage *image = [self.collageImageView imageFromView];
            [self.collageImageView removeAllSubviews];
            [self.collageImageView setImage:image];
        } else if (self.selectedMode == kTagMaterial) {
            UIImage *image = [self.materialImageView imageFromView];
            [self.materialImageView removeAllSubviews];
            [self.materialImageView setImage:image];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"貼り付けました"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)draggedView:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = [panGesture translationInView:self.view];
    CGPoint movedPoint = CGPointMake(panGesture.view.centerX + location.x, panGesture.view.centerY + location.y);
    [panGesture.view setCenter:movedPoint];
    [panGesture setTranslation:CGPointZero inView:self.view];
}

- (void)pinchedView:(UIPinchGestureRecognizer *)pinchGesture
{
    
}

- (IBAction)tappedPasteButton:(id)sender
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(draggedView:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(doubleTappedView:)];
    [tapGesture setNumberOfTapsRequired:2];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.clippedView.sizeWidth, self.clippedView.sizeHeight)];
    [iv setTag:kTagPaste];
    [iv setImage:self.clippedImage];
    [iv setUserInteractionEnabled:YES];
    [iv addGestureRecognizer:panGesture];
    [iv addGestureRecognizer:tapGesture];
    if (self.selectedMode == kTagTarget) {
        [self.collageImageView addSubview:iv];
    } else if (self.selectedMode == kTagMaterial) {
        [self.materialImageView addSubview:iv];
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
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)tappedCompleteButton:(id)sender
{
    CompleteViewController *con = [CompleteViewController new];
    if (self.selectedMode == kTagTarget) {
        UIImage *image = [self.collageImageView imageFromView];
        [self.collageImageView removeAllSubviews];
        [self.collageImageView setImage:image];
        con.completeImage = image;
    } else if (self.selectedMode == kTagMaterial) {
        UIImage *image = [self.materialImageView imageFromView];
        [self.materialImageView removeAllSubviews];
        [self.materialImageView setImage:image];
        con.completeImage = image;
    }

    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (self.selectedMode == kTagTarget) {
        [self.collageImageView setImage:image];
    } else if (self.selectedMode == kTagMaterial) {
        [self.materialImageView setImage:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
