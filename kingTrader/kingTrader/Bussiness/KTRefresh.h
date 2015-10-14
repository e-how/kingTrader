//
//  KTRefresh.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/15.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTRefresh : NSObject

+ (instancetype)sharedRefresh;

/**
 *  是否是刷新时间（开盘时间）
 */
- (BOOL)isRefreshTime;

/**
 *  获取刷新频率
 *
 *  @return 刷新频率
 */
- (CGFloat)getRefreshTime;

- (void)setRefreshTime;

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour FromMinute:(NSInteger)fromMinu toHour:(NSInteger)toHour toMinute:(NSInteger)toMinu;

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */

+ (NSDate *)getCustomDateWithHour:(NSInteger)hour Minute:(NSInteger)minu;

@end
