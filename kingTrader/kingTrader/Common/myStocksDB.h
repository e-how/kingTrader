//
//  myStocksDB.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myStocksDB : NSObject

// 通过code取fid
+(NSString *)getFidByCode:(NSString *)code;
+(void)UPData:(NSString *)upID;

// 取出分组ID对应的股票
+(NSMutableArray *)GetStocksOfGroupID:(NSString*)groupID;
// 是否已有自选 shxxxx
+(BOOL)isOptional:(NSString *)code OfGroup:(NSString*)groupID;
// 排序
+(NSMutableArray *)GetAllOrderBy:(NSString *) field;
//添加股票
+(BOOL)addStock:(NSMutableDictionary *)dic;

// 删除分组的股票
+(void)deleteCode:(NSArray*)codes OfGroupID:(NSString*)groupID;
//同步我的自选股（新）
+(void)syncMyStockData:(NSMutableDictionary *)dataDic withGroupID:(NSString*)groupID;

+(NSDictionary *)getInfoByCode:(NSString *)code;

+(BOOL)cleanAll;

+(void)insertStock:(NSDictionary *)info;

+(void)deleteSearchStock:(NSString *)code;

+(void)sortWithArray:(NSArray*)array WithGroupId:(NSString*)groupId;

@end
