//
//  TYHDomainSelect.m
//
//  Created by Vieene on 16/1/26.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "CJDomainSelect.h"
@interface CJDomainSelect()<NSURLSessionDelegate>

@property(nonatomic,strong)NSURLSessionDownloadTask *task;

//存储每个任务 花费时间总长
@property (nonatomic,strong) NSMutableArray *timeNum;

//每个任务测试次数
@property (nonatomic,assign) int times;
//存储单个任务开始的时间 数组
@property (nonatomic,strong) NSMutableArray *DateArray;

//单个任务已经运行次数
@property (nonatomic,strong) NSMutableArray *hasRuntime;
    
//记录运行完毕的任务。0为未运行完毕，存储的是 index
@property (nonatomic,strong) NSMutableArray *runOver;

//存储URL的数组
@property (nonatomic,strong) NSArray *domains;
    
@property (nonatomic,copy) void (^domainblock)(NSString *bestDomain,NSString *result);
@end

//统计已经完成访问次数的URL的个数
static int overNum;
//超时时间
static int timeOut = 3;
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
+ (void)domainSelectWithTimes:(int)times domains:(NSArray *)domains succseBlock:(void (^)(NSString *bestDomain,NSString *result))domainblock
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
            [self.timeNum addObject:[[CJDomainInfo alloc] init] ];
            //存储运行次数
            [self.hasRuntime addObject:@(0)];
            //清楚记录
            [self.runOver removeAllObjects];
            overNum = 0;
            for (int i = 0;i < self.times ; i++) {
                NSURL *url = [NSURL URLWithString:self.domains[j]];
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
                config.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
                config.timeoutIntervalForResource = timeOut;
                NSURLSession *se = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
                NSURLSessionDataTask *dataTask = [se dataTaskWithURL:url];
                
                [dataTask resume];
                
            }
        }
}

#pragma mark -NSURLSessionDataDelegate
/**
* 接收到响应
*/
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //测试响应速度就没必关心HTML Data的大小，只关心网站的响应速度即可。这里选择取消后续的数据
    completionHandler(NSURLSessionResponseCancel);
}
    
/**
* 接收到服务器返回的数据
*/
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
        
    //测试响应速度就没必关心HTML Data的大小，只关心网站的响应速度即可。
}
#pragma mark -NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
//    NSLog(@"%@",error.description);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setAverageTimeWithConnection:task error:error];
    });

    [session finishTasksAndInvalidate];
}


- (void)setAverageTimeWithConnection:(NSURLSessionTask *)sessionTask error:(NSError *)error
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",sessionTask.currentRequest.URL];
    for (int i = 0; i < self.domains.count ;i ++) {
        NSRange range = [urlStr rangeOfString:self.domains[i]];
        if ( range.location!=NSNotFound) {
            //取出Date
            NSDate* date = self.DateArray[i];
            double deltaTime = [[NSDate date] timeIntervalSinceDate:date];
            //code = -1003 访问主机不存在
            if (error.code == -1003) deltaTime = MAXFLOAT;
//            NSLog(@">>>>>>>>>>cost time = %f ms------URL=%@", deltaTime*1000,urlStr);
           CJDomainInfo * info = self.timeNum[i];
            info.time += deltaTime;
            info.index = i;
            self.timeNum[i] = info;
            
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
        NSMutableString *muStr = @"\n".mutableCopy;
        [muStr appendString:@"域名的访问速度排名:\n"];
       NSArray <CJDomainInfo *>* orderArray =  [self.timeNum sortedArrayUsingComparator:^NSComparisonResult(CJDomainInfo * obj1, CJDomainInfo * obj2) {
           return  [@(obj1.time) compare:@(obj2.time)];
        }];
        for (CJDomainInfo * info in orderArray) {
            [muStr appendFormat:@"%@----花费的总时间是%f s\n",self.domains[info.index],info.time];
        }
        
        self.domainblock(self.domains[orderArray[0].index],muStr);
    }
}




    

@end
@implementation CJDomainInfo



@end
