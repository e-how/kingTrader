//
//  KTConfigHeader.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//  配置文件

#ifndef kingTrader_KTConfigHeader_h
#define kingTrader_KTConfigHeader_h

//接口前缀
#define API_URL @"http://api.liangtou.com"
#define DEV_URL @"http://apit.liangtou.com"

#define APP_ID 870321383
#define APP_URL @"https://itunes.apple.com/us/app/liang-tou-xuan-gu-qi/id870321383?l=zh&ls=1&mt=8"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// grb
#define KTColor(r, g, b) [UIColor colorWithRed:\
    (r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 自定义Log
#ifdef DEBUG
#define KTLog(...) NSLog(__VA_ARGS__)
#else
#define KTLog(...)
#endif

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


//导航栏颜色
#define KTNavColor [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]//[UIColor colorWithHexString:@"0f323232"]
#define KTTabBarColor [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f]
//导航栏title 颜色
#define KTNavTextColor [UIColor colorWithHexString:@"0fedd296"]
//背景颜色
#define BGColor [UIColor colorWithRed:\
        0.00f green:0.00f blue:0.00f alpha:1.00f]
//涨跌颜色
#define KTRed [UIColor redColor]
#define KTGreen [UIColor grennColor]
#define KTGray [UIColor grayColor]

#endif
