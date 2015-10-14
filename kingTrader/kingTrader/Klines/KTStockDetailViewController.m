//
//  KTStockDetailViewController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTStockDetailViewController.h"
#import "StockType.h"
#import "LTTimeLineView.h"
#import "KTFullChartViewController.h"
#import "KTRefresh.h"
#import "LTHistoryLineView.h"
@interface KTStockDetailViewController ()
{
    UIScrollView* containerView;
    UIView* klineContentView;
    LTTimeLineView* kline;
    LTHistoryLineView *dayLineView;
    LTHistoryLineView *weekLineView;
    LTHistoryLineView *monthLineView;
}
@end

@implementation KTStockDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //创建内容视图
    [self createContainerView];
    
    //根据股票代码 选择加载的视图
    [self selectKindOfStock:self.code];
    
    //集成刷新功能
    [self setupRefresh];
    
}
#pragma mark- 创建视图
/**
 *  创建containerView
 */
- (void)createContainerView{
    
    containerView = [[UIScrollView alloc] initWithFrame:
                     CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:containerView];

    //创建分时线
    [self createMinuteLines];
    
    // 股票和指数的历史k线
    if ([StockType isIndexOfCode:self.code] ||
        [StockType isNormalOfCode:self.code]) {
        
        [self createHistoryLines];
    }
    
}
/**
 *  创建分时线
 */
- (void)createMinuteLines{
    
    klineContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 180)];
    kline = [[LTTimeLineView alloc] initWithFrame:
             CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2.5)
                                     WithShelTips:[StockType isNormalOfCode:self.code]
                                          IsIndex:[StockType isIndexOfCode:self.code]
                                           IsHost:[StockType isBlocksOfCode:self.code]
                                         isFuture:[StockType isFuturesOfCode:self.code]];
    //初始化k线的买卖盘
    if ([StockType isNormalOfCode:self.code]) {
        [kline updateSellTips:nil];
    }
    [klineContentView addSubview:kline];
    [containerView addSubview:klineContentView];
    // 添加点击事件
    klineContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFullChart)];
    [klineContentView addGestureRecognizer:tapGesture];
}
/**
 *  创建历史k线
 */
- (void)createHistoryLines{
    //添加日线 周线 月线
    dayLineView = [[LTHistoryLineView alloc] initWithFrame:CGRectMake(0, 0, klineContentView.frame.size.width, klineContentView.frame.size.height)];
    dayLineView.showType = @"daily";
    dayLineView.hidden = YES;
    
    
    weekLineView = [[LTHistoryLineView alloc] initWithFrame:CGRectMake(0, 0, klineContentView.frame.size.width, klineContentView.frame.size.height)];
    weekLineView.showType = @"week";
    weekLineView.hidden = YES;
    
    monthLineView = [[LTHistoryLineView alloc] initWithFrame:CGRectMake(0, 0, klineContentView.frame.size.width, klineContentView.frame.size.height)];
    monthLineView.showType = @"month";
    [monthLineView getLTdata:self.code];
    monthLineView.hidden = YES;
    
    
    [klineContentView addSubview:dayLineView];
    [klineContentView addSubview:weekLineView];
    [klineContentView addSubview:monthLineView];
    

 
    //[containerView addSubview:klineContentView];
    
}
/**
 *  根据代码 选择加载的界面
 *
 */
- (void)selectKindOfStock:(NSString*)code{
    
    if ([StockType isFuturesOfCode:code]) {
        //股指期货
        [self loadFutureView];
        
    }else if ([StockType isIndexOfCode:code]){
        //大盘指数
        [self loadIndexView];

    }else if ([StockType isBlocksOfCode:code]){
        //热门板块
        [self loadBlockView];
        
    }else{
        //个股行情
        [self loadStockView];
    }
}
/**
 *  股指期货
 */
- (void)loadFutureView{
    KTLog(@"股指期货%@",self.code);
    [self addKLines];
}



/**
 *  大盘指数
 */
- (void)loadIndexView{
    KTLog(@"大盘指数%@",self.code);
    [self addKLines];
}



/**
 *  热门板块
 */
- (void)loadBlockView{
    KTLog(@"热门板块%@",self.code);
    [self addKLines];
}


/**
 *  个股行情
 */
- (void)loadStockView{
    KTLog(@"个股行情%@",self.code);
    [self addKLines];
}

//更新分时线
- (void)addKLines{
    KTLog(@"SELF.CODE=%@",self.code);
    [kline getLTdata:self.code];
    
    
    
}
//更新历史k线
-(void)chartDate{
    
    [dayLineView getLTdata:self.code];
    [weekLineView getLTdata:self.code];
    [monthLineView getLTdata:self.code];
    
}

#pragma mark-
#pragma mark- 刷新

- (void)setupRefresh{
    containerView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadCurrentPage)];
}
- (void)reloadCurrentPage{
    if ([containerView.header isRefreshing]) {
        [containerView.header endRefreshing];
    }
    if (![[KTRefresh sharedRefresh] isRefreshTime]) {
        return;
    }
    KTLog(@"股票详情");

    [self selectKindOfStock:self.code];
}
#pragma mark-全屏

- (void)showFullChart{
    
    KTFullChartViewController * fullVC = [[KTFullChartViewController alloc] init];
    fullVC.code = self.code;
    [self.superVC presentViewController:fullVC animated:YES completion:nil];
}

@end
