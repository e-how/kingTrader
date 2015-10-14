//
//  DBManager.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
#define CREATEDBPATH    \
    NSString *dirs = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];\
    NSString *dirPath = [dirs stringByAppendingPathComponent:@"jiaoyishi/db"];

// 初始化数据库， 把数据库拷到指定目录下
+(void)initDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    // 创建目录
    CREATEDBPATH
    
    if (![fileManager fileExistsAtPath:dirPath]) {
        
        if ([fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err]) {
            KTLog(@"create liangtou dir success");
        } else {
            KTLog(@"create liangtou dir failed : %@", err);
        }
    } else {
        KTLog(@"liangtou dir exists");
    }
    
    // copy 数据库
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *dbVersion = [infoDict objectForKey:@"KTdbversion"];
    
    NSString *dbFilePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"jiaoyishi-%@.db", dbVersion]];
    if (![fileManager fileExistsAtPath:dbFilePath]) {
        // 删除旧文件
        NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
        for (int i=0; i<fileList.count; i++) {
            NSString *fname = [NSString stringWithFormat:@"%@/%@",dirPath, fileList[i]];
            KTLog(@"delete file : %@", fname);
            [fileManager removeItemAtPath:fname error:nil];
        }
        
        // 获取相应文件路径
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"jiaoyishi" ofType:@"db"];
        
        KTLog(@"dataPata==%@",dataPath);
        if (dataPath) {
            
        if ([fileManager copyItemAtPath:dataPath toPath:dbFilePath error:&err]) {
            KTLog(@"copy db file success %@", dbFilePath);
        } else {
            KTLog(@"copy db file failed : %@", err);
        }}
    } else {
        
        KTLog(@"db file exists");
    }
}

+(FMDatabase *)GetDB
{
    static FMDatabase *dbInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        CREATEDBPATH
        
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *dbVersion = [infoDict objectForKey:@"KTdbversion"];
        
        NSString* dbpath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"jiaoyishi-%@.db", dbVersion]];
        KTLog(@"dbpath: %@", dbpath);
        dbInstance = [FMDatabase databaseWithPath:dbpath];
    });
    
    return dbInstance;
}

+(void)dropDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    // 创建目录
    CREATEDBPATH
    
    // 数据库
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *dbVersion = [infoDict objectForKey:@"KTdbversion"];
    
    NSString *dbFilePath = [dirPath stringByAppendingFormat:@"/jiaoyishi-%@.db",dbVersion];
    if ([fileManager fileExistsAtPath:dbFilePath]) {
        
        if ([fileManager removeItemAtPath:dbFilePath error:&err]) {
            KTLog(@"drop db file success");
        } else {
            KTLog(@"drop db file failed : %@", err);
        }
    } else {
        KTLog(@"drop de failed : file no  exists");
    }
    
}


@end
