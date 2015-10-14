//
//  DBManager.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface DBManager : NSObject

+(void)initDB;

+(FMDatabase *)GetDB;

+(void)dropDB;

@end
