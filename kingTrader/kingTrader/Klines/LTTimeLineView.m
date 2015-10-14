//
//  LTTimeLineView.m
//  xuangu
//
//  Created by weisd on 14-8-4.
//  Copyright (c) 2014年 liangtou. All rights reserved.
//

#import "LTTimeLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZHHControll.h"

@implementation LTTimeLineView
{
    int count;
    int range;
}
@synthesize mainChart;
@synthesize sellBox;
@synthesize isShowTips;
@synthesize isIndexStock;
@synthesize isFuture;

- (instancetype)initWithFrame:(CGRect)frame WithShelTips:(BOOL)isTips {
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowTips = isTips;
        count =0;
       
        [self initChart:frame];
        [self initShellTops:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithShelTips:(BOOL)isTips IsIndex:(BOOL)isdex IsHost:(BOOL)host {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isIndexStock = isdex;
        self.isShowTips = isTips;
        self.chartFrame = frame;
        self.hostBu = host;
        count = 0;
        [self initShellTops:frame];
        [self initChart:frame];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame WithShelTips:(BOOL)isTips IsIndex:(BOOL)isdex IsHost:(BOOL)host isFuture:(BOOL)Future{
    self = [super initWithFrame:frame];
    if (self) {
        self.isIndexStock = isdex;
        self.isShowTips = isTips;
        self.chartFrame = frame;
        self.hostBu = host;
        self.isFuture = Future;
        count = 0;
        [self initShellTops:frame];
        [self initChart:frame];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initChart:frame];
         count =0;
        [self initShellTops:frame];
        
    }
    return self;
}

-(void)setSelectEnable:(BOOL)ok
{
    self.mainChart.enableSelection = ok;
}

#pragma mark 添加chart
// 添加chart
-(void)initChart:(CGRect) frame
{
    float wperset = 1;
    if (isShowTips) {
        wperset = 0.75;
    }
    self.mainChart = [[Chart alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*wperset, frame.size.height)];
    self.mainChart.enableSelection = NO;
    
    // 设置边框
    NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"0", @"10", @"10", @"0", nil];
    [mainChart setPadding:padding];
    
    // 添加section // 显示比例
    NSMutableArray  *ratios = [[NSMutableArray alloc] init];
    [ratios addObject:@"4"];
    [ratios addObject:@"1"];
    
    // 添加2个section
    if (self.hostBu) {
         [mainChart addSections:1 withRatios:ratios];
    }else{
         [mainChart addSections:2 withRatios:ratios];
    }
   
    
    
    // y轴横线
    [[[mainChart sections] objectAtIndex:0] addYAxis:0];
    
    if (!self.hostBu) {
         [[[mainChart sections] objectAtIndex:1] addYAxis:0];
    }
   
    
    // x轴竖线
    [[[mainChart sections] objectAtIndex:0] addXAxis:0];
    
    [mainChart getYAxis:0 withIndex:0].ext = 0.;  // 扩展，上下加多少
    [mainChart getYAxis:0 withIndex:0].baseValueSticky = YES;
    [mainChart getYAxis:0 withIndex:0].symmetrical = YES;   // 对称
    
    // 初始化2个series
    NSMutableArray *series = [[NSMutableArray alloc] init];
    NSMutableArray *secOne = [[NSMutableArray alloc] init];
    NSMutableArray *secTwo = [[NSMutableArray alloc] init];
  
   
   
    //price 属性设置
    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [serie setObject:@"price" forKey:@"name"];
    [serie setObject:@"PRICE" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"time" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"xAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"249,222,170" forKey:@"color"];
    [serie setObject:@"249,0,0" forKey:@"negativeColor"];
    [serie setObject:@"249,222,170" forKey:@"selectedColor"];
    [serie setObject:@"249,222,170" forKey:@"negativeSelectedColor"];
    [serie setObject:@"176,52,52" forKey:@"labelColor"];
    [serie setObject:@"77,143,42" forKey:@"labelNegativeColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA10
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"fold" forKey:@"name"];
    [serie setObject:@"FOLD" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"xAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"255,0,0" forKey:@"color"];
    [serie setObject:@"255,255,255" forKey:@"negativeColor"];
    [serie setObject:@"255,255,255" forKey:@"selectedColor"];
    [serie setObject:@"255,255,255" forKey:@"negativeSelectedColor"];
    if (!self.isIndexStock) {
        [series addObject:serie];
        [secOne addObject:serie];
    }
    
    //VOL
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"vol" forKey:@"name"];
    [serie setObject:@"VOL" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"vol" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"xAxis"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:@"0" forKey:@"decimal"];
    [serie setObject:@"176,52,52" forKey:@"color"];
    [serie setObject:@"77,143,42" forKey:@"negativeColor"];
    [serie setObject:@"176,52,52" forKey:@"selectedColor"];
    [serie setObject:@"77,143,42" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secTwo addObject:serie];
    
    // 把所有series加入chart中
    [mainChart setSeries:series];
   
    [[[mainChart sections] objectAtIndex:0] setSeries:secOne];
    
    
    if (!self.hostBu) {
        
        [[[mainChart sections] objectAtIndex:1] setSeries:secTwo];
        [[mainChart getSection:1] setPaddingTop:10];
 
    }
    
}


#pragma mark 获取数据
-(void)getLTdata:(NSString *) code
{
    NSString *reqURL = [[NSString alloc] initWithFormat:@"http://api.liangtou.com/stock/realtime?code=%@",code];
 
    [KTNetManager postWithURL:reqURL params:nil success:^(id json) {
        if (json) {
            if (self.isFuture) {

                if ([json isKindOfClass:[NSDictionary class]]) {
                    if ([json objectForKey:@"count"]) {
                        range = [[json objectForKey:@"count"] intValue];
                        json = [json objectForKey:@"record"];
                    }
                }else{
                    
                }
                
            }
            
        }
        
        NSMutableArray *res = (NSMutableArray *)json;

        [self addSubview:self.mainChart];
        [self draw:res];
        
    } failure:^(NSError *error) {
       
    }];
  
}


//画线
-(void)draw:(NSMutableArray *)res{

    if (self.hostBu == YES) {
        mainChart.hostBan = YES;
    }else{
        mainChart.hostBan = NO;
    }
    if (self.isFuture == YES) {
        mainChart.isFuture = YES;
        mainChart.rangeTo = range;
        mainChart.range = range;
    }else{
        mainChart.isFuture = NO;
    }
    NSMutableArray *data =[[NSMutableArray alloc] init];

    
    [res enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          NSMutableArray *item = [[NSMutableArray alloc] init];
        if ([[(NSDictionary*)obj allKeys] containsObject:@"value"] ) {
            [item addObject:[obj objectForKey:@"value"]];  // 0 价格
            //[line objectForKey:@"vol"] 为负数可能导致成交量K线图出问题
            
            [item addObject:[obj objectForKey:@"vol"]];    // 1 交易量
            [item addObject:[obj objectForKey:@"date"]];   // 2 时间
            [item addObject:[obj objectForKey:@"fold"]]; // 3 均价
            if ([[obj objectForKey:@"vol"] floatValue] >= 0) {
                [data addObject:item];
                
            }
        }
        

        
    }];
    
    if ([res count] == 0) {
        
        return;
    }
    
    [mainChart reset];
    [mainChart clearData];  // 清除data
    [mainChart clearCategory];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [self generateSecData:dic From:data];
    
    [self setSecData:dic];
    
    
    [self setSecCategory];  //  设置显示分类
    
    [mainChart setNeedsDisplay];
    
    
}
/**
判断是不是全为0
 */
-(BOOL)isZero:(NSMutableArray *)arr{
    for (NSString  *a in arr) {
        if([a intValue] != 0) {
            return NO;
        }
    }
    return YES;
}
#pragma mark 分时线

-(void)generateSecData:(NSMutableDictionary *) dic From:(NSMutableArray *) data
{
    // 分时线
    NSInteger total = [data count];
    
    NSMutableArray *prices = [[NSMutableArray alloc] init];
    NSMutableArray *volumes = [[NSMutableArray alloc] init];
    NSMutableArray *avg = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i < total; i++) {
        [prices addObject:[data objectAtIndex:i]];
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[NSString stringWithFormat:@"%f", [[[data objectAtIndex:i] objectAtIndex:1] floatValue]]];
        [volumes addObject:item];
        
        // 均线数据
        NSMutableArray *item2 = [[NSMutableArray alloc] init];
        [item2 addObject:[[data objectAtIndex:i] objectAtIndex:3]];
        [avg addObject:item2];
    }
    
    [dic setObject:prices forKey:@"price"];
    [dic setObject:volumes forKey:@"vol"];
    [dic setObject:avg forKey:@"fold"];
    
    // 均线
    
}

