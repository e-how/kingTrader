//
//  KTMarketController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTMarketController.h"

@interface KTMarketController ()

@end

@implementation KTMarketController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:[[KTRefresh sharedRefresh] getRefreshTime] target:self selector:@selector(reloadCurrentPage) userInfo:nil repeats:YES];
    [refreshTimer fire];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [refreshTimer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}
- (void)initData{
    [super initData];
}
#pragma mark - 自动刷新
- (void)reloadCurrentPage{
    [super reloadCurrentPage];
    if (![[KTRefresh sharedRefresh] isRefreshTime]) {
        return;
    }
    KTLog(@"行情");
}

@end
