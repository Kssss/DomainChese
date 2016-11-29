//
//  ViewController.m
//  DomainCheseTool
//
//  Created by Vieene on 2016/11/29.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "ViewController.h"
#import "CJDomainSelect.h"
NSString * const kCJAppFileAddrssOne = @"http://www.baidu.com";
NSString * const kCJAppFileAddrssTwo = @"http://www.sina.com.cn";
NSString * const kCJAppFileAddrssThree = @"https://github.com";
NSString * const kCJAppFileAddrssFour = @"http://www.qq.com";
NSString * const kCJAppFileAddrssFive = @"http://stackoverflow.com";

NSString *  kCJBestAppFileAddrss;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kCJBestAppFileAddrss = kCJAppFileAddrssThree;//先设置一个默认的地址。

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSArray *domainArray = @[kCJAppFileAddrssTwo,kCJAppFileAddrssThree,kCJAppFileAddrssOne,kCJAppFileAddrssFour,kCJAppFileAddrssFive];
    [CJDomainSelect domainSelectWithTimes:3 domains:domainArray succseBlock:^(NSString *bestDomain) {
        kCJBestAppFileAddrss = bestDomain;
        NSLog(@"访问最快的域名地址是：%@",bestDomain);
    }];

}

@end
