//
//  LTHistoryLineView.m
//  xuangu
//
//  Created by weisd on 14-8-29.
//  Copyright (c) 2014年 liangtou. All rights reserved.
//

#import "LTHistoryLineView.h"
//#import "SVProgressHUD.h"
//#import "MBProgressHUD+Utility.h"

@implementation LTHistoryLineView

@synthesize mainChart;
@synthesize showType;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initChart:frame];
        
    }
    return self;
}


-(void)setSelectEnable:(BOOL)ok
{
    self.mainChart.enableSelection = ok;
}

-(void)initChart:(CGRect)frame
{
    self.mainChart = [[Chart alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.mainChart.enableSelection = NO;
  
    
       // 设置边框
    NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"0", @"10", @"10", @"0", nil];
    [mainChart setPadding:padding];
    
    // 添加section // 显示比例
    NSMutableArray  *ratios = [[NSMutableArray alloc] init];
    [ratios addObject:@"4"];
    [ratios addObject:@"1"];
   
    // 添加2个section
    [mainChart addSections:2 withRatios:ratios];
    // y轴横线
    [[[mainChart sections] objectAtIndex:0] addYAxis:0];
    [[[mainChart sections] objectAtIndex:1] addYAxis:0];
    
    [mainChart getYAxis:0 withIndex:0].ext = 0.;  // 扩展，上下加多少
    
    // 初始化2个series
    NSMutableArray *series = [[NSMutableArray alloc] init];
    NSMutableArray *secOne = [[NSMutableArray alloc] init];
    NSMutableArray *secTwo = [[NSMutableArray alloc] init];
    
    //price 属性设置
    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [serie setObject:@"price" forKey:@"name"];
    [serie setObject:@"Price" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"candle" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
//    [serie setObject:@"249,222,170" forKey:@"color"];
    [serie setObject:@"251,0,0" forKey:@"color"];
    [serie setObject:@"8,150,8" forKey:@"negativeColor"];
    [serie setObject:@"251,0,0" forKey:@"selectedColor"];
    [serie setObject:@"8,150,8" forKey:@"negativeSelectedColor"];
    [serie setObject:@"251,0,0" forKey:@"labelColor"];
    [serie setObject:@"8,150,8" forKey:@"labelNegativeColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA10
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma5" forKey:@"name"];
    [serie setObject:@"MA5" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"0,52,107" forKey:@"color"];
    [serie setObject:@"0,52,107" forKey:@"negativeColor"];
    [serie setObject:@"0,52,107" forKey:@"selectedColor"];
    [serie setObject:@"0,52,107" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];

    
    //MA30
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma10" forKey:@"name"];
    [serie setObject:@"MA10" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"13,176,210" forKey:@"color"];
    [serie setObject:@"13,176,210" forKey:@"negativeColor"];
    [serie setObject:@"13,176,210" forKey:@"selectedColor"];
    [serie setObject:@"13,176,210" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA60
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ma20" forKey:@"name"];
    [serie setObject:@"MA20" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"234,2,94" forKey:@"color"];
    [serie setObject:@"234,2,94" forKey:@"negativeColor"];
    [serie setObject:@"234,2,94" forKey:@"selectedColor"];
    [serie setObject:@"234,2,94" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //VOL
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"vol" forKey:@"name"];
    [serie setObject:@"VOL" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"column" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:@"0" forKey:@"decimal"];
    [serie setObject:@"251,0,0" forKey:@"color"];
    [serie setObject:@"8,150,8" forKey:@"negativeColor"];
    [serie setObject:@"251,0,0" forKey:@"selectedColor"];
    [serie setObject:@"8,150,8" forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secTwo addObject:serie];
    
    //candleChart init 设置series
    [self.mainChart setSeries:series];
    [[[mainChart sections] objectAtIndex:0] setSeries:secOne];
    [[[mainChart sections] objectAtIndex:1] setSeries:secTwo];
    
    [[mainChart getSection:1] setPaddingTop:10];
    
   
}

#pragma mark 得到数据
-(void)getLTdata:(NSString *) code
{
    KTLog(@"%@",showType);
 
    if (!showType) {
        return;
    }
    
    
    NSString *reqURL = [[NSString alloc] initWithFormat:@"%@/stock/quotation_data", DEV_URL];
    
    NSDictionary *params = @{@"code":code, @"type":showType};

    [KTNetManager postWithURL:reqURL params:params success:^(id json) {
        
        if (!json) {
            KTLog(@"没有返回，或返回错误");
            
            return;
        }
        
        if ([[json objectAtIndex:0] count]) {
            NSMutableArray *data =[[NSMutableArray alloc] init];
            NSMutableArray *category =[[NSMutableArray alloc] init];
            
            NSInteger linesCount = [json count];
            for (NSInteger i = 0; i < linesCount; i++){
                NSDictionary *line = [json objectAtIndex:i];
                
                [category addObject:[line objectForKey:@"date"]]; // 时间
                
                NSMutableArray *item = [[NSMutableArray alloc] init];
                [item addObject:[line objectForKey:@"open"]];  // 1 开盘
                [item addObject:[line objectForKey:@"close"]];   // 4 收盘
                [item addObject:[line objectForKey:@"high"]];  // 2 最高
                [item addObject:[line objectForKey:@"low"]];    // 3 最低
                [item addObject:[line objectForKey:@"vol"]];   // 5 成交量
                [data addObject:item];
            }
            
            if ([data count] == 0) {
                KTLog(@"没数据");
                
                return;
            }
            
            // KTLog(@"日线数据    %@",category);
            [self addSubview:self.mainChart];
            
            [mainChart reset];
            [mainChart clearData];  // 清除data
            [mainChart clearCategory];
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [self generateSecData:dic From:data];
            [self setSecData:dic];
            
            //  设置显示分类
            NSMutableArray *cate = [[NSMutableArray alloc] init];
            for(int i=0;i<category.count;i++){
                [cate addObject:[category objectAtIndex:i]];
            }
            [self setCategory:cate];
            
            [mainChart setNeedsDisplay];
            
        }
    } failure:^(NSError *error) {
        
    } ];
    
}


-(void)generateSecData:(NSMutableDictionary *) dic From:(NSMutableArray *) data
{
    // price
    NSMutableArray *price = [[NSMutableArray alloc] init];
    // vol
    NSMutableArray *vol = [[NSMutableArray alloc] init];
   
    for (int i=0; i<data.count; i++) {
        // price
        [price addObject:[data objectAtIndex:i]];
        // vol
        NSMutableArray *volItems = [[NSMutableArray alloc] init];
        [volItems addObject: [[data objectAtIndex:i] objectAtIndex:4]];
        [volItems addObject:[[data objectAtIndex:i] objectAtIndex:0]];
        [volItems addObject:[[data objectAtIndex:i] objectAtIndex:1]];
        [vol addObject:volItems];
        
    }

    [dic setObject:price forKey:@"price"];
    [dic setValue:vol forKey:@"vol"];
    
    //MA 5
    NSMutableArray *ma5 = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        
        float val = 0;
        if (i<5) {
            for (int j=i; j>=0; j--) {
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/(i+1);
        } else {
            for (int j=i; j>i-5; j--) {
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/5;
        }
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma5 addObject:item];
    }
    [dic setObject:ma5 forKey:@"ma5"];
    //MA 10
    NSMutableArray *ma10 = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        
        float val = 0;
        if (i<10) {
            for (int j=i; j>=0; j--) {
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/(i+1);
        } else {
            for (int j=i; j>i-10; j--) {
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/10;
        }
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma10 addObject:item];
    }
    [dic setObject:ma10 forKey:@"ma10"];
    
    //MA 20
    NSMutableArray *ma20 = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        
        float val = 0;
        if (i<20) {
            for (int j=i; j>=0; j--) {
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/(i+1);
        } else {
            for (int j=i; j>i-20; j--) {
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/20;
        }
        
        NSMutableArray *item = [[NSMutableArray alloc] init];
        [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
        [ma20 addObject:item];
    }
    [dic setObject:ma20 forKey:@"ma20"];
    

}

-(void)setSecData:(NSMutableDictionary *)dic
{
    [self.mainChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
    [self.mainChart appendToData:[dic objectForKey:@"vol"] forName:@"vol"];
    
    [self.mainChart appendToData:[dic objectForKey:@"ma5"] forName:@"ma5"];
    [self.mainChart appendToData:[dic objectForKey:@"ma10"] forName:@"ma10"];
    [self.mainChart appendToData:[dic objectForKey:@"ma20"] forName:@"ma20"];
}


-(void)setCategory:(NSArray *)category{
    [self.mainChart appendToCategory:category forName:@"price"];
    [self.mainChart appendToCategory:category forName:@"line"];
}


@end
