//
//  KTStockDetailViewController.h
//  kingTrader
//
//  Created by 张益豪 on 15/9/8.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTRootViewController.h"

@interface KTStockDetailViewController : KTRootViewController

@property (nonatomic,strong) void(^title)(NSString* myTet);

@property (nonatomic,strong)NSMutableArray* codeArray;
@property (nonatomic,copy)NSString* code;
@property (nonatomic,strong)UIViewController* superVC;

- (void)reloadCurrentPage;

@end
