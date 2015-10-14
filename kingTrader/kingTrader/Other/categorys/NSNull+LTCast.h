//
//  NSNull+LTCast.h
//  xuangu
//
//  Created by 张益豪 on 15/8/4.
//  Copyright (c) 2015年 liangtou. All rights reserved.
//  判空处理 如果为null类型 返回默认值

#import <Foundation/Foundation.h>

@interface NSNull (LTCast)

- (float)floatValue;

- (int)intValue;

@end
