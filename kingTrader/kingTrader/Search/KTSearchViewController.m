//
//  KTSearchViewController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/10.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTSearchViewController.h"

@interface KTSearchViewController ()

@end

@implementation KTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"股票搜索";
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 20)];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn setTitleColor:KTNavTextColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(disView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    self.navigationItem.leftBarButtonItem = leftBtn;

}
- (void)disView{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



@end
