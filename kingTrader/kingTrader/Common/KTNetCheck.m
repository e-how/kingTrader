//
//  KTNetCheck.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/17.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTNetCheck.h"

@implementation KTNetCheck
/**
 *  网络是否可用
 */
+ (BOOL)isReachable {
    if ([[self class] getNetWorkStatus] == NotReachable) {
        return NO;
    }
    return YES;
    
}
// 是否wifi
+ (BOOL) isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

// 网络状态
+ (NetworkStatus)getNetWorkStatus
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [r currentReachabilityStatus];
}

+ (NSString *)getNetWorkStatusString
{
    NSString *info = @"";
    switch ([self getNetWorkStatus]) {
        case ReachableViaWWAN:
            info = @"2G/3G/4g";
            break;
            
        case ReachableViaWiFi:
            info = @"WiFi";
            break;
        case NotReachable:
            info = @"未连接";
            break;
        default:
            info = @"未知";
            break;
    }
    
    return info;
}



@end
