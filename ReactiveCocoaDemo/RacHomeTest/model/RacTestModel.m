//
//  RacTestModel.m
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "RacTestModel.h"

@implementation HomePageTipModel

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.errCode                    = [[attributes objectForKey:@"errCode"] integerValue];
    self.data                       = [attributes  objectForKey:@"data"];
    self.message                    = [attributes  objectForKey:@"message"];
    self.hasData                    = [attributes  objectForKey:@"hasData"];
    self.serverTime                 = [attributes  objectForKey:@"serverTime"];
    self.success                    = [[attributes  objectForKey:@"success"] integerValue];
    self.bannerList                 = [self.data objectForKey:@"bannerList"];
    self.headlineList               = [self.data objectForKey:@"headlineList"];

    return self;
}

@end

@implementation RacTestModel

/* 请求首页 - 返回序列化数据模型object */
- (RACSignal *)queryHomePageData:pathUrl{
    
    return [[NetworkClient requestWithMethod:RequestMethodTypeGet url:pathUrl params:nil]map:^id(NSDictionary *responseObject) {
        
        if ([responseObject isKindOfClass:[NSNull class]]) {
            return nil;
        }
        
        NSLog(@"responseObject:---->%@",responseObject);
        
        HomePageTipModel * object = [[HomePageTipModel alloc] initWithAttributes:responseObject];
        return object;
    }];
    
    
}

/* 请求登录 - 返回完整原始数据result */
- (RACSignal *)queryLoginData:loginUrl {
    
    return [[NetworkClient requestWithMethod:RequestMethodTypeGet url:loginUrl params:nil] map:^id(id responseObject) {
        
        NSLog(@"responseObject:---->%@",responseObject);

        if ([responseObject isKindOfClass:[NSNull class]]) {
            return nil;
        }
        
        return responseObject;
    }];
    
}

@end
