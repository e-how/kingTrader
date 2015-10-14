//
//  StockType.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "StockType.h"

@implementation StockType
/**
 *  是不是股指期货
 */
+ (BOOL)isFuturesOfCode:(NSString*)code{
    
    if ([code hasPrefix:@"zj"]) {
        return YES;
    }else{
        return NO;
    }
    
}
/**
 *  是不是大盘指数
 */
+ (BOOL)isIndexOfCode:(NSString*)code{
    
    NSArray *indexCodes = [NSArray arrayWithObjects:
                           
                           @"sh000001",@"sh000903",
                           @"sz399001",@"sz399005",
                           @"sz399006",@"sz399300",
                           nil];
    
    for (NSString *str in indexCodes) {
        
        if ([str isEqualToString:code]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  是不是板块
 */
+ (BOOL)isBlocksOfCode:(NSString*)code{
    if ([code hasPrefix:@"02"]) {
        return YES;
    }else
        return NO;
}
/**
 *  是不是普通的股票
 */
+ (BOOL)isNormalOfCode:(NSString*)code{
    
    if ([[self class] isFuturesOfCode:code] ||
        [[self class] isBlocksOfCode:code] ||
        [[self class] isIndexOfCode:code]) {
        return NO;
    }else
        return YES;
}
@end
