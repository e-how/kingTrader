//
//  KTTabBarController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTTabBarController.h"
#import "KTNavigationController.h"
#import "KTMyStocksController.h"
#import "KTMarketController.h"
#import "KTBlocksController.h"
#import "KTSettingController.h"
#import "KTTabBar.h"
@interface KTTabBarController ()<KTTabBarDelegate>

@property (nonatomic,weak)KTTabBar* customTabBar;

@end

@implementation KTTabBarController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBar];
    
    [self setUpAllChildrenControllers];

}

- (void)setTabBar{
    
    KTTabBar* customTabbar = [[KTTabBar alloc] init];
    customTabbar.frame = self.tabBar.bounds;
    customTabbar.delegate = self;
    [self.tabBar addSubview:customTabbar];
    self.customTabBar = customTabbar;
}
- (void)tabBar:(KTTabBar *)tabBar dicSelectedBtnFrom:(int)from to:(int)to{
    self.selectedIndex = to;
}
- (void)setUpAllChildrenControllers{
    
    KTMyStocksController* myStockVC = [[KTMyStocksController alloc] init];
    KTMarketController* marketVC = [[KTMarketController alloc] init];
    KTBlocksController* blockVC = [[KTBlocksController alloc] init];
    KTSettingController* settingVC = [[KTSettingController alloc] init];
    
    [self setupChildViewController:myStockVC title:@"自选" imageName:@"自选默认-1" selectedImageName:@"自选当前-1"];
    [self setupChildViewController:marketVC title:@"行情" imageName:@"行情默认-1" selectedImageName:@"行情当前-1"];
    [self setupChildViewController:blockVC title:@"板块" imageName:@"板块默认-1" selectedImageName:@"板块当前-1"];
    [self setupChildViewController:settingVC title:@"设置" imageName:@"设置默认-1" selectedImageName:@"设置当前-1"];


}
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
   
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    // 2.包装一个导航控制器
    KTNavigationController *nav = [[KTNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}
@end
