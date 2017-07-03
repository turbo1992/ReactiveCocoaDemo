//
//  RacTestModel.m
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "RacTestModel.h"

@implementation QuestionTipModel

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.resultCode                   = [[attributes objectForKey:@"resultCode"] integerValue];
    self.resultDesc                   = [attributes  objectForKey:@"resultDesc"];
    self.questionTipListArr           = [attributes  objectForKey:@"questionTipList"];
    
    return self;
}

@end

@implementation RacTestModel

/* 请求消息 - 返回序列化数据模型object */
- (RACSignal *)queryLastQuestionTip:pathUrl{
    
    return [[NetworkClient requestWithMethod:RequestMethodTypeGet url:pathUrl params:nil]map:^id(NSDictionary *responseObject) {
        
        if ([responseObject isKindOfClass:[NSNull class]]) {
            return nil;
        }
                
        QuestionTipModel * object = [[QuestionTipModel alloc] initWithAttributes:responseObject];
        return object;
    }];
    
    
}

/* 登录 - 返回完整原始数据result */
- (RACSignal *)queryLoginRequest:loginUrl {
    
    return [[NetworkClient requestWithMethod:RequestMethodTypePost url:loginUrl params:nil] map:^id(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSNull class]]) {
            return nil;
        }
        
        return responseObject;
    }];
    
}

@end
