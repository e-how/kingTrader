//
//  KTDataCache.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/10.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTDataCache.h"
#import "NSString+Hashing.h"

@implementation KTDataCache

static KTDataCache* cache = nil;
+ (id)sharedInstance{
    if (cache == nil) {
        cache = [[[self class] alloc] init];
        cache.validTime = 24*60*60;
    }
    return cache;
}

-(void)saveData:(NSDictionary *)dataDic path:(NSString *)pathString{
    
    //
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dataDic forKey:@"Some Key Value"];
    [archiver finishEncoding];
    
    //2.1路径,在沙盒的Documents下面创建一个文件夹，用来保存缓存数据
    NSString *path = [NSString stringWithFormat:@"%@/Documents/DataCache",NSHomeDirectory()];

    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    

    NSString *md5String = [pathString MD5Hash];
    NSString *newString = [NSString stringWithFormat:@"%@/%@",path,md5String];
  
    [data writeToFile:newString atomically:YES];
    
    
}

//3.读取文件

-(NSDictionary *)getDataWithPath:(NSString *)pathString{
    
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@/Documents/DataCache/%@",NSHomeDirectory(),[pathString MD5Hash]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName] == NO ) {
        return nil;
    }
    //得到现在的时间与最后操作文件时间的差
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self getLastModeFyTime:fileName]];

    if (interval > self.validTime) {//文件过期实效了
        
        return nil;//告诉系统我没有内容 重新申请
    }
    
   // return [NSData dataWithContentsOfFile:fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some Key Value"];
    [unarchiver finishDecoding];
    
    return myDictionary;
    
}
//取最后操作这个文件的时间
-(NSDate *)getLastModeFyTime:(NSString *)filePath{
    //存的是当前文件的属性列表
    NSDictionary *dic = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil];
    
    //最后的时间
    return dic[@"NSFileModificationDate"];
}

//删除缓存
-(void)deleteCachesWithPath:(NSString *)path{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        [fileManager removeItemAtPath:fullPath error:nil];
    }
}

#pragma mark 计算缓存大小

-(long)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    long size = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    return size;
    
}


@end
