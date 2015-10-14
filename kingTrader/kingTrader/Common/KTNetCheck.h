//
//  KTNetCheck.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/17.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>

@interface KTNetCheck : NSObject

+ (BOOL)isReachable;
+ (BOOL)isEnableWIFI;
+ (BOOL)isEnable3G;
+ (NetworkStatus)getNetWorkStatus;
+ (NSString *)getNetWorkStatusString;
@end
