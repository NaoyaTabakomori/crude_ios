//
//  CallAPI.h
//  gokon
//
//  Created by kixixixixi on 2014/07/21.
//  Copyright (c) 2014年 hyper8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface CallAPI : NSObject

typedef void (^AFSuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFFailureBlock) (AFHTTPRequestOperation *operation, NSError *error);

+ (void)callGetWithPath:(NSString*)path parameters:(NSDictionary*)parameters success:(AFSuccessBlock)success error:(AFFailureBlock)error;
+ (void)callPostWithPath:(NSString*)path parameters:(NSDictionary*)parameters success:(AFSuccessBlock)success error:(AFFailureBlock)error;
+ (void)uploadImage:(UIImage *)image success:(AFSuccessBlock)success failure:(AFFailureBlock)failure;
+ (void)showErrorAlert;

@end
