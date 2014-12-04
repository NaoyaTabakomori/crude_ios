//
//  MaterialViewController.m
//  Crude
//
//  Created by Tomoya Itagawa on 2014/11/23.
//  Copyright (c) 2014年 tomoya itagawa. All rights reserved.
//

#import "MaterialViewController.h"
#import "CompleteViewController.h"
#import "MaterialCell.h"
#import "EditViewController.h"

#ifdef DEBUG
static NSString * const kS3Host = @"https://crude-bucket.s3-ap-northeast-1.amazonaws.com";
#else
static NSString * const kS3Host = @"https://crude-bucket.s3-ap-northeast-1.amazonaws.com";
#endif

static NSString * const kCellIdentifier = @"MaterialCell";

@interface MaterialViewController ()
@property (strong, nonatomic) NSMutableArray *dataList;
@end

@implementation MaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"素材";
    
    __weak typeof(self) wself = self;
    [CallAPI callGetWithPath:@"list.json"
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         wself.dataList = responseObject;
                         [wself.tableView reloadData];
                     }
                       error:^(AFHTTPRequestOperation *operation, NSError *error) {
                           [CallAPI showErrorAlert];
                       }];
    
    UINib *nib = [UINib nibWithNibName:kCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaterialCell *cell = (MaterialCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[MaterialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    [cell.materialImageView setImage:nil];
    NSDictionary *data = self.dataList[indexPath.row];
    NSString *path = [data valueForKeyPath:@"large_image.path"];
    NSString *query = [data valueForKeyPath:@"large_image.query"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@", kS3Host, path, query];
    [cell.materialImageView setImageWithURL:[NSURL URLWithString:urlString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MaterialCell *cell = (MaterialCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    for (UIViewController *con in self.navigationController.viewControllers) {
        if ([con isKindOfClass:[EditViewController class]]) {
            EditViewController *edit = (EditViewController *)con;
            edit.collageImage = cell.materialImageView.image;
            [self.navigationController popToViewController:edit animated:YES];
            return;
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
//    {
//        __weak typeof(self) wself = self;
//        [CallAPI callGetWithPath:@"list.json"
//                      parameters:nil
//                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                             wself.dataList = responseObject;
//                             [wself.tableView reloadData];
//                         }
//                           error:^(AFHTTPRequestOperation *operation, NSError *error) {
//                               [CallAPI showErrorAlert];
//                           }];
//    }
//}

@end
