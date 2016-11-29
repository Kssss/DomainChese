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
NSString * const kCJAppFileAddrssFive = @"http://www.cocoachina.com";

NSString *  kCJBestAppFileAddrss;


@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UITextView *txView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _txView.userInteractionEnabled = YES;
     self.txView.text = @"获取中。。。。。";
    NSArray *domainArray = @[kCJAppFileAddrssOne,kCJAppFileAddrssTwo,kCJAppFileAddrssThree,kCJAppFileAddrssFour,kCJAppFileAddrssFive];
    kCJBestAppFileAddrss = kCJAppFileAddrssThree;//先设置一个默认的地址。
    [CJDomainSelect domainSelectWithTimes:6 domains:domainArray succseBlock:^(NSString *bestDomain,NSString *result) {
        _txView.userInteractionEnabled = NO;
        kCJBestAppFileAddrss = bestDomain;
        self.txView.text = [NSString stringWithFormat:@"响应最快的域名地址是：%@\n,总结果是：%@",bestDomain,result];
        NSLog(@"响应最快的域名地址是：%@,总结果是：%@",bestDomain,result);
    }];

}

@end
