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

#ifdef DEBUG
static NSString * const kS3Host = @"https://crude-bucket.s3-ap-northeast-1.amazonaws.com";
#else
static NSString * const kS3Host = @"https://crude-bucket.s3-ap-northeast-1.amazonaws.com";
#endif

static NSString * const kCellIdentifier = @"CellIdentifier";

@interface MaterialViewController ()
@property (strong, nonatomic) NSArray *dataList;
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
    
    NSDictionary *data = self.dataList[indexPath.row];
    NSString *path = [data valueForKeyPath:@"large_image.path"];
    NSString *query = [data valueForKeyPath:@"large_image.query"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@", kS3Host, path, query];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (!connectionError) {
             UIImage *image = [[UIImage alloc] initWithData:data];
             [cell.materialImageView setImage:image];
         } else {
             [CallAPI showErrorAlert];
         }
     }];
    
//    [cell.materialImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
//    [AFImageRequestOperation imageRequestOperationWithRequest:request
//     　   imageProcessingBlock:nil
//                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                                          _imageView.image = image;
//                                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                                                          _imageView.image = 読み込み失敗の画像など;
//                                                      }];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [cell.materialImageView
//     setImageWithURLRequest:request
//     placeholderImage:nil
//     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//         NSLog(@"honoka");
//     }
//     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//         NSLog(@"error:%@", error.description);
//     }];
//    [cell.materialImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    CompleteViewController *con = [CompleteViewController new];
//    MaterialCell *cell = (MaterialCell *)[tableView cellForRowAtIndexPath:indexPath];
//    con.completeImage = cell.materialImageView.image;
//    [self.navigationController pushViewController:con animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
