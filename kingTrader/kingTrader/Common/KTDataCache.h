//
//  KTDataCache.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/10.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTDataCache : NSObject

//通过单例实现缓存的操作
//缓存的意思：通过在沙盒建立临时的文件，达到保存数据的目的
//作用：一些在很短时间内重复请求的数据 可以通过缓存进行临时的保存，这样可以减少频繁的请求数据，节省流量

@property (nonatomic,assign) NSTimeInterval validTime;//有效的时间
//步骤：1.建立单例
+(id)sharedInstance;
//2.保存文件
-(void)saveData:(NSDictionary *)dataDic path:(NSString *)pathString;

//3.读取文件

-(NSDictionary *)getDataWithPath:(NSString *)pathString;

@end
