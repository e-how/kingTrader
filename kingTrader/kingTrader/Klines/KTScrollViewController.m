//
//  KTScrollViewController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTScrollViewController.h"
#import "DMLazyScrollView.h"
#import "KTStockDetailViewController.h"
#import "StockType.h"
#define ARC4RANDOM_MAX	0x100000000
//可以避免循环引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

@interface KTScrollViewController ()<DMLazyScrollViewDelegate>{
    DMLazyScrollView* lazyScrollView;
    NSMutableArray*    viewControllerArray;
}

@end


@implementation KTScrollViewController

@synthesize currentPage;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    // PREPARE PAGES

    [self configTitle];
    
    [self createScrollView];
    
}
/**
 *  设置title
 */
- (void)configTitle{
    
    if ([StockType isFuturesOfCode:[self.codeArray objectAtIndex:currentPage]]) {
        self.title = [self.codeArray objectAtIndex:currentPage];
        
    }else{
        self.title = [NSString stringWithFormat:@"%@(%@)",[self.codeArray objectAtIndex:currentPage],[self.codeArray objectAtIndex:currentPage]];
        
    }
}
- (void)createScrollView{
    
    NSUInteger numberOfPages = self.codeArray.count;
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        [viewControllerArray addObject:[NSNull null]];
    }
    
    // PREPARE LAZY VIEW
    CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:rect];
    lazyScrollView.controlDelegate = self;
    WS(ws);
    lazyScrollView.dataSource = ^(NSUInteger index) {
        return [ws controllerAtIndex:index];
    };
    lazyScrollView.numberOfPages = numberOfPages;
    //当前界面
    lazyScrollView.currentPage = self.currentPage;
    // lazyScrollView.controlDelegate = self;
    [self.view addSubview:lazyScrollView];
}

- (KTStockDetailViewController *) controllerAtIndex:(NSInteger) index {
    if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {
        KTStockDetailViewController *contr = [[KTStockDetailViewController alloc] init];
        contr.code = [self.codeArray objectAtIndex:index];
        contr.superVC = self;
        [viewControllerArray replaceObjectAtIndex:index withObject:contr];
        return contr;
    }
    return res;
}
/**
 *  刷新当前
 */
- (void)reloadCurrentPage{
    
    [(KTStockDetailViewController*)lazyScrollView.dataSource(currentPage) reloadCurrentPage];
}

#pragma mark-delegate

- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex{
    
    currentPage = pageIndex;
    [self configTitle];//改变title
    //刷新当前页面
    [(KTStockDetailViewController*)lazyScrollView.dataSource(pageIndex) reloadCurrentPage];

}


@end
