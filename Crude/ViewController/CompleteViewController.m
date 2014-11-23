//
//  CompleteViewController.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/22.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "CompleteViewController.h"
#import <Social/Social.h>
#import "EditViewController.h"

@interface CompleteViewController()<UIActionSheetDelegate>
@property (strong, nonatomic) NSString *shareMessage;
@end

@implementation CompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"完成";
    [Utils setBackBarButtonItemNonTitle:self];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setDimBackground:YES];
    __weak typeof(self) wself = self;
    [CallAPI uploadImage:self.completeImage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:wself.navigationController.view
                                 animated:YES];
        wself.shareMessage = [NSString stringWithFormat:@"%@/show/%zd #雑コラ",
                              kAPIHost, [responseObject[@"id"] integerValue]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お知らせ"
                                                        message:@"アップロードが完了しました。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:wself.navigationController.view
                                 animated:YES];
        wself.shareMessage = @"#雑コラ";
        [CallAPI showErrorAlert];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.completeImageView setImage:self.completeImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedStartButton:(id)sender
{
    for (UIViewController *con in self.navigationController.viewControllers) {
        if ([con isKindOfClass:[EditViewController class]]) {
            EditViewController *edit = (EditViewController *)con;
            edit.segmentedControl.selectedSegmentIndex = 0;
            edit.collageImage = self.completeImage;
            [self.navigationController popToViewController:edit animated:YES];
            return;
        }
    }
}

- (IBAction)tappedShareButton:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    [sheet addButtonWithTitle:@"LINE"];
    [sheet addButtonWithTitle:@"Twitter"];
    [sheet addButtonWithTitle:@"Facebook"];
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = 3;
    [sheet showInView:self.view];
}

#pragma mark - action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self postLine];
    } else if (buttonIndex == 1) {
        [self postTwitter];
    } else if (buttonIndex == 2) {
        [self postFacebook];
    }
}

#pragma mark - share methods
- (void)postLine
{
    NSString *contentKey = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                        NULL,
                                                                                        (CFStringRef)self.shareMessage,
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                        kCFStringEncodingUTF8 );
    NSString *lineURLString = [NSString stringWithFormat:@"line://msg/text/%@", contentKey];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:lineURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lineURLString]];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"この端末にはLINEがインストールされていません。"
                                                       delegate:nil
                                              cancelButtonTitle:@""
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)postTwitter
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"Twitterアカウントが設定されていません。"
                                                       delegate:nil
                                              cancelButtonTitle:@""
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:self.shareMessage];
    [controller addImage:self.completeImage];
    __weak typeof(self) wself = self;
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [wself dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)postFacebook
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"Facebookアカウントが設定されていません。"
                                                       delegate:nil
                                              cancelButtonTitle:@""
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:self.shareMessage];
    [controller addImage:self.completeImage];
    __weak typeof(self) wself = self;
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [wself dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

@end
