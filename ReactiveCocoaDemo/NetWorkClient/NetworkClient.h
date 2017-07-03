//
//  NetworkClient.h
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypeGet = 1,
    RequestMethodTypePost = 2,
    RequestMethodTypeDelete
};

@interface NetworkClient : NSObject

+ (RACSignal *)requestWithMethod:(RequestMethodType)methodType
                             url:(NSString *)url
                          params:(NSDictionary *)params;
@end
