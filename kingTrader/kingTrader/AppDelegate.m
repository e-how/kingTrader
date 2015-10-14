//
//  AppDelegate.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "AppDelegate.h"
#import "KTTabBarController.h"
#import "DBManager.h"
#import "KTLeftViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
/**
 *  创建根视图控制器
 */
- (void)createRootViewController{
    
    // 状态栏显示白色 配合info.plist View controller-based status bar appearance NO
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //tabbar 控制器
    KTTabBarController* ktTabBarController = [[KTTabBarController alloc] init];
    KTLeftViewController* leftVC = [[KTLeftViewController alloc] init];
    
    //侧滑菜单
    RESideMenu* sidemenuVC = [[RESideMenu alloc] initWithContentViewController:ktTabBarController leftMenuViewController:leftVC rightMenuViewController:nil];
    sidemenuVC.backgroundImage = [UIImage imageNamed:@"Stars"];
    sidemenuVC.menuPreferredStatusBarStyle = 1;
    sidemenuVC.delegate = self;
    sidemenuVC.contentViewShadowColor = [UIColor blackColor];
    sidemenuVC.contentViewShadowOffset = CGSizeMake(0, 0);
    sidemenuVC.contentViewShadowOpacity = 0.6;
    sidemenuVC.contentViewShadowRadius = 12;
    sidemenuVC.contentViewShadowEnabled = YES;
    sidemenuVC.panGestureEnabled = YES;
    
    self.window.rootViewController = sidemenuVC;
    
    [self.window makeKeyAndVisible];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 更新数据库
    [DBManager initDB];
    
    //创建根视图
    [self createRootViewController];

    
    [self performSelector:@selector(reloadCurrentPage) withObject:nil afterDelay:3.f];

    return YES;
    
}
- (void)reloadCurrentPage{
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCurrentPage" object:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