// 分时显示的分类
-(void)setSecCategory
{
    // 240分钟
    NSMutableArray *showTimes = [[NSMutableArray alloc] init];
    // todo 从9点半开始
    for (int h = 9; h <= 15; h++){
        if (h > 11 && h< 13) {
            // 11~13休市
            h = 13;
        }
    
        NSString *item = nil;
        for (int m=0; m<61; m++) {
             item = [NSString stringWithFormat:@"%02d:%02d", h, m];
            
            [showTimes addObject:item];
        }
    }
    
    [mainChart appendToCategory:showTimes forName:@"price"];
    [mainChart appendToCategory:showTimes forName:@"vol"];
    [mainChart appendToCategory:showTimes forName:@"fold"];
}

-(void)setSecData:(NSMutableDictionary *)dic
{
    [mainChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
    [mainChart appendToData:[dic objectForKey:@"vol"] forName:@"vol"];
    [mainChart appendToData:[dic objectForKey:@"fold"] forName:@"fold"];
    
}

#pragma mark 买卖盘
// 买卖盘
-(void)initShellTops:(CGRect) frame
{
    if (!isShowTips) {
        return;
    }
    
    sellBox = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width*0.75+3, 0, frame.size.width*0.25+10, frame.size.height)];
    // 定长的，用xib添加
    [[sellBox layer] setBorderWidth:0];
    [[sellBox layer] setBorderColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor];
    // 加边框
    [self addSubview:sellBox];
}

