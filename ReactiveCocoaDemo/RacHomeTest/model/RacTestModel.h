//
//  RacTestModel.h
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageTipModel : NSObject

@property (nonatomic, assign) NSInteger                         errCode;
@property (nonatomic, strong) NSDictionary                      *data;
@property (nonatomic, copy  ) NSString                          *message;
@property (nonatomic, copy  ) NSString                          *hasData;
@property (nonatomic, copy  ) NSString                          *serverTime;
@property (nonatomic, assign) NSInteger                         success;
@property (nonatomic, strong) NSArray                           *bannerList;
@property (nonatomic, strong) NSArray                           *headlineList;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end

@interface RacTestModel : NSObject

/* 请求首页 */
- (RACSignal *)queryHomePageData:pathUrl;

/* 请求登录 */
- (RACSignal *)queryLoginData:loginUrl;

@end
