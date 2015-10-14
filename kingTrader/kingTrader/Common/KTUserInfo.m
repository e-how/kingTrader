//
//  KTUserInfo.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/9.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTUserInfo.h"
#import "myStocksDB.h"

#define KTUserDefault [NSUserDefaults standardUserDefaults]
@implementation KTUserInfo

static KTUserInfo *sharedUserInfo = nil;
+ (instancetype)sharedUserInfo{
    
    if (sharedUserInfo == nil) {
        sharedUserInfo = [[KTUserInfo alloc] init];
    }
    return sharedUserInfo;
}
+ (void)doLoginWithUserInfo:(NSDictionary*)userDic{
    sharedUserInfo.isLogin = YES;
    [self setUserId:[userDic objectForKey:@"uid"]];
    [self setUserToken:[userDic objectForKey:@"token"]];
    [self setUserName:[userDic objectForKey:@"nickname"]];
    [self setUserAvatar:[userDic objectForKey:@"avatar"]];
}
+ (void)doLogout{
    
    sharedUserInfo.isLogin = NO;
    [self setUserId:@""];
    [self setUserName:@""];
    [self setUserToken:@""];
    [self setUserAvatar:@""];
    // 清除自选股
    [myStocksDB cleanAll];
}

+ (NSString *)getUserId{
    return [KTUserDefault objectForKey:@"uid"];
}
+ (void)setUserId:(NSString *)uid{
    [KTUserDefault setObject:uid forKey:@"uid"];
}

+ (NSString *)getUserToken{
    return [KTUserDefault objectForKey:@"token"];

}
+ (void)setUserToken:(NSString *)token{
    [KTUserDefault setObject:token forKey:@"token"];

}

+ (NSString *)getUserName{
    return [KTUserDefault objectForKey:@"name"];

}
+ (void)setUserName:(NSString *)name{
    [KTUserDefault setObject:name forKey:@"name"];

}

+ (NSString *)getUserAvatar{
    return [KTUserDefault objectForKey:@"avater"];

}
+ (void)setUserAvatar:(NSString *)avater{
    [KTUserDefault setObject:avater forKey:@"avater"];

}


@end
