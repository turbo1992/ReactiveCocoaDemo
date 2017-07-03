//
//  RacTestModel.h
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionTipModel : NSObject

@property (nonatomic, assign) NSInteger                        resultCode;          /* resultCode */
@property (nonatomic, copy  ) NSString                         *resultDesc;         /* 提示信息 */
@property (nonatomic, strong) NSArray                          *questionTipListArr; /* 问题数组 */

@property (nonatomic, strong) NSString                         *qCategoryName;      /* 类型 */
@property (nonatomic, strong) NSString                         *qNickName;          /* 昵称 */
@property (nonatomic, assign) NSInteger                        pushMsgId;           /* 推送消息id */
@property (nonatomic, assign) NSInteger                        qId;                 /* 问题id */


- (id)initWithAttributes:(NSDictionary *)attributes;

@end

@interface RacTestModel : NSObject

/* 请求消息 */
- (RACSignal *)queryLastQuestionTip:pathUrl;

/* 登录 */
- (RACSignal *)queryLoginRequest:loginUrl;

@end
