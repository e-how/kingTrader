//
//  KTSettingInfo.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/9.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTSettingInfo : NSObject

+ (void)setVoiceOn;
+ (BOOL)isVoiceOn;

+ (void)setVibrateOn;
+ (void)isVibrateOn;

+ (void)setRefreshTime;

+ (void)setNineOn;
+ (BOOL)isNineOn;


@end
