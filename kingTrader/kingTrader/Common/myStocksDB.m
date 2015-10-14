//
//  myStocksDB.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "myStocksDB.h"
#import "DBManager.h"

NSString * const myStockTable = @"stock_my";


@implementation myStocksDB

+(NSMutableArray *)GetStocksOfGroupID:(NSString*)groupID
{
    FMDatabase *db = [DBManager GetDB];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return list;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE groupID=? ORDER BY add_time DESC", myStockTable];
    
    FMResultSet *res = [db executeQuery:sql,groupID];
    
    while ([res next]) {
        [list addObject:[res resultDictionary]];
    }
    
    //    NSLog(@"mystock list : %@", list);
    
    return list;
}
+(BOOL)isOptional:(NSString *)code OfGroup:(NSString*)groupID;
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT code FROM %@ where code=? and groupID=?", myStockTable];
    
    FMResultSet *res = [db executeQuery:sql, code,groupID];
    
    
    BOOL isExists = NO;
    
    while ([res next]) {
        //        NSInteger existid = [res longForColumn:0];
        
        //        NSLog(@" exists %ld", existid);
        isExists = YES;
        break;
    }
    
    [db close];
    KTLog(@"%d",isExists);
    return isExists;
}
//更新置顶
+(void)UPData:(NSString *)upID{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *intTime = [NSString stringWithFormat:@"%.0f", a];
    
    NSString *sql = [NSString stringWithFormat:@" update %@ set add_time = %@  where _id = %@",myStockTable,intTime,upID];
    FMDatabase *db = [DBManager GetDB];
    if (![db open]) {
        return;
    }
    [db executeUpdate:sql];
    [db close];
    
    
}
// 排序
+(NSMutableArray *)GetAllOrderBy:(NSString *) field
{
    FMDatabase *db = [DBManager GetDB];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return list;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE status=1 ORDER BY %@ DESC", myStockTable, field];
    
    FMResultSet *res = [db executeQuery:sql];
    
    while ([res next]) {
        [list addObject:[res resultDictionary]];
    }
    
    return list;
}
/**
 *  添加股票
 *
 *  @param dic 装有股票信息的字典
 *
 *  @return 是否添加成功
 */
+(BOOL)addStock:(NSMutableDictionary *)dic
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return NO;
    }
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *intTime = [NSString stringWithFormat:@"%.0f", a];
    
    
    // 存在则改状态
    NSString *existSQL = [NSString stringWithFormat:@"SELECT code FROM %@ WHERE code=? and groupID=?", myStockTable];
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET add_time=? WHERE code=? and groupID=?", myStockTable];
    
    FMResultSet *res1 = [db executeQuery:existSQL, [dic objectForKey:@"code"],[dic objectForKey:@"groupID"]];
    while ([res1 next]) {
        NSDictionary *info = [res1 resultDictionary];
        //        NSLog(@"%@", info);
        if (info.count > 0) {
            [db executeUpdate:updateSQL,intTime , [info objectForKey:@"code"] , [info objectForKey:@"groupID"]];
        }
        
        return YES;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(name, code, n_code, increase, last_price, add_time, warn_price, updated, groupID) values(?, ?, ?, ?, ?, ?, ?, ?, ?)", myStockTable];
    
    BOOL res = [db executeUpdate:sql, [dic objectForKey:@"name"], [dic objectForKey:@"code"], [dic objectForKey:@"n_code"], [dic objectForKey:@"increase"], [dic objectForKey:@"last_price"], intTime, [dic objectForKey:@"warn_price"], intTime , [dic objectForKey:@"groupID"]];
    // KTLog(@"dic ==dfadfdfdf==%@",[dic objectForKey:@"groupID"]);
    return res;
}



+(NSDictionary *)getInfoByCode:(NSString *)code
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return nil;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE code=? and status=1", myStockTable];
    
    FMResultSet *res = [db executeQuery:sql, code];
    while ([res next]) {
        dic = [res resultDictionary];
        break;
    }
    
    [db close];
    
    return dic;
}


//删除分组的自选
+(void)deleteCode:(NSArray*)codes OfGroupID:(NSString*)groupID{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return ;
    }
    for (int i = 0; i < codes.count; i++) {
        // NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET warning=0, status=0 WHERE _id=? and groupID=?", myStockTable];
        NSString* sql = [NSString stringWithFormat:@"DELETE from %@ where code=? and groupID=?",myStockTable];
        BOOL res = [db executeUpdate:sql, [codes objectAtIndex:i],groupID];
        if (res) {
            NSLog(@"res:: 删除成功");
        } else {
            NSLog(@"res:: 删除失败");
            
        }
    }
    
    [db close];
    
    //return res;
}


+(BOOL)cleanAll
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ ", myStockTable];
    
    BOOL res = [db executeUpdate:sql];
    
    [db close];
    
    return res;
}


