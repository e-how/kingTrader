//
//  StockType.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//  判断是什么类型的股票

#import <Foundation/Foundation.h>

@interface StockType : NSObject
/**
 *  是不是股指期货
 */
+ (BOOL)isFuturesOfCode:(NSString*)code;
/**
 *  是不是大盘指数
 */
+ (BOOL)isIndexOfCode:(NSString*)code;
/**
 *  是不是板块
 */
+ (BOOL)isBlocksOfCode:(NSString*)code;
/**
 *  是不是平常的股票
 */
+ (BOOL)isNormalOfCode:(NSString*)code;


@end
