//
//  CallAPI.m
//  gokon
//
//  Created by kixixixixi on 2014/07/21.
//  Copyright (c) 2014年 hyper8. All rights reserved.
//

#import "CallAPI.h"

@implementation CallAPI

+ (void)callGetWithPath:(NSString*)path parameters:(NSDictionary*)parameters success:(AFSuccessBlock)success error:(AFFailureBlock)error
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",kAPIHost, path];
    if (!path) {
        URLString = kAPIHost;
    }
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:URLString parameters:nil success:(AFSuccessBlock)success failure:(AFFailureBlock)error];
}

+ (void)callPostWithPath:(NSString*)path parameters:(NSDictionary*)parameters success:(AFSuccessBlock)success error:(AFFailureBlock)error
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",kAPIHost, path];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URLString parameters:parameters success:(AFSuccessBlock)success failure:(AFFailureBlock)error];
}

+ (void)uploadImage:(UIImage *)image success:(AFSuccessBlock)success failure:(AFFailureBlock)failure
{
    NSDate *date = [NSDate date];
    NSString* date_converted;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date_converted = [formatter stringFromDate:date];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *name = [NSString stringWithFormat:@"zatsu%@.png", date_converted];
    NSString *URLString = [NSString stringWithFormat:@"%@/create",kAPIHost];
    
    AFHTTPRequestOperation *op = [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData
                                    name:@"image"
                                fileName:name
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        if (failure) {
            failure(operation, error);
        }
    }];
    [op start];
}

+ (void)showErrorAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"何らかの不具合が発生したようです。\n時間を置いて再度お試しください。"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

@end
