//
//  LTTimeLineView.h
//  xuangu
//
//  Created by weisd on 14-8-4.
//  Copyright (c) 2014年 liangtou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chart.h"

@interface LTTimeLineView : UIView

@property (nonatomic, strong) Chart *mainChart;
@property (nonatomic, strong) UIView *sellBox;
@property (nonatomic, assign) BOOL isShowTips;
@property (nonatomic, assign) BOOL isIndexStock;
@property (nonatomic, assign) BOOL hostBu;
@property (nonatomic, assign) BOOL isFuture;

@property (nonatomic,assign)CGRect chartFrame;




- (instancetype)initWithFrame:(CGRect)frame WithShelTips:(BOOL)isTips;
- (instancetype)initWithFrame:(CGRect)frame WithShelTips:(BOOL)isTips IsIndex:(BOOL)isdex IsHost:(BOOL)host;
- (instancetype)initWithFrame:(CGRect)frame WithShelTips:(BOOL)isTips IsIndex:(BOOL)isdex IsHost:(BOOL)host isFuture:(BOOL)Future;
// 添加chart
-(void)initChart:(CGRect) frame;
// 买卖盘
-(void)initShellTops:(CGRect) frame;
// 显示
-(void)getLTdata:(NSString *) code;

-(void)updateSellTips:(NSDictionary *) data;


-(void)setSelectEnable:(BOOL)ok;

@end