//同步自选股（新接口）
+(void)syncMyStockData:(NSMutableDictionary *)dataDic withGroupID:(NSString*)groupID
{
    
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return ;
    }
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *intTime = [NSString stringWithFormat:@"%.0f", a];
    
    // 存在则改状态
    NSString *existSQL = [NSString stringWithFormat:@"SELECT code FROM %@ WHERE code=? and groupID=? limit 1", myStockTable];
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET name=?, increase=?, last_price=?, n_code=? WHERE code=? and groupID=?", myStockTable];
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (name, code, n_code, increase, last_price, updated, add_time, groupID) values(?, ?,?, ?, ?, ?, ?, ?)", myStockTable];
    //遍历字典 同步数据到数据库
    for (NSString* key in dataDic.allKeys){
        
        //如果是股指期货
        if ([key hasPrefix:@"zj"]) {
            
            NSDictionary *dic = [dataDic objectForKey:key];
            
            NSString *price = [dic objectForKey:@"Last"];
            
            NSString *increase = [[NSString alloc] init];
    
           // if ([LTCommon isShouPan]) {
            if (increase) {
    
                increase = [NSString stringWithFormat:@"%.2f",100*([[dic objectForKey:@"Last"] floatValue] - [[dic objectForKey:@"PreClose"] floatValue])/[[dic objectForKey:@"PreClose"] floatValue]];
            }else{
                increase = [NSString stringWithFormat:@"%.2f",100*([[dic objectForKey:@"Last"] floatValue] - [[dic objectForKey:@"PreSettle"] floatValue])/[[dic objectForKey:@"PreSettle"] floatValue]];
            }
            
            NSString *code = [dic objectForKey:@"code"];
            NSString *name = [dic objectForKey:@"InstrumentID"];
            NSString *n_code = [dic objectForKey:@"InstrumentID"];
            
            NSString *groupId = groupID;
            
            BOOL updated = NO;
            
            FMResultSet *res1 = [db executeQuery:existSQL,code,groupID];
            while ([res1 next]) {
                NSDictionary *info = [res1 resultDictionary];
                if (info.count > 0) {
                    [db executeUpdate:updateSQL, name, increase, price, n_code, code, groupId];
                    updated = YES;
                }
            }
            
            if (updated) {
                continue;
            }
            
            [db executeUpdate:insertSQL, name, code, n_code, increase, price,intTime, intTime,groupId];
            
            
            
            //股票
        }else{
            NSDictionary *dic = [dataDic objectForKey:key];
            
            NSString *price = [dic objectForKey:@"HQZJCJ"];
            NSString *increase = [[NSString alloc] init];
            if([[dic objectForKey:@"HQZJCJ"] floatValue]!=0){
                increase = [NSString stringWithFormat:@"%.2f",100*([[dic objectForKey:@"HQZJCJ"] floatValue] - [[dic objectForKey:@"HQZRSP"] floatValue])/[[dic objectForKey:@"HQZRSP"] floatValue]];
            }else{
                increase = @"0.00";
                price = [dic objectForKey:@"HQZRSP"];
            }
            
            NSString *code = [dic objectForKey:@"code"];
            NSString *name = [dic objectForKey:@"HQZQJC"];
            NSString *n_code = [dic objectForKey:@"HQZQDM"];
            
            NSString *groupId = groupID;
            
            BOOL updated = NO;
            
            FMResultSet *res1 = [db executeQuery:existSQL,code,groupID];
            while ([res1 next]) {
                NSDictionary *info = [res1 resultDictionary];
                if (info.count > 0) {
                    [db executeUpdate:updateSQL, name, increase, price, n_code, code, groupId];
                    updated = YES;
                }
            }
            
            if (updated) {
                continue;
            }
            
            [db executeUpdate:insertSQL, name, code, n_code, increase, price,intTime, intTime,groupId];
        }
        
    }
    
    // 删除
    NSString *delSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE status=0", myStockTable];
    [db executeUpdate:delSql];
    
    [db close];
}



+(NSString *)getFidByCode:(NSString *)code
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT feed_id FROM %@ WHERE code=? and status=1 limit 1", myStockTable];
    
    FMResultSet *res = [db executeQuery:sql, code];
    
    NSString *fid = @"0";
    
    while ([res next]) {
        fid = [res stringForColumn:@"feed_id"];
    }
    
    [db close];
    
    if (fid == nil) {
        
        return @"100129818";
    }
    
    KTLog(@"%@",fid);
    return fid;
}


+(void)insertStock:(NSDictionary *)info
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return;
    }
    
    NSString *dbname = @"stock_search";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT code FROM %@ WHERE code=? ", dbname];
    
    FMResultSet *res = [db executeQuery:sql, [info objectForKey:@"code"]];
    
    while ([res next]) {
        NSLog(@"已存在");
        [db close];
        return;
    }
    
    NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@(name, code, n_code, firstspell) VALUES(?, ?, ?, ?)", dbname];
    
    NSString *ncode = [[info objectForKey:@"code"] substringFromIndex:2];\
    
    NSLog(@"ncode: %@", ncode);
    
    BOOL r = [db executeUpdate:insert, [info objectForKey:@"name"], [info objectForKey:@"code"], ncode, [info objectForKey:@"firstspell"]];
    if (r) {
        NSLog(@"ok");
    } else {
        NSLog(@"no");
    }
    
    [db close];
}

+(void)deleteSearchStock:(NSString *)code
{
    FMDatabase *db = [DBManager GetDB];
    
    if (![db open]) {
        NSLog(@"open db failed");
        return;
    }
    
    NSString *dbname = @"stock_search";
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE code=? ", dbname];
    
    BOOL res = [db executeUpdate:sql, code];
    if (res) {
        NSLog(@"del code ok");
    }
    
    [db close];
}
/**
 *  以新的数组对自选股进行排序
 *
 *  @param array   排好序的数组
 *  @param groupId 分组ID
 */
+(void)sortWithArray:(NSArray*)array WithGroupId:(NSString*)groupId{
    
    FMDatabase *db = [DBManager GetDB];
    if (![db open]) {
        return;
    }
    //重新排列股票的顺序 修改addtime 字段
    for (int i = 0 ; i < array.count; i++) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *intTime = [NSString stringWithFormat:@"%.0f", a-10*i];
        
        NSString *sql = [NSString stringWithFormat:@" update %@ set add_time = %@  where _id = %@",myStockTable,intTime,[[array objectAtIndex:i] objectForKey:@"_id"]];
        FMDatabase *db = [DBManager GetDB];
        if (![db open]) {
            return;
        }
        [db executeUpdate:sql];
        [db close];
    }
    [db close];
    
}
@end
