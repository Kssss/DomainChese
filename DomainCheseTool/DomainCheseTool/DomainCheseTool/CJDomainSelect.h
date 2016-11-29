//
//  TYHDomainSelect.h
//
//  Created by Vieene on 16/1/26.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJDomainSelect : NSObject
/**
 *  测试域名网络状态
 *
 *  @param times       每个域名测试的次数
 *  @param domains     域名数组（格式为：http://www.baidu.com）
 *  @param domainblock 返回最优的域名Str
 */
+(void)domainSelectWithTimes:(int)times domains:(NSArray *)domains succseBlock:(void (^)(NSString *bestDomain,NSString *result))domainblock;
@end

@interface CJDomainInfo :NSObject
@property (assign, nonatomic) double time;
@property (assign,nonatomic) int index;
@end


