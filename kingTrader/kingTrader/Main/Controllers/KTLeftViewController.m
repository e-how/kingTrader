//
//  KTLeftViewController.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/10.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTLeftViewController.h"

@interface KTLeftViewController ()
{
    UIButton* btn;
}
@end

@implementation KTLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self login];
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(10, 100, 100, 100)];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)login{
    NSString* loginURL = [NSString stringWithFormat:@"http://api.ktkt.com/v1/user/login"];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"15003125615" forKey:@"name"];
    [params setObject:@"123456" forKey:@"pass"];
    [params setObject:@"mobile" forKey:@"origin"];
    
    [KTNetManager postWithKTKTURL:loginURL params:params success:^(id json) {
        if (json) {
            [KTUserInfo doLoginWithUserInfo:json];
            KTLog(@"login==%@",[KTUserInfo getUserId]);
            
            [self refreshButton];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)refreshButton{
    
    if ([KTUserInfo sharedUserInfo].isLogin) {
        
        [btn setTitle:@"logout" forState:UIControlStateNormal];
        [btn removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [btn setTitle:@"login" forState:UIControlStateNormal];
        [btn removeTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)logout{
    [KTUserInfo doLogout];
    KTLog(@"login==%@",[KTUserInfo getUserId]);
    
    [self refreshButton];
}


@end
