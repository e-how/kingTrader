//
//  KTMyStocksController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTMyStocksController.h"
#import "KTSettingController.h"
#import "KTTabBarButton.h"
#import "LTTimeLineView.h"
#import "KTStockDetailViewController.h"
#import "KTScrollViewController.h"
#import "MJRefresh.h"
#import "KTNavigationController.h"
#import "KTSearchViewController.h"
#import "SINavigationMenuView.h"

@interface KTMyStocksController ()<SINavigationMenuDelegate>
{
    SINavigationMenuView *menu;
    NSMutableArray* menuTitles;
}
@property (nonatomic,strong)NSMutableArray* codeArray;
@end

@implementation KTMyStocksController

- (void)initData{
    
    self.codeArray = [NSMutableArray array];
    [self.codeArray addObject:@"sh600600"];
    [self.codeArray addObject:@"zjif1510"];
    [self.codeArray addObject:@"sh600601"];
    [self.codeArray addObject:@"023117"];
    [self.codeArray addObject:@"sh000001"];
    [self.codeArray addObject:@"sh600330"];
    [self.codeArray addObject:@"sh600650"];
    [self.codeArray addObject:@"sh600350"];
    [self.codeArray addObject:@"sh600660"];
    [self.codeArray addObject:@"sh600360"];
    [self.codeArray addObject:@"sh600680"];
    [self.codeArray addObject:@"sh600399"];
    
    menuTitles = [NSMutableArray array];
    [menuTitles addObject:@"自选"];
    [menuTitles addObject:@"分组"];
    [menuTitles addObject:@"编辑自选板块"];

}
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
   
    [self configUI];
    
}

- (void)configUI{

    [self setupNav];
    
    [self setupMenu];
    
}

/**
 *  导航栏
 */
- (void)setupNav{
    //返回左侧视图按钮
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 23, 22);
    [leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"板块编辑left.png"] forState:UIControlStateNormal];
    UIBarButtonItem* leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    //搜索
    myButton *rightBtn = [myButton buttonWithFrame: CGRectMake(0, 0, 41/2*1.3, 36/2*1.3) font:0 title:nil type:0 backgroundImage:@"板块编辑midsearch.png" image:nil andBlock:^(myButton *button) {
        
        KTSearchViewController *vc = [[KTSearchViewController alloc] init];
        KTNavigationController *navView = [[KTNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navView animated:YES completion:nil];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

}
- (void)setupMenu{
    //分组名称
    
    if (self.navigationItem) {
        
        CGRect frame = CGRectMake(0.0, 0.0, self.navigationController.navigationBar.bounds.size.width/2, self.navigationController.navigationBar.bounds.size.height);
        
        menu = [SINavigationMenuView sharedMenuWithFrame:frame];
        
        [menu displayMenuInView:self.view];
        menu.delegate = self;
        self.navigationItem.titleView = menu;
        menu.items = menuTitles;
        [menu.table setContentWithItems:menuTitles];
        
    }
    if ([KTUserInfo sharedUserInfo].isLogin) {
        
        [menuTitles removeAllObjects];
        [menuTitles addObject:@"自选"];
        [menuTitles addObject:@"  编辑自选板块"];
        menu.items = menuTitles;
        [menu.table setContentWithItems:menuTitles];
        
        [menuTitles removeAllObjects];
        menu.menuButton.title.text = @"自选";
        
    }
    
}
#pragma mark - 自动刷新
- (void)reloadCurrentPage{
    [super reloadCurrentPage];
    if (![[KTRefresh sharedRefresh] isRefreshTime]) {
        return;
    }
    KTLog(@"自选股");
}

#pragma mark-导航栏按钮代理

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    
    if(index == menu.items.count - 1){
     
    }else{
        //请求分组的数据
        menu.menuButton.title.text = [menu.items objectAtIndex:index];
 
    }
    
}
#pragma tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.codeArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"myCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [self.codeArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KTScrollViewController* mainVC = [[KTScrollViewController alloc] init];
    mainVC.codeArray = self.codeArray;
    mainVC.currentPage = indexPath.row;
    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
