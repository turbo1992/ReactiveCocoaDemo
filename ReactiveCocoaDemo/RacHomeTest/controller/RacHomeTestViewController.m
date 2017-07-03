//
//  RacHomeTestViewController.m
//  ReactiveCocoaDemo
//
//  Created by Turbo on 2017/7/3.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "RacHomeTestViewController.h"
#import "RacTestModel.h"
#import <objc/runtime.h>

static char resultLabelAssociation;

@interface RacHomeTestViewController ()

@end

@implementation RacHomeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self sendRequest];
    
}

- (void)initUI {
    
    self.title = @"ReactiveCocoa";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 请求结果展示
    UILabel *resultLabel = [[UILabel alloc]init];
    resultLabel.frame = CGRectMake(10.0f, 200.0f, self.view.frame.size.width-20.0f, 200.0f);
    resultLabel.numberOfLines = 0;
    [self addAssion:resultLabel];
    [self.view addSubview:resultLabel];
}

#pragma mark - sendRequest

- (void)sendRequest {
    
    UIButton *sendButton = [[UIButton alloc]init];
    sendButton.frame = CGRectMake(50.0f, 150.0f, self.view.frame.size.width - 100.0f, 30.0f);
    sendButton.backgroundColor = [UIColor blackColor];
    [sendButton setTitle:@"发送请求" forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
    
    @weakify(self);
    sendButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        UILabel *label = [self getAssociation];
        label.text = @"输出状态->%ld\n输出结果->%@\n";
        
        RacTestModel *tipModel = [[RacTestModel alloc]init];
        NSString *pathUrl = [NSString stringWithFormat:@"http://192.168.1.53:8080/MJServer/login?username=123&pwd=123"];
        [[[tipModel queryLastQuestionTip:pathUrl] deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(QuestionTipModel *object) {
             
             UILabel *label = [self getAssociation];
             label.text = [NSString stringWithFormat:@"输出状态->%ld\n输出结果->%@\n",object.resultCode,object.questionTipListArr];
         }];
        
        return [RACSignal empty];
    }];

}

#pragma mark - objc_Association

- (void)addAssion:(id)objc {
    objc_setAssociatedObject(self, &resultLabelAssociation, objc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)getAssociation {
    id objc = objc_getAssociatedObject(self, &resultLabelAssociation);
    if ([objc isKindOfClass:[UILabel class]] && objc) {
        return objc;
    }
    return nil;
}

- (void)dealloc {
    objc_setAssociatedObject(self, &resultLabelAssociation, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_removeAssociatedObjects(self);
}

@end
