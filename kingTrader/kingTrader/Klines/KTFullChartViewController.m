//
//  KTFullChartViewController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/18.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTFullChartViewController.h"
#import "StockType.h"
#import "LTTimeLineView.h"
#import "KTExpandButton.h"
@interface KTFullChartViewController ()
{
    LTTimeLineView* fullkline;
}
@end

@implementation KTFullChartViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self transformScreen];
    [self selectKindOfStock:self.code];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createUI];
    

}
/**
 *  转换屏幕方向
 */
- (void)transformScreen{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:YES];
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(M_PI*(90)/180.0);
    
    self.view.bounds = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    [UIView commitAnimations];
}
- (void)createUI{
    
    self.view.backgroundColor = [UIColor blackColor];
    [self createTitleView];
    
    [self createCancelBtn];
    
}
- (void)createTitleView{
    
}
- (void)createCancelBtn{
    
    // 关闭按钮
    KTExpandButton *closeBtn = [[KTExpandButton alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 30, 12, 20, 20)];
    [closeBtn setImage:[UIImage imageNamed:@"单项删除未选中"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"单项删除选中状态"] forState:(UIControlStateSelected)];
    [closeBtn addTarget:self action:@selector(disView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

-(void)disView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)addKLines{
    
    fullkline = [[LTTimeLineView alloc] initWithFrame:
             CGRectMake(0, 20, SCREEN_HEIGHT-30, SCREEN_WIDTH)
                                     WithShelTips:[StockType isNormalOfCode:self.code]
                                          IsIndex:[StockType isIndexOfCode:self.code]
                                           IsHost:[StockType isBlocksOfCode:self.code]
                                         isFuture:[StockType isFuturesOfCode:self.code]];
    [fullkline getLTdata:self.code];
    if ([StockType isNormalOfCode:self.code]) {
        [fullkline updateSellTips:nil];
    }
    [self.view addSubview:fullkline];
}


@end
