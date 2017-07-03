//
//  NetworkClient.m
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "NetworkClient.h"
#import <objc/runtime.h>

@implementation NetworkClient
/**
 *  对AFHTTPSessionManager启用单例模式
 *  @return 单例
 */
+ (AFHTTPSessionManager*)sharedHTTPSessionManager{
    static AFHTTPSessionManager* mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 2;
        NSURL* baseURL = [NSURL URLWithString:BaseUrl];
        mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    });
    return mgr;
}

+ (BOOL)checkRetry:(NSNumber*)retryCount{
    return retryCount.integerValue > 0;
}

+ (RACSignal *)requestWithMethod:(RequestMethodType)methodType
                             url:(NSString *)url
                          params:(NSDictionary *)params
{
    NSLog(@"当前请求URL地址->%@",[NSString stringWithFormat:@"%@%@",BaseUrl,url]);
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    AFHTTPSessionManager* mgr = [self sharedHTTPSessionManager];
    
    
    //拼接标识Request的Key
    NSString* requestID = [NSString stringWithFormat:@"%@:%@", @(methodType), url];
    NSNumber* retryCount = objc_getAssociatedObject(mgr, [requestID UTF8String]);
    if (!retryCount) {
        retryCount = @(3);
    } else {
        retryCount = @(retryCount.integerValue - 1);
    }
    objc_setAssociatedObject(mgr, [requestID UTF8String], retryCount, OBJC_ASSOCIATION_COPY);
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [mgr GET:url
          parameters:params
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSDictionary* result = responseObject;
                 result = [result mutableDeepCopy];
                 [self deepCleanCollection:result];
                 
                 id json = responseObject;
                 [subject sendNext:json];
                 [subject sendCompleted];
             }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 NSLog(@"Error: %@", error);
                 if (error.code == kCFURLErrorTimedOut && [self checkRetry:retryCount]) {
                     [self requestWithMethod:methodType url:url params:nil];
                 } else {
                     objc_setAssociatedObject(mgr, [requestID UTF8String], nil, OBJC_ASSOCIATION_COPY);
                     [subject sendError:error];
                 }
             }];
            return [subject deliverOn:[RACScheduler scheduler]];
        }
            break;
            
        case RequestMethodTypePost:
        {
            //POST请求
            [mgr POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary* result = responseObject;
                result = [result mutableDeepCopy];
                [self deepCleanCollection:result];
                
                id json = responseObject;
                [subject sendNext:json];
                [subject sendCompleted];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error: %@", error);
                if (error.code == kCFURLErrorTimedOut && [self checkRetry:retryCount]) {
                    [self requestWithMethod:methodType url:url params:nil];
                } else {
                    objc_setAssociatedObject(mgr, [requestID UTF8String], nil, OBJC_ASSOCIATION_COPY);
                    [subject sendError:error];
                }
            }];
            return [subject deliverOn:[RACScheduler scheduler]];
        }
            break;
            
        case RequestMethodTypeDelete:
        {
            //DELETE请求
            [mgr DELETE:url
             parameters:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSDictionary* result = responseObject;
                    result = [result mutableDeepCopy];
                    [self deepCleanCollection:result];
                    
                    id json = responseObject;
                    [subject sendNext:json];
                    [subject sendCompleted];
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"Error: %@", error);
                    if (error.code == kCFURLErrorTimedOut && [self checkRetry:retryCount]) {
                        [self requestWithMethod:methodType url:url params:nil];
                    } else {
                        objc_setAssociatedObject(mgr, [requestID UTF8String], nil, OBJC_ASSOCIATION_COPY);
                        [subject sendError:error];
                    }
                }];
            return [subject deliverOn:[RACScheduler scheduler]];
            
        }
            break;
        default:
            break;
    }
    
}

/* 清理集合（Array & Dictionary）中的NSNull */
+ (void)deepCleanCollection:(id<NSFastEnumeration>)collection{
    id instance = collection;
    if ([instance isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* dict = instance;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(NSFastEnumeration)]) {
                [self deepCleanCollection:obj];
            } else {
                if (obj == [NSNull null]) {
                    [dict setValue:@"" forKey:key];
                }
            }
        }];
    } else if ([instance isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray* array = instance;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(NSFastEnumeration)]) {
                [self deepCleanCollection:obj];
            } else {
                if (obj == [NSNull null]) {
                    [array replaceObjectAtIndex:idx withObject:@""];
                }
            }
        }];
    }
}

@end