-(void)updateSellTips:(NSDictionary *) data
{
    // 清除记录
    [self clearSellTips];
    //竖线
    UILabel *vLine = [[UILabel alloc]initWithFrame:CGRectMake(-1, 5, .5f, sellBox.frame.size.height-8)];
    vLine.backgroundColor = [UIColor colorWithRed:0.58f green:0.58f blue:0.58f alpha:1.00f];
    [sellBox addSubview:vLine];
    
    // 内字 买 卖
    UILabel *selbox = [UILabel labelWithFrame:CGRectMake(0, 0, sellBox.frame.size.width, sellBox.frame.size.height/2) title:@"卖" font:30];
    selbox.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    selbox.textAlignment = NSTextAlignmentCenter;
    [sellBox addSubview:selbox];
    
    UILabel *buybox = [UILabel labelWithFrame:CGRectMake(0, sellBox.frame.size.height/2, sellBox.frame.size.width, sellBox.frame.size.height/2) title:@"买" font:30];
    buybox.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    buybox.textAlignment = NSTextAlignmentCenter;
    [sellBox addSubview:buybox];
    
    // 5
    NSDictionary *s5 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQSJW5"], @"price", [data objectForKey:@"HQSSL5"], @"val", nil];
    NSDictionary *s4 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQSJW4"], @"price", [data objectForKey:@"HQSSL4"], @"val", nil];
    NSDictionary *s3 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQSJW3"], @"price", [data objectForKey:@"HQSSL3"], @"val", nil];
    NSDictionary *s2 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQSJW2"], @"price", [data objectForKey:@"HQSSL2"], @"val", nil];
    NSDictionary *s1 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQSJW1"], @"price", [data objectForKey:@"HQSSL1"], @"val", nil];
    NSArray *selePrices = [[NSArray alloc] initWithObjects:s5,s4,s3,s2,s1, nil];
    
    NSDictionary *b5 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQBJW5"], @"price", [data objectForKey:@"HQBSL5"], @"val", nil];
    NSDictionary *b4 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQBJW4"], @"price", [data objectForKey:@"HQBSL4"], @"val", nil];
    NSDictionary *b3 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQBJW3"], @"price", [data objectForKey:@"HQBSL3"], @"val", nil];
    NSDictionary *b2 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQBJW2"], @"price", [data objectForKey:@"HQBSL2"], @"val", nil];
    NSDictionary *b1 = [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"HQBJW1"], @"price", [data objectForKey:@"HQBSL1"], @"val", nil];
    NSArray *buyPrices = [[NSArray alloc] initWithObjects:b1,b2,b3,b4,b5, nil];
    
    
    // 卖盘
    UIView *saleSection = [[UIView alloc] initWithFrame:CGRectMake(4, 0, sellBox.frame.size.width - 4, sellBox.frame.size.height/2)];
    CGFloat lineHeight = saleSection.frame.size.height/6;
    saleSection.backgroundColor = [UIColor clearColor];
    CGFloat offsetHeight = lineHeight/2;
    int idx = 0;
    NSArray *array = @[@"①",@"②",@"③",@"④",@"⑤"];
    for (int i=5; i>=1; i--) {
        
        UIView *saleLine = [[UIView alloc] initWithFrame:CGRectMake(0, idx*lineHeight+offsetHeight, saleSection.frame.size.width, lineHeight)];
        // label
        UILabel *l = [UILabel labelWithFrame:CGRectMake(0, 0, saleSection.frame.size.width*0.15, lineHeight) title:[NSString stringWithFormat:@"%@",array[i-1]] font:10];
        l.textColor = [UIColor lightTextColor];
        [saleLine addSubview:l];
        
        // val  如果返回为空值
        NSString* sellVal = [NSString stringWithFormat:@"%.2f",[[[selePrices objectAtIndex:idx] objectForKey:@"price"] floatValue]];
        if ([sellVal isEqualToString:@""]) {
           sellVal = @"0";
        }
        UILabel *v = [UILabel labelWithFrame:CGRectMake(l.frame.size.width, 0, saleSection.frame.size.width*0.45-6, lineHeight) title:sellVal font:10];
        v.textColor = [UIColor lightTextColor];
        [saleLine addSubview:v];
        
        // num
        NSString *vol = [[selePrices objectAtIndex:idx] objectForKey:@"val"];
        UILabel *n = [UILabel labelWithFrame:CGRectMake(v.frame.size.width+v.frame.origin.x+5, 0, saleSection.frame.size.width*0.4, lineHeight) title:[NSString stringWithFormat:@"%d", [vol intValue]/100] font:10];
        n.textColor = [UIColor lightTextColor];
        n.textAlignment = NSTextAlignmentLeft;
        [saleLine addSubview:n];
        [saleSection addSubview:saleLine];
        idx ++;
    }
    [sellBox addSubview:saleSection];
    
    // 中间线
    UILabel *middleLine = [[UILabel alloc] initWithFrame:CGRectMake(3, (idx+1)*lineHeight, sellBox.frame.size.width, 0.5)];
    [middleLine setBackgroundColor:[UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f]];
    [sellBox addSubview:middleLine];
    
    // 买盘
    UIView *buySection = [[UIView alloc] initWithFrame:CGRectMake(4, saleSection.frame.origin.y+saleSection.frame.size.height, sellBox.frame.size.width - 4, sellBox.frame.size.height/2)];
    buySection.backgroundColor = [UIColor clearColor];
    idx = 0;
    for (int i=1; i<=5; i++) {
        
        UIView *saleLine = [[UIView alloc] initWithFrame:CGRectMake(0, idx*lineHeight+offsetHeight, saleSection.frame.size.width, lineHeight)];
        // label
        UILabel *l = [UILabel labelWithFrame:CGRectMake(0, 0, saleSection.frame.size.width*0.15, lineHeight) title:[NSString stringWithFormat:@"%@", array[i-1]] font:10];
        l.textColor = [UIColor lightTextColor];
        [saleLine addSubview:l];
        
        // val
        NSString* buyVal = [NSString stringWithFormat:@"%.2f",[[[buyPrices objectAtIndex:idx] objectForKey:@"price"] floatValue]];
        if ([buyVal isEqualToString:@""]) {
            buyVal = @"0";
        }
        UILabel *v = [UILabel labelWithFrame:CGRectMake(l.frame.size.width, 0, saleSection.frame.size.width*0.45-6, lineHeight) title:buyVal font:10];
        v.textColor = [UIColor lightTextColor];
        [saleLine addSubview:v];
        
        // num
        NSString *vol = [[buyPrices objectAtIndex:idx] objectForKey:@"val"];
        UILabel *n = [UILabel labelWithFrame:CGRectMake(v.frame.size.width+v.frame.origin.x+5, 0, saleSection.frame.size.width*0.4, lineHeight) title:[NSString stringWithFormat:@"%d", [vol intValue]/100] font:10];
        n.textColor = [UIColor lightTextColor];
        n.textAlignment = NSTextAlignmentLeft;
        [saleLine addSubview:n];
        
        [buySection addSubview:saleLine];
        idx ++;
    }
    [sellBox addSubview:buySection];
}

-(void)clearSellTips
{
    for (UIView *view in [sellBox subviews]) {
        [view removeFromSuperview];
    }
}

@end
