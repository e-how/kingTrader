//
//  KTBlocksController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTBlocksController.h"
#import "AFNetworking.h"
#import "kingTrader-Swift.h"
#import "kingTrader-Bridging-Header.h"
#import "KTRefresh.h"
@interface KTBlocksController ()

@property (nonatomic,copy)NSString* loaddate;

@end

@implementation KTBlocksController

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
    
    [self loadData];
    // Do any additional setup after loading the view.
}

#pragma mark - 自动刷新
- (void)loadData{
    
   
    NSString* seceretString = [NSString stringWithFormat:
                               @"Bearer %@",
                               [[[JWTEncodeTests alloc]init] testEncodingJWT:
                                [KTRefresh getExpTime]]];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.requestSerializer setValue:seceretString forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:@"da" forHTTPHeaderField:@"client-id"];
    
    // 2.发送请求
    [mgr GET:@"http://192.168.0.33:1323/jwt/info" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"id=%@",responseObject);
         self.loaddate = [responseObject objectForKey:@"name"];
         [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error=%@",error.localizedDescription);
     }];

}
- (void)reloadCurrentPage{
    [super reloadCurrentPage];
    if (![[KTRefresh sharedRefresh] isRefreshTime]) {
        return;
    }
    KTLog(@"板块");
}

#pragma mark-table view delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"up";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.loaddate;
    
    return cell;
}



@end
