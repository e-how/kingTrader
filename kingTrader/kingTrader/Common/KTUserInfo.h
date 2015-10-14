//
//  KTUserInfo.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/9.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTUserInfo : NSObject

@property (nonatomic,copy)NSString* username;
@property (nonatomic,copy)NSString* token;
@property (nonatomic,copy)NSString* avater;
@property (nonatomic,copy)NSString* uid;

@property (nonatomic,assign)BOOL isLogin;

+ (instancetype)sharedUserInfo;

+ (void)doLoginWithUserInfo:(NSDictionary*)userInfo;
+ (void)doLogout;
// 用户信息
+ (NSString *)getUserId;
+ (void)setUserId:(NSString *)uid;

+ (NSString *)getUserToken;
+ (void)setUserToken:(NSString *)token;

+ (NSString *)getUserName;
+ (void)setUserName:(NSString *)name;

+ (NSString *)getUserAvatar;
+ (void)setUserAvatar:(NSString *)avater;

@end
