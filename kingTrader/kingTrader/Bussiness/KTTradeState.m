//
//  KTTradeState.m
//  kingTrader
//
//  Created by kt on 15/10/13.
//  Copyright © 2015年 张益豪. All rights reserved.
//

#import "KTTradeState.h"
#import "KTRefresh.h"
#import "StockType.h"

@implementation KTTradeState

+ (NSString*)getCurrentStateOfCode:(NSString*)code{
    
    if (![[self new]isWorkDays]) {
        return @"休市";
    }else{
        if ([KTRefresh isBetweenFromHour:0 FromMinute:0 toHour:9 toMinute:00]) {
            return @"未开盘";
        }
        if ([KTRefresh isBetweenFromHour:11 FromMinute:30 toHour:13 toMinute:00]) {
            return @"午间休市";
        }
        //股指期货
        if ([StockType isFuturesOfCode:code]) {
            if ([KTRefresh isBetweenFromHour:9 FromMinute:15 toHour:11 toMinute:30] ||
                [KTRefresh isBetweenFromHour:12 FromMinute:59 toHour:15 toMinute:15]) {
                return @"交易中";
            }else if ([KTRefresh isBetweenFromHour:0 FromMinute:0 toHour:9 toMinute:15]) {
                return @"未开盘";
            }else{
                return @"已收盘";
            }
            //
        }else{
            
            if ([KTRefresh isBetweenFromHour:0 FromMinute:0 toHour:9 toMinute:30]) {
                return @"未开盘";
            }else if ([KTRefresh isBetweenFromHour:9 FromMinute:30 toHour:11 toMinute:30] ||
                      [KTRefresh isBetweenFromHour:12 FromMinute:59 toHour:15 toMinute:00]) {
                return @"交易中";
            }else{
                return @"已收盘";
            }
            
        }
        
    }
    return @"已收盘";
}


//周几
- (NSString*)dayOfWeek{
    
    NSDateFormatter *fmtter =[[NSDateFormatter alloc] init];
    [fmtter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [fmtter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [fmtter setDateFormat:@"EEE"];
    return [fmtter stringFromDate:[NSDate date]];
    
}
/**
 * 是不是工作日
 */
- (BOOL)isWorkDays{
    
    NSString* dayString = [self dayOfWeek];
    if (nil == dayString) {
        return NO;
    }
    
    if ([dayString hasPrefix:@"Mon"]) {
        return YES;
    }
    if ([dayString hasPrefix:@"Tue"]) {
        return YES;
    }
    if ([dayString hasPrefix:@"Wed"]) {
        return YES;
    }
    if ([dayString hasPrefix:@"Thu"]) {
        return YES;
    }
    if ([dayString hasPrefix:@"Fri"]) {
        return YES;
    }
    if ([dayString hasPrefix:@"Sat"]) {
        return NO;
    }
    if ([dayString hasPrefix:@"Sun"]) {
        return NO;
    }
    
    return NO;
}


@end
