//
//  TYHDomainSelect.m
//
//  Created by Vieene on 16/1/26.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "CJDomainSelect.h"
@interface CJDomainSelect()

@property(nonatomic,strong)NSURLSessionDownloadTask *task;

//时间总长
@property (nonatomic,strong) NSMutableArray *timeNum;

//测试次数
@property (nonatomic,assign) int times;
//时间
@property (nonatomic,strong) NSMutableArray *DateArray;

//已经运行次数
@property (nonatomic,strong) NSMutableArray *hasRuntime;
//记录运行完毕的0为未运行完毕，存储的是 index
@property (nonatomic,strong) NSMutableArray *runOver;

@property (nonatomic,strong) NSArray *domains;

@property (nonatomic,copy) void (^domainblock)(NSString *bestDomain);
@end
static int overNum;
//结束的个数
@implementation CJDomainSelect

- (NSMutableArray *)timeNum
{
    if (_timeNum == nil ) {
        _timeNum = [NSMutableArray array];
    }
    return _timeNum;
}
- (NSMutableArray *)runOver
{
    if (_runOver == nil) {
        _runOver = [NSMutableArray array];
    }
    return _runOver;
}

- (NSMutableArray *)DateArray
{
    if (_DateArray == nil) {
        _DateArray = [NSMutableArray array];
    }
    return _DateArray;
}
- (NSMutableArray *)hasRuntime
{
    if (_hasRuntime == nil) {
        _hasRuntime = [NSMutableArray array];
    }
    return _hasRuntime;
}
+ (void)domainSelectWithTimes:(int)times domains:(NSArray *)domains succseBlock:(void (^)(NSString *bestDomain))domainblock
{
    CJDomainSelect *selector =  [[CJDomainSelect alloc] init];
    selector.times = times;
    selector.domains = domains;
    if (domainblock) {
        selector.domainblock = [domainblock copy];
    }
    [selector start];
}

- (void)start
{
        for (int j = 0; j < self.domains.count; j ++) {
            NSDate* tmpStartData = [NSDate date];
            //放置计时器
            [self.DateArray addObject:tmpStartData];
            //存储运行时间总长
            [self.timeNum addObject:@(0)];
            //存储运行次数
            [self.hasRuntime addObject:@(0)];
            //清楚记录
            [self.runOver removeAllObjects];
            overNum = 0;
            for (int i = 0;i < self.times ; i++) {
                NSURL *url = [NSURL URLWithString:self.domains[j]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                request.timeoutInterval = 5;//设置超时时间
                request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [urlConnection start];
            }
        }
}


#pragma mark------NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"%@",connection.currentRequest.URL);
    [self setAverageTimeWithConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"-----%@",error.description);
    [self setAverageTimeWithConnection:connection];
    
}
- (void)setAverageTimeWithConnection:(NSURLConnection *)connection
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",connection.currentRequest.URL];

    for (int i = 0; i < self.domains.count ;i ++) {
        if ([urlStr isEqualToString:self.domains[i]]) {
            //取出Date
            NSDate* date = self.DateArray[i];
            double deltaTime = [[NSDate date] timeIntervalSinceDate:date];
            NSLog(@">>>>>>>>>>cost time = %f ms------URL=%@", deltaTime*1000,urlStr);
           float time = [self.timeNum[i] floatValue];
            time += deltaTime;
            self.timeNum[i] = @(time);
            
            int runNum = [self.hasRuntime[i] intValue];
            runNum ++;
            self.hasRuntime[i] = @(runNum);
            
            if (runNum == self.times) {
                [self checkOverWithIndex:i];
            }
        }
}
}
- (void)checkOverWithIndex:(int)index
{
    overNum ++;
    [self.runOver addObject:@(index)];
    if (overNum == self.domains.count) {
        for (<#initialization#>; <#condition#>; <#increment#>) {
            <#statements#>
        }
        self.domainblock(self.domains[[self.runOver[0] intValue]]);
    }
}




    

@end
