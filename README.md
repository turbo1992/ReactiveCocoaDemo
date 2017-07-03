# ReactiveCocoa  
ReactiveCocoa结合AFNetworking的简单使用，以及RAC在UI控件例如UIButton上的简单使用

# CocoaPod配置
配置ReactiveCocoa时需要加上use_frameworks!

# 返回数据设置

1,返回序列化模型数据

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

2，返回原始数据

/* 登录 - 返回完整原始数据result */
- (RACSignal *)queryLoginRequest:loginUrl {
    
    return [[NetworkClient requestWithMethod:RequestMethodTypePost url:loginUrl params:nil] map:^id(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSNull class]]) {
            return nil;
        }
        
        return responseObject;
    }];
    
}
