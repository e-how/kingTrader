//
//  KTRefresh.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/15.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTRefresh.h"

@implementation KTRefresh

static KTRefresh* sharedRefresh = nil;

+ (instancetype)sharedRefresh{
    if (sharedRefresh == nil) {
        sharedRefresh = [[KTRefresh alloc] init];
    }
    return sharedRefresh;
}

- (BOOL)isRefreshTime{
    if ([[self class] isBetweenFromHour:9 FromMinute:29 toHour:11 toMinute:31]) {
        return YES;
    }else if ([[self class] isBetweenFromHour:12 FromMinute:59 toHour:15 toMinute:31]){
        return YES;
    }
    return NO;
}

- (CGFloat)getRefreshTime{
    return 5.f;
}
- (void)setRefreshTime{
    
}

/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour FromMinute:(NSInteger)fromMinu toHour:(NSInteger)toHour toMinute:(NSInteger)toMinu
{
    NSDate *date8 = [self getCustomDateWithHour:fromHour Minute:fromMinu];
    NSDate *date23 = [self getCustomDateWithHour:toHour Minute:toMinu];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour Minute:(NSInteger)minu
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minu];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}


@end
