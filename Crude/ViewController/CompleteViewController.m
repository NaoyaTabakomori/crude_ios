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

static NSString * const kShareMessage = @"雑コラ！";

@interface CompleteViewController()<UIActionSheetDelegate>

@end

@implementation CompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"完成";
    [Utils setBackBarButtonItemNonTitle:self];
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
    [self.navigationController popViewControllerAnimated:YES];
//    EditViewController *con = [EditViewController new];
//    con.title = @"編集";
//    con.collageImage = self.completeImage;
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:con];
//    [self presentViewController:navi animated:YES completion:nil];
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
                                                                                        (CFStringRef)kShareMessage,
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
    [controller setInitialText:[kShareMessage stringByRemovingPercentEncoding]];
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
    [controller setInitialText:[kShareMessage stringByRemovingPercentEncoding]];
    __weak typeof(self) wself = self;
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [wself dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

@end
