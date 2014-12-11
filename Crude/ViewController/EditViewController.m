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
#import "ClippingView.h"

enum {
    kTagTarget,
    kTagMaterial,
    kTagClip,
    kTagPaste
};

@interface EditViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (assign, nonatomic) NSInteger selectedMode;
@property (strong, nonatomic) ClippingView *clippingView;
@property (strong, nonatomic) UIImage *clippedImage;
@property (assign, nonatomic) CGAffineTransform currentClipTransform;
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"編集";
    self.selectedMode = kTagTarget;
    [Utils setBackBarButtonItemNonTitle:self];
    [self.segmentedControl setTintColor:kNavBarColor];
    [self setUpButton];
    [self setupClipView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //UIImagePickerControllerから戻ってきた時のため
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (self.collageImage) {
        self.collageImage = [self.collageImage renderImage];
        
        if (self.selectedMode == kTagTarget) {
            [self.collageImageView setImage:self.collageImage];
        } else if (self.selectedMode == kTagMaterial) {
            [self.materialImageView setImage:self.collageImage];
        }
        
        //貼付けたのでnilにする
        self.collageImage = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpButton
{
    [self.clipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clipButton setBackgroundColor:[Utils colorWithColorCode:@"6D767B" alpha:1.0]];
    [self.pasteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pasteButton setBackgroundColor:[Utils colorWithColorCode:@"ACC38E" alpha:1.0]];
    [self.selectMaterialButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectMaterialButton setBackgroundColor:[Utils colorWithColorCode:@"D8C189" alpha:1.0]];
    [self.selectAlbumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectAlbumButton setBackgroundColor:[Utils colorWithColorCode:@"866A54" alpha:1.0]];
    [self.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.completeButton setBackgroundColor:[Utils colorWithColorCode:@"B58778" alpha:1.0]];
    
    [self makeCornerRound:self.clipButton];
    [self makeCornerRound:self.pasteButton];
    [self makeCornerRound:self.selectMaterialButton];
    [self makeCornerRound:self.selectAlbumButton];
    [self makeCornerRound:self.completeButton];
    
    [self makeShadow:self.clipButton];
    [self makeShadow:self.pasteButton];
    [self makeShadow:self.selectMaterialButton];
    [self makeShadow:self.selectAlbumButton];
    [self makeShadow:self.completeButton];
}

- (void)makeCornerRound:(UIButton *)button
{
    [button.layer setCornerRadius:5.0];
    [button setClipsToBounds:YES];
}

- (void)makeShadow:(UIButton *)button
{
    button.layer.masksToBounds = NO;
    button.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    button.layer.shadowOpacity = 0.7f;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowRadius = 3.0f;
}

- (void)setupClipView
{
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(doubleTappedView:)];
//    [tapGesture setNumberOfTapsRequired:2];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(draggedView:)];
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(pinchedView:)];
////    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self
////                                                                                              action:@selector(rotatedView:)];
//    self.clippedView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self.clippedView setTag:kTagClip];
//    [self.clippedView setHidden:YES];
//    [self.clippedView setBackgroundColor:[Utils colorWithColorCode:@"9A9E93" alpha:0.6]];
//    [self.clippedView addGestureRecognizer:tapGesture];
//    [self.clippedView addGestureRecognizer:panGesture];
//    [self.clippedView addGestureRecognizer:pinchGesture];
////    [self.clippedView addGestureRecognizer:rotateGesture];
//    [self.view addSubview:self.clippedView];
    
    self.clippingView = [[ClippingView alloc] initWithFrame:CGRectMake(self.collageImageView.originX,
                                                                       self.collageImageView.originY,
                                                                       100,
                                                                       100)];
    self.clippingView.parentView = self.view;
    [self.view addSubview:self.clippingView];
}

#pragma mark - clipView Gesture
- (void)doubleTappedView:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == kTagClip) {
        if (self.selectedMode == kTagTarget) {
            CGRect rect = CGRectMake(self.clippingView.originX - self.collageImageView.originX,
                                     self.clippingView.originY - self.collageImageView.originY,
                                     self.clippingView.sizeWidth,
                                     self.clippingView.sizeHeight);
            self.clippedImage =  [self.collageImageView.image clipImageWithRect:rect
                                                                  imageViewSize:self.collageImageView.frame.size];
            [self.clippingView setHidden:YES];
        } else if (self.selectedMode == kTagMaterial) {
            CGRect rect = CGRectMake(self.clippingView.originX - self.materialImageView.originX,
                                     self.clippingView.originY - self.materialImageView.originY,
                                     self.clippingView.sizeWidth,
                                     self.clippingView.sizeHeight);
            self.clippedImage =  [self.materialImageView.image clipImageWithRect:rect
                                                                   imageViewSize:self.materialImageView.frame.size];
            [self.clippingView setHidden:YES];
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
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.currentClipTransform = self.clippingView.transform;
    }
    CGFloat scale = [pinchGesture scale];
    self.clippingView.transform = CGAffineTransformConcat(self.currentClipTransform, CGAffineTransformMakeScale(scale, scale));
}

- (void)rotatedView:(UIRotationGestureRecognizer *)rotateGesture
{
}

#pragma mark - tappedButton

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
    [self.clippingView setHidden:NO];
    
    self.title = @"切り抜き";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(tappedCancelButtonForClipping)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(tappedOKButtonForClipping)];
    self.navigationItem.rightBarButtonItem = right;
}

- (IBAction)tappedPasteButton:(id)sender
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(draggedView:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(doubleTappedView:)];
    [tapGesture setNumberOfTapsRequired:2];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.clippingView.sizeWidth, self.clippingView.sizeHeight)];
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

- (void)tappedCancelButtonForClipping
{
    [self.clippingView setHidden:YES];
    [self completeAction];
}

- (void)tappedOKButtonForClipping
{
    [self.clippingView setHidden:YES];
    [self completeAction];
}

- (void)completeAction
{
    self.title = @"編集";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (self.selectedMode == kTagTarget) {
        [self.collageImageView setImage:[image renderImage]];
    } else if (self.selectedMode == kTagMaterial) {
        [self.materialImageView setImage:[image renderImage]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
