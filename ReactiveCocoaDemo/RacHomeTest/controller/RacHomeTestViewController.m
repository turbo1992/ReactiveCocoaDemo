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
    //test
    
    [self initUI];
    
    [self sendRequest];
    
}

- (void)initUI {
    
    self.title = @"ReactiveCocoa";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 请求结果展示
    UILabel *resultLabel = [[UILabel alloc]init];
    resultLabel.frame = CGRectMake(50.0f, 150.0f, self.view.frame.size.width-100.0f, 300.0f);
    resultLabel.numberOfLines = 0;
    [self addAssion:resultLabel];
    [self.view addSubview:resultLabel];
}

#pragma mark - sendRequest

- (void)sendRequest {
    
    UIButton *sendButton = [[UIButton alloc]init];
    sendButton.frame = CGRectMake(50.0f, 100.0f, self.view.frame.size.width - 100.0f, 30.0f);
    sendButton.backgroundColor = [UIColor blackColor];
    [sendButton setTitle:@"sendRequest" forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
    
    @weakify(self);
    sendButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        RacTestModel *homePageModel = [[RacTestModel alloc]init];
        
        NSString *pathUrl = [NSString stringWithFormat:@"http://mt.benxiangbentu.net/api/h5/homePage/indexList?pageNo=1&pageSize=10"];
        [[[homePageModel queryHomePageData:pathUrl] deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(HomePageTipModel *result) {
             
             UILabel *label = [self getAssociation];
             label.text = [NSString stringWithFormat:@"message:--->%@\nsuccess:--->%ld\nserverTime:--->%@\nheadlineList:--->%@\n",result.message,result.success,result.serverTime,result.headlineList];
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
