//
//  CallAPI.m
//  gokon
//
//  Created by kixixixixi on 2014/07/21.
//  Copyright (c) 2014年 hyper8. All rights reserved.
//

#import "CallAPI.h"

#ifdef DEBUG
static NSString * const kAPIBaseURL = @"http://49.212.164.106:3000";
#else
static NSString * const kAPIBaseURL = @"http://49.212.164.106:3000";
#endif

@implementation CallAPI

+ (void)callGetWithPath:(NSString*)path parameters:(NSDictionary*)parameters success:(AFSuccessBlock)success error:(AFFailureBlock)error
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",kAPIBaseURL, path];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:URLString parameters:nil success:(AFSuccessBlock)success failure:(AFFailureBlock)error];
}

+ (void)callPostWithPath:(NSString*)path parameters:(NSDictionary*)parameters success:(AFSuccessBlock)success error:(AFFailureBlock)error
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",kAPIBaseURL, path];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:URLString parameters:parameters success:(AFSuccessBlock)success failure:(AFFailureBlock)error];
}

+ (void)showErrorAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:@"何らかの不具合が発生したようです。\n時間を置いて再度お試しください。"
                                                   delegate:nil
                                          cancelButtonTitle:@""
                                          otherButtonTitles:@"OK", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

@end
