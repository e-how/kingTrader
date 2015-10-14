//
//  KTTabBar.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTTabBar;

@protocol KTTabBarDelegate <NSObject>

- (void)tabBar:(KTTabBar*)tabBar dicSelectedBtnFrom:(int)from to:(int)to;

@end

@interface KTTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem*) item;

@property (nonatomic,weak) id<KTTabBarDelegate> delegate;

@end
