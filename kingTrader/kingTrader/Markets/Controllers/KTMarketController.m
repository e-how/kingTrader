//
//  KTMarketController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTMarketController.h"
#import "KTUpingModel.h"
#import "MJExtension.h"
#import "KTScrollViewController.h"

@interface KTMarketController ()

@property (nonatomic,strong) NSMutableArray* dataArray;

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
    
    [self loadData];
}
- (void)initData{
    [super initData];
    
    self.dataArray = [NSMutableArray array];
}
- (void)loadData{
    
  
    NSDictionary *params = @{@"category":@"000000", @"type":@"1", @"limit":@"20"};
    NSString* urlString = [NSString stringWithFormat:@"%@/block/rise_decline_list",LTAPI];
    
    [KTNetManager postWithURL:urlString params:params success:^(id json) {
        
        self.dataArray = [KTUpingModel objectArrayWithKeyValuesArray:json];
       
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
   
}
#pragma mark - 自动刷新
- (void)reloadCurrentPage{
    [super reloadCurrentPage];
    if (![[KTRefresh sharedRefresh] isRefreshTime]) {
        return;
    }
    KTLog(@"行情");
}

#pragma mark- tableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"upingCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    KTUpingModel* model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.code;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KTScrollViewController* mainVC = [[KTScrollViewController alloc] init];
    
    mainVC.codeArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.dataArray.count; i++) {
        
        KTUpingModel* model = [self.dataArray objectAtIndex:i];
        
        [mainVC.codeArray addObject:model.code];
    }
    
    mainVC.currentPage = indexPath.row;
    [self.navigationController pushViewController:mainVC animated:YES];
}


@end
