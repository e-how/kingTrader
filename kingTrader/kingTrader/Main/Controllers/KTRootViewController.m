//
//  KTRootViewController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTRootViewController.h"

@interface KTRootViewController ()

@end

@implementation KTRootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];

    [self configBasicSetting];
    
    [self autoRefresh];
    
    [self createTableView];

    
}
- (void)configBasicSetting{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
}
- (void)initData{
   // timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(reloadCurrentPage) userInfo:nil repeats:YES];
}
- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //为tableview 添加下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadCurrentPage)];
    
}
#pragma mark-刷新

- (void)refreshView{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    [self.tableView reloadData];
}

- (void)autoRefresh{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCurrentPage) name:@"reloadCurrentPage" object:nil];
   
    
}
- (void)reloadCurrentPage{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    [self.tableView reloadData];
    if (![[KTRefresh sharedRefresh] isRefreshTime]) {
        return;
    }
}


#pragma mark-table view delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


@end
