//
//  Chart.m
//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import "Chart.h"

#define MIN_INTERVAL  3


@implementation Chart

@synthesize enableSelection;
@synthesize sliding;
@synthesize isInitialized;
@synthesize isSectionInitialized;
@synthesize borderColor;
@synthesize borderWidth;
@synthesize plotWidth;
@synthesize plotPadding;
@synthesize plotCount;
@synthesize paddingLeft;
@synthesize paddingRight;
@synthesize paddingTop;
@synthesize paddingBottom;
@synthesize padding;
@synthesize selectedIndex;
@synthesize touchFlag;
@synthesize touchFlagTwo;
@synthesize rangeFrom;
@synthesize rangeTo;
@synthesize range;  // 显示个数
@synthesize series;
@synthesize sections;
@synthesize ratios;
@synthesize models;
@synthesize title;
@synthesize hostBan;
@synthesize isFuture;


// 取第几个值对应的高度
-(float)getLocalY:(float)val withSection:(int)sectionIndex withAxis:(int)yAxisIndex{
    Section *sec = [[self sections] objectAtIndex:sectionIndex];
    YAxis *yaxis = [sec.yAxises objectAtIndex:yAxisIndex];
    CGRect fra = sec.frame;
    float  max = yaxis.max;
    float  min = yaxis.min;
    
    //    KTLog(@"lalalallala   %f,%f",max,min);
    if (max - min==0) {
        if (self.hostBan) {
            return fra.size.height -(fra.size.height-sec.paddingTop) + fra.origin.y;
        }else if (self.isFuture){
            return -40.;
        }
        else{
            return -40.;
        }
        
    }
    
    return fra.size.height - (fra.size.height-sec.paddingTop)* (val-min)/(max-min)+fra.origin.y;
    
}

// 初始化chart
- (void)initChart{
    if(!self.isInitialized){
        self.plotPadding = 1.0f;
        // 设置边距
        
      		if(self.padding != nil){
                self.paddingTop    = [[self.padding objectAtIndex:0] floatValue];
                self.paddingRight  = [[self.padding objectAtIndex:1] floatValue];
                self.paddingBottom = [[self.padding objectAtIndex:2] floatValue];
                self.paddingLeft   = [[self.padding objectAtIndex:3] floatValue];
            }
        //        int dataCount = 0;
        // 设置数据显示区间
        if(self.series!=nil){
            
            BOOL isTimeChart = [[[[self series] objectAtIndex:0] objectForKey:@"type"] isEqualToString:@"time"] || [[[[self series] objectAtIndex:0] objectForKey:@"type"] isEqualToString:@"vol"];
            
            // 显示 最大区间 = data数量
            int dataCount = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
            
            // 如果是time类型，固定显示240天
            if (isTimeChart) {
                if (self.isFuture) {

                }else{
                    self.rangeTo = 243;
                    self.range = 243;
                }
                //                self.range = 60;
                
            } else {
                if (dataCount < 60) {
                    self.rangeTo = 60;
                }else{
                    
                     self.rangeTo = dataCount;
                }
               
                self.range = 60;
            }
            // 如果数据大于显示区间大小， 开始位
            if(rangeTo-range > 0){
                self.rangeFrom = rangeTo-range;
            }else{
                //fix
                self.rangeFrom = 1;
            }
        }else{
            self.rangeTo   = 0;
            self.rangeFrom = 0;
        }
        self.selectedIndex = self.rangeTo -1;
        self.isInitialized = YES;
    }
    
    if(self.series!=nil){
        self.plotCount = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect (context, CGRectMake (0, 0, self.bounds.size.width,self.bounds.size.height));
    
    
}

-(void)reset{
    self.isInitialized = NO;
}

// 初始化竖线
- (void)initXAxis{
    
    //    return;
    //    // weisd 先初始化
    //    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
    //        Section *sec = [self.sections objectAtIndex:secIndex];
    //        for(int sIndex=0;sIndex<[sec.xAxises count];sIndex++){
    //            XAxis *xaxis = [sec.xAxises objectAtIndex:sIndex];
    //            xaxis.isUsed = NO;
    //        }
    //    }
    //
    //    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
    //        Section *sec = [self.sections objectAtIndex:secIndex];
    //        // weisd add 不显示空数
    //        if ([[sec series] count] < 1) {
    //            continue;
    //        }
    //
    //        id serie = [[sec series] objectAtIndex:sec.selectedIndex];
    //
    //        [self setValueForXAxis:serie];
    //
    //
    //        for(int i = 0;i<sec.xAxises.count;i++){
    //            XAxis *xaxis = [sec.xAxises objectAtIndex:i];
    //            NSLog(@"xxxxx \n %@", xaxis.indexs);
    //        }
    //    }
}


-(void)setValueForXAxis:(NSDictionary *)serie
{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    if ([type isEqualToString:@"time"]) {
        [model setValuesForXAxis:self serie:serie];
    }
}

// 初始化横线 设置 baseValue max min
- (void)initYAxis{
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        for(int sIndex=0;sIndex<[sec.yAxises count];sIndex++){
            YAxis *yaxis = [sec.yAxises objectAtIndex:sIndex];
            yaxis.isUsed = NO;
        }
    }
    
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        // weisd add 不显示空数
        if ([[sec series] count] < 1) {
            continue;
        }
        
        // 设置 最大值，最小值
        if(sec.paging){
            // 分页
            id serie = [[sec series] objectAtIndex:sec.selectedIndex];
            if([serie isKindOfClass:[NSArray class]]){
                for(int i=0;i<[serie count];i++){
                    [self setValuesForYAxis:[serie objectAtIndex:i]];
                }
            }else {
                [self setValuesForYAxis:serie];
            }
        }else{
            for(int sIndex=0;sIndex<[sec.series count];sIndex++){
                id serie = [[sec series] objectAtIndex:sIndex];
                if([serie isKindOfClass:[NSArray class]]){
                    for(int i=0;i<[serie count];i++){
                        [self setValuesForYAxis:[serie objectAtIndex:i]];
                    }
                }else {
                    [self setValuesForYAxis:serie];
                }
            }
        }
        
        for(int i = 0;i<sec.yAxises.count;i++){
            YAxis *yaxis = [sec.yAxises objectAtIndex:i];
            // ext
            //            NSLog(@"xxxxxxxxxx 一样 %f, %f, %f", yaxis.max, yaxis.min, yaxis.baseValue);
            // weisd fix 最高价跟最低价一样时，出错
            float offs = (yaxis.max-yaxis.min);
            if ( offs == 0) {
                //                NSLog(@"min max 一样 %f, %f", yaxis.max, yaxis.min);
                yaxis.max += yaxis.max *0.1;
                yaxis.min -= yaxis.min *0.1;
            } else {
                
                yaxis.max += (yaxis.max-yaxis.min)*yaxis.ext;
                yaxis.min -= (yaxis.max-yaxis.min)*yaxis.ext;
            }
            
            // 设置baseValue
            if(!yaxis.baseValueSticky){
                
                if(yaxis.max >= 0 && yaxis.min >= 0){
                    yaxis.baseValue = yaxis.min;
                }else if(yaxis.max < 0 && yaxis.min < 0){
                    yaxis.baseValue = yaxis.max;
                }else{
                    yaxis.baseValue = 0;
                }
            }else{
                // 置顶 baseValue为最大值
                if(yaxis.baseValue < yaxis.min){
                    yaxis.min = yaxis.baseValue;
                }
                
                if(yaxis.baseValue > yaxis.max){
                    yaxis.max = yaxis.baseValue;
                }
            }
            // 对称
            if(yaxis.symmetrical == YES){
                if(yaxis.baseValue > yaxis.max){
                    yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
                }else if(yaxis.baseValue < yaxis.min){
                    yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
                }else {
                    if((yaxis.max-yaxis.baseValue) > (yaxis.baseValue-yaxis.min)){
                        yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
//                       yaxis.baseValue = yaxis.max;
                    }else{
                        
                        yaxis.max = yaxis.baseValue + (yaxis.baseValue-yaxis.min);
                        if (yaxis.max == yaxis.min ) {
                            yaxis.max = -yaxis.min;
                            yaxis.baseValue = 0;
                        }
                    }
                    
                    
                }
            }
        }
    }
}

// 设置Y轴的值
-(void)setValuesForYAxis:(NSDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setValuesForYAxis:self serie:serie];
}

// setNeedDisplay 调用这个方法
-(void)drawChart{
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
//        KTLog(@"rangeFrom   %d",self.rangeFrom);
        
     plotWidth = (sec.frame.size.width-sec.paddingLeft)/(self.rangeTo-self.rangeFrom);
        
       
        
        
        for(int sIndex=0;sIndex<sec.series.count;sIndex++){
            
            id serie = [sec.series objectAtIndex:sIndex];
            
            if(sec.hidden){
                continue;
            }
            
            if(sec.paging){
                
                if (sec.selectedIndex == sIndex) {
                    if([serie isKindOfClass:[NSArray class]]){
                        for(int i=0;i<[serie count];i++){
                            [self drawSerie:[serie objectAtIndex:i]];
                        }
                    }else{
                        [self drawSerie:serie];
                    }
                    break;
                }
            }else{
                if([serie isKindOfClass:[NSArray class]]){
                    
                    for(int i=0;i<[serie count];i++){
                        [self drawSerie:[serie objectAtIndex:i]];
                    }
                }else{
                    [self drawSerie:serie];
                }
            }
        }
    }
    if (self.enableSelection) {
        [self drawLabels];
    }
}

// 写文本值
-(void)drawLabels{
    for(int i=0;i<self.sections.count;i++){
        Section *sec = [self.sections objectAtIndex:i];
        if(sec.hidden){
            continue;
        }
        
        float w = 0;
        float w2 = 80;
        for(int s=0;s<sec.series.count;s++){
            NSMutableArray *label =[[NSMutableArray alloc] init];
            id serie = [sec.series objectAtIndex:s];
            
            if(sec.paging){
                if (sec.selectedIndex == s) {
                    if([serie isKindOfClass:[NSArray class]]){
                        for(int i=0;i<[serie count];i++){
                            [self setLabel:label forSerie:[serie objectAtIndex:i]];
                        }
                    }else{
                        [self setLabel:label forSerie:serie];
                    }
                }
            }else{
                if([serie isKindOfClass:[NSArray class]]){
                    for(int i=0;i<[serie count];i++){
                        [self setLabel:label forSerie:[serie objectAtIndex:i]];
                    }
                }else{
                    [self setLabel:label forSerie:serie];
                }
            }
            // label字体
            CGFloat drawY = sec.frame.origin.y;
            CGFloat baseY = drawY;  // 从最顶上开始
            
            for(int j=0;j<label.count;j++){
                if (s == 0) {
                    //  第一个serie 就是价格
                    NSMutableDictionary *lbl = [label objectAtIndex:j];
                    NSString *text  = [lbl objectForKey:@"text"];
                    NSString *color = [lbl objectForKey:@"color"];
                    NSArray *colors = [color componentsSeparatedByString:@","];
                    // 开始 写
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSetShouldAntialias(context, YES);
                    CGContextSetRGBFillColor(context, [[colors objectAtIndex:0] floatValue], [[colors objectAtIndex:1] floatValue], [[colors objectAtIndex:2] floatValue], 1.0);
                    
                    [text drawAtPoint:CGPointMake(sec.frame.origin.x+sec.paddingLeft+2+w,drawY) withFont:[UIFont systemFontOfSize: 10]];
                    w += [text sizeWithFont:[UIFont systemFontOfSize:10]].width+10;
                } else {
                    // 其他画在section底部
                    drawY = baseY + sec.frame.size.height;
                    NSMutableDictionary *lbl = [label objectAtIndex:j];
                    NSString *text  = [lbl objectForKey:@"text"];
                    NSString *color = [lbl objectForKey:@"color"];
                    NSArray *colors = [color componentsSeparatedByString:@","];
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSetShouldAntialias(context, YES);
                    CGContextSetRGBFillColor(context, [[colors objectAtIndex:0] floatValue], [[colors objectAtIndex:1] floatValue], [[colors objectAtIndex:2] floatValue], 1.0);
                    
                    [text drawAtPoint:CGPointMake(sec.frame.origin.x+sec.paddingLeft+2+w2,drawY) withFont:[UIFont systemFontOfSize: 10]];
                    w2 += [text sizeWithFont:[UIFont systemFontOfSize:10]].width+10;
                }
                
            }
        }
    }
}

// 配置文本值
-(void)setLabel:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    if ([type isEqualToString:@"time"] || [type isEqualToString:@"vol"] || [[serie objectForKey:@"name"] isEqualToString:@"fold"]) {
        return;
    }
    [model setLabel:self label:label forSerie:serie];
}

// 画数据
-(void)drawSerie:(NSMutableDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    
    ChartModel *model = [self getModel:type];
    [model drawSerie:self serie:serie];
    
    // 移动竖线上的提示信息
    NSEnumerator *enumerator = [self.models keyEnumerator];
    
    id key;
    while ((key = [enumerator nextObject])){
        ChartModel *m = [self.models objectForKey:key];
        [m drawTips:self serie:serie];
    }
}

// 选中信息
-(void)drawSelected
{
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        plotWidth = (sec.frame.size.width-sec.paddingLeft)/(self.rangeTo-self.rangeFrom);
        for(int sIndex=0;sIndex<sec.series.count;sIndex++){
            
            id serie = [sec.series objectAtIndex:sIndex];
            
            if(sec.hidden){
                continue;
            }
            
            if(sec.paging){
                
                if (sec.selectedIndex == sIndex) {
                    if([serie isKindOfClass:[NSArray class]]){
                        for(int i=0;i<[serie count];i++){
                            [self drawSelected:[serie objectAtIndex:i]];
                        }
                    }else{
                        [self drawSelected:serie];
                    }
                    break;
                }
            }else{
                if([serie isKindOfClass:[NSArray class]]){
                    
                    for(int i=0;i<[serie count];i++){
                        [self drawSelected:[serie objectAtIndex:i]];
                    }
                }else{
                    [self drawSelected:serie];
                }
            }
        }
    }
}

-(void)drawSelected:(NSMutableDictionary *) serie
{
    NSString   *type  = [serie objectForKey:@"type"];
    if ([type isEqualToString:@"time"] || [type isEqualToString:@"candle"]) {
        ChartModel *model = [self getModel:type];
        [model drawSelected:self serie:serie];
    }
    
}

// section 中间虚线 Y轴 横线
-(void)drawYAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO );
    CGContextSetLineWidth(context, 0.3f);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f].CGColor);
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        // section 下面的线
        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
        
        
        // section 上面的线
        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
        CGContextStrokePath(context);
        
    }
    
    
    //
    //    // 外框线 竖线
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
        CGContextMoveToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
        CGContextStrokePath(context);
    }
    
    
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        // 内虚线
        for(int aIndex=0;aIndex<sec.yAxises.count;aIndex++){
            YAxis *yaxis = [sec.yAxises objectAtIndex:aIndex];
            NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
            
            float baseY = [self getLocalY:yaxis.baseValue withSection:secIndex withAxis:aIndex];
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f].CGColor);
            if (isnan(baseY)){
                baseY=0;
            }
            CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
            if(!isnan(baseY)){
                CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft, baseY);
            }
            
            /**
             *  中间的虚线
             */
            
            
            CGFloat lengths[] = {2,1};
            CGContextSetLineDash(context, 0, lengths, 2);
            
            /**
             *  当最大值与最小值相等的时候
             */
            if (self.hostBan) {
                if (yaxis.max - yaxis.min == 0) {
                    
                    CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,self.frame.size.height/1.95);
                    if(!isnan(baseY)){
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,self.frame.size.height/1.95);
                    }
                    
                    
                }
                
            }
            
            
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f].CGColor);
            CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
            if(!isnan(baseY)){
                CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,baseY);
            }
            
            CGContextStrokePath(context);
            // 字体颜色 weisd
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            // UIFont  *font = [UIFont boldSystemFontOfSize:18.0];
            // 最下一行字
            // todo 根据字符长度改
            NSString *stepVal = [NSString stringWithFormat:format, yaxis.baseValue];
            CGSize valShowLen = [stepVal sizeWithFont:[UIFont systemFontOfSize:10]];
            
            CGFloat offset = sec.paddingLeft - valShowLen.width -2;
            if (offset < 0) {
                offset = 0;
            }
            CGContextSetShouldAntialias(context, YES);
            
            
            
            
            // 最下面那条线的值
            float vil = [[@"" stringByAppendingFormat:format,yaxis.baseValue]floatValue];
            
            if (vil >= 100000000) {
                NSString *st = [NSString stringWithFormat:@"%.2f亿",vil/100000000];
                //最底下的值
                
                [st drawAtPoint:CGPointMake(sec.frame.origin.x+offset,baseY-8) withFont:[UIFont systemFontOfSize: 10]];
            }else if (vil > 10000 && vil < 100000000 ) {
                NSString *st = [NSString stringWithFormat:@"%.2f万",vil/10000];
                //最底下的值
                [st drawAtPoint:CGPointMake(sec.frame.origin.x+offset,baseY-8) withFont:[UIFont systemFontOfSize: 10]];
            }
            else{
                if (self.hostBan) {
                    if (yaxis.max - yaxis.min == 0) {
                        
                        [[NSString stringWithFormat:@"%.2f",0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,self.frame.size.height/1.37-2) withFont:[UIFont systemFontOfSize: 10]];
                    }else{
                        [[@"" stringByAppendingFormat:format,yaxis.baseValue] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,baseY-8) withFont:[UIFont systemFontOfSize: 10]];
                        
                    }
                    
                }else{
                    [[@"" stringByAppendingFormat:format,yaxis.baseValue] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,baseY-8) withFont:[UIFont systemFontOfSize: 10]];
                    
                }
                
                
                
            }
            
            
            
            
            // 百分比 weisd
            if (secIndex == 0) {
                for (int ssIndex = 0; ssIndex < sec.series.count; ssIndex++) {
                    if ([[[sec.series objectAtIndex:ssIndex] objectForKey:@"type"] isEqualToString:@"time"]) {
                        float persentVal = 0.0;
                        if (!hostBan) {
                            [[NSString stringWithFormat:@"%.2f%%", persentVal] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - 25,baseY-8) withFont:[UIFont systemFontOfSize: 10]];
                        }
                        
                    }
                }
            }
            CGContextSetShouldAntialias(context, NO );
            
            
            if (yaxis.tickInterval%2 == 1) {
                yaxis.tickInterval +=1;
            }
            
            // 不是k线只显示2条线
            NSInteger lineCount;
            if (secIndex == 0) {
                lineCount = yaxis.tickInterval;
            } else {
                lineCount = 1;
            }
            
            
            
            float step = (float)(yaxis.max-yaxis.min)/lineCount;
            
            
            //for(int i=1; i<= yaxis.tickInterval+1;i++){
            for(int i=1; i<= lineCount;i++){
                NSString * aa = [NSString stringWithFormat:@"%.6f",(yaxis.baseValue + i*step)];
                NSString * bb = [NSString stringWithFormat:@"%.6f",yaxis.max];
//                KTLog(@"aa=%@  bb=%@",aa,bb);
                //  KTLog(@"qqqq  %f,%f，%i",yaxis.baseValue + i*step,yaxis.max,i);
                //zyh fix日线 周线  月线 无最大值
                if([aa floatValue] <= [bb floatValue]+0.00001){
                    float iy = [self getLocalY:(yaxis.baseValue + i*step) withSection:secIndex withAxis:aIndex];
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.31 green:0.31 blue:0.31 alpha:1.0].CGColor);
                    if(isnan(iy)){
                        iy = 0;
                    }
                    CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                    if(!isnan(iy)){
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                    }
                    CGContextStrokePath(context);
                    
                    // todo 根据字符长度改
                    NSString *stepVal = [NSString stringWithFormat:format, yaxis.baseValue+i*step];
                    CGSize valShowLen = [stepVal sizeWithFont:[UIFont systemFontOfSize:10]];
                    
                    CGFloat offset = sec.paddingLeft - valShowLen.width -2;
                    if (offset < 0) {
                        offset = 0;
                    }
                    CGContextSetShouldAntialias(context, YES );
                    // ok 最上面那条线的值
                    //                        KTLog(@"duduuudud  %i,%li",i,(long)lineCount);
                    if (i == lineCount) {
                        float arr = [[@"" stringByAppendingFormat:format,yaxis.baseValue+i*step]floatValue];
                        
 //                       KTLog(@"duduuudud  %f",arr);
                        
                        if (arr >= 100000000) {
                            NSString *str = [NSString stringWithFormat:@"%.2f亿",arr/100000000];
                            [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy) withFont:[UIFont systemFontOfSize: 10]];
                        }else if (arr > 10000 && arr < 100000000) {
                            NSString *str = [NSString stringWithFormat:@"%.2f万",arr/10000];
                            [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy) withFont:[UIFont systemFontOfSize: 10]];
                        }
                        else{
                            //成交量最大值
                            NSString *str = nil;
                            if (yaxis.baseValue >= 0) {
                                str = [NSString stringWithFormat:@"%.2f",arr];
                                if ([str isEqualToString:@"0.00"]) {
                                    if (!self.hostBan) {
                                          [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset-20,iy) withFont:[UIFont systemFontOfSize: 10]];
                                    }
                                  
                                }else{
                                    if (!self.hostBan) {
                                        [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy) withFont:[UIFont systemFontOfSize: 10]];
                                    }
                                    
                                }
                                
                            }else{
                                
                                if ([[NSString stringWithFormat:@"%.f",arr*100] floatValue] >10000) {
                                    str = [NSString stringWithFormat:@"%.2f万",arr*100/10000];
                                    [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset-5,iy) withFont:[UIFont systemFontOfSize: 10]];
                                }else{
                                    str = [NSString stringWithFormat:@"%.f",arr*100];
                                    [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset-10,iy) withFont:[UIFont systemFontOfSize: 10]];
                                }
                                
                            }
                            
                            
                        }
                        
                    } else {
                        //分时最上面两个值
                      //  KTLog(@"屏幕 宽度   %f",self.frame.size.height);
                        if (self.hostBan) {
                            if (yaxis.max - yaxis.min == 0) {
                                if (i == 1) {
                                    [[NSString stringWithFormat:@"%.2f",0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,self.frame.size.height/12.333-3) withFont:[UIFont systemFontOfSize: 10]];
                                }else if (i == 2){
                                    [[NSString stringWithFormat:@"%.2f",0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,self.frame.size.height/3-15) withFont:[UIFont systemFontOfSize: 10]];
                                }
                            }else{
                                [[@"" stringByAppendingFormat:format,yaxis.baseValue+i*step] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy-7) withFont:[UIFont systemFontOfSize: 10]];
                            }
                            
                        }else{
                            [[@"" stringByAppendingFormat:format,yaxis.baseValue+i*step] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy-7) withFont:[UIFont systemFontOfSize: 10]];
                        }
                        
                        
                    }
                    CGContextSetShouldAntialias(context, NO );
                    // 虚线横线
                    
                    /**
                     *  上面数第二个线
                     */
                 //   KTLog(@"%f",self.frame.size.height);
                    if (self.hostBan) {
                        if (yaxis.max - yaxis.min == 0) {
                            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.31 green:0.31 blue:0.31 alpha:1.0].CGColor);
                            CGFloat lengths[] = {2,1};
                            CGContextSetLineDash(context, 0, lengths, 2);
                            CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,self.frame.size.height/3-10);
                            CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,self.frame.size.height/3-10);
                        }
                    }
                    
                    if(yaxis.baseValue + i*step < yaxis.max){
                        CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.31 green:0.31 blue:0.31 alpha:1.0].CGColor);
                        CGFloat lengths[] = {2,1};
                        CGContextSetLineDash(context, 0, lengths, 2);
                        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
                        
                        
                        
                    }
                    
                    CGContextStrokePath(context);
                    
                    // 百分比 weisd
                    if (secIndex == 0) {
                        CGContextSetShouldAntialias(context, YES );
                        for (int ssIndex = 0; ssIndex < sec.series.count; ssIndex++) {
                            if ([[[sec.series objectAtIndex:ssIndex] objectForKey:@"type"] isEqualToString:@"time"]) {
                                
                                float persentVal = i*step/yaxis.baseValue*100;
                              //  KTLog(@"    %f,%f",i*step,yaxis.baseValue*100);
                                
                                
                                NSString *stepVal = [NSString stringWithFormat:format, persentVal];
                                
                                CGFloat valShowLen = [stepVal sizeWithFont:[UIFont systemFontOfSize:10]].width;
                                
                                if (i == lineCount) {
                                    if (![stepVal isEqualToString:@"inf"]&&!hostBan) {
                                        if (yaxis.min == 0.0) {
                                            [[NSString stringWithFormat:@"%.2f%%", 0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - 25,iy) withFont:[UIFont systemFontOfSize: 10]];
                                        }else{
                                            [[NSString stringWithFormat:@"%.2f%%", persentVal] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - valShowLen-10,iy) withFont:[UIFont systemFontOfSize: 10]];
                                        }
                                        
                                    }
                                    
                                } else {
                                    if (![stepVal isEqualToString:@"inf"]&&!hostBan) {
                                        if (yaxis.min == 0.0) {
                                            
                                            [[NSString stringWithFormat:@"%.2f%%", 0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - 25,iy-7) withFont:[UIFont systemFontOfSize: 10]];
                                        }else{
                                            [[NSString stringWithFormat:@"%.2f%%", persentVal] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - valShowLen-10,iy-7) withFont:[UIFont systemFontOfSize: 10]];
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                        CGContextSetShouldAntialias(context, NO );
                    }
                    
                }
            }
            
            // 对称线下面的线
            CGContextSetShouldAntialias(context, YES );
            for(int i=1; i <= 2;i++){
          
                
                NSString *asd = [NSString stringWithFormat:@"%f",(yaxis.baseValue - i*step)];
                NSString *awe = [NSString stringWithFormat:@"%f",yaxis.min];
                
                
                if([asd floatValue] >= [awe floatValue]){
                    float iy = [self getLocalY:(yaxis.baseValue - i*step) withSection:secIndex withAxis:aIndex];
                    
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.31 green:0.31 blue:0.31 alpha:1.0].CGColor);
                    if (isnan(iy)) {
                        iy = 0;
                    }
                    CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                    if(!isnan(iy)){
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                    }
                    CGContextStrokePath(context);
                    CGContextSetShouldAntialias(context, YES );
                    if (self.hostBan) {
                        if (yaxis.max - yaxis.min == 0) {
                            if (i == 1) {
                                [[NSString stringWithFormat:@"%.2f", 0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,self.frame.size.height/2-3) withFont:[UIFont systemFontOfSize: 10]];
                                
                            }else if (i == 2){
                                
                                [[NSString stringWithFormat:@"%.2f", 0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,self.frame.size.height/1.08) withFont:[UIFont systemFontOfSize: 10]];
                                
                            }
                        }else{
                            [[@"" stringByAppendingFormat:format,yaxis.baseValue-i*step] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy-12) withFont:[UIFont systemFontOfSize: 10]];
                            
                        }
                        
                    }else{
                        [[@"" stringByAppendingFormat:format,yaxis.baseValue-i*step] drawAtPoint:CGPointMake(sec.frame.origin.x+offset,iy-12) withFont:[UIFont systemFontOfSize: 10]];
                    }
                    
                    /**
                     *  倒数第二根线
                     */
                  //  KTLog(@"高度   %f",self.frame.size.height);
                    if (self.hostBan) {
                        if (yaxis.max - yaxis.min == 0) {
                            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.57f green:0.57f blue:0.57f alpha:1.00f].CGColor);
                            CGFloat lengths[] = {2,1};
                            CGContextSetLineDash(context, 0, lengths, 2);
                            CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,self.frame.size.height/1.34);
                            CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,self.frame.size.height/1.34);
                        }
                    }
                    
                    if(yaxis.baseValue - i*step > yaxis.min){
                        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.57f green:0.57f blue:0.57f alpha:1.00f].CGColor);
                        CGFloat lengths[] = {2,1};
                        CGContextSetLineDash(context, 0, lengths, 2);
                        CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
                        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
                    }
                    
                    CGContextStrokePath(context);
                    
                    // 百分比 weisd
                    if (secIndex == 0) {
                        CGContextSetShouldAntialias(context, YES );
                        for (int ssIndex = 0; ssIndex < sec.series.count; ssIndex++) {
                            if ([[[sec.series objectAtIndex:ssIndex] objectForKey:@"type"] isEqualToString:@"time"]) {
                                float persentVal = -i*step/yaxis.baseValue*100;
                                NSString *stepVal = [NSString stringWithFormat:format, persentVal];
                                
                                
                                CGFloat valShowLen = [stepVal sizeWithFont:[UIFont systemFontOfSize:10]].width;
                                if (![stepVal isEqualToString:@"-inf"]&&!hostBan) {
                                    if (yaxis.min == 0.0) {
                                        [[NSString stringWithFormat:@"%.2f%%", 0.0] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - 25,iy-12) withFont:[UIFont systemFontOfSize: 10]];
                                    }else{
                                        [[NSString stringWithFormat:@"%.2f%%", persentVal] drawAtPoint:CGPointMake(sec.frame.origin.x+sec.frame.size.width - valShowLen - 10,iy-12) withFont:[UIFont systemFontOfSize: 10]];
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        CGContextSetShouldAntialias(context, NO );
                    }
                }
            }
        }
    }
    
    CGContextSetLineDash (context,0,NULL,0);
}

// section X轴 竖线
-(void)drawXAxis{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 0.3f);
    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.31 green:0.31 blue:0.31 alpha:1.0].CGColor);
    
    // 外框线 竖线
    for(int secIndex=0;secIndex<[self.sections count];secIndex++){
        Section *sec = [self.sections objectAtIndex:secIndex];
        if(sec.hidden){
            continue;
        }
        CGFloat lengths[] = {2,1};
        CGContextSetLineDash(context, 0, lengths, 2);
        
        CGContextMoveToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
        CGContextStrokePath(context);
    }
    
    for(int i=0;i<self.series.count;i++){
        //        KTLog(@"气死我了       %@",[self.series objectAtIndex:i]);
        
        
        if([[self.series objectAtIndex:i] objectForKey:@"category"] != nil){
            [self setValueForXAxis:[self.series objectAtIndex:i]];
        }
        break;
    }
    
    
    //	for(int secIndex=0;secIndex<self.sections.count;secIndex++){
    //		Section *sec = [self.sections objectAtIndex:secIndex];
    //		if(sec.hidden){
    //			continue;
    //		}
    //        // section 下面的线
    //		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
    //		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
    //
    //        // 中间竖线
    //
    //
    //        // section 上面的线
    //		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
    //		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
    //	}
    //	CGContextStrokePath(context);
}

// 画数据
-(void)drawXAxis:(NSMutableDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    if (![type isEqualToString:@"time"]) {
        return;
    }
    ChartModel *model = [self getModel:type];
    [model drawXAxis:self serie:serie];
    
    
    //    // 移动竖线上的提示信息
    //    NSEnumerator *enumerator = [self.models keyEnumerator];
    //
    //    id key;
    //    while ((key = [enumerator nextObject])){
    //        ChartModel *m = [self.models objectForKey:key];
    //        [m drawTips:self serie:serie];
    //    }
}

// 通过位置设置选中顶
-(void) setSelectedIndexByPoint:(CGPoint) point{
    
    if([self getIndexOfSection:point] == -1){
        return;
    }
    Section *sec = [self.sections objectAtIndex:[self getIndexOfSection:point]];
    
    for(int i=self.rangeFrom;i<self.rangeTo;i++){
        if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<plotWidth*((i-self.rangeFrom)+1)){
            if (self.selectedIndex != i) {
                self.selectedIndex=i;
                [self setNeedsDisplay];
            }
            
            return;
        }
    }
}

// 添加数据到series
-(void)appendToData:(NSArray *)data forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"data"] == nil){
                NSMutableArray *tempData = [[NSMutableArray alloc] init];
                [[self.series objectAtIndex:i] setObject:tempData forKey:@"data"];
            }
            
            for(int j=0;j<data.count;j++){
                [[[self.series objectAtIndex:i] objectForKey:@"data"] addObject:[data objectAtIndex:j]];
            }
        }
    }
}

// 清除data
-(void)clearDataforName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"data"] != nil){
                [[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
            }
        }
    }
}

// 清除全部data
-(void)clearData{
    for(int i=0;i<self.series.count;i++){
        [[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
    }
}
// 设置data
-(void)setData:(NSMutableArray *)data forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            [[self.series objectAtIndex:i] setObject:data forKey:@"data"];
        }
    }
}
// 添加分类
-(void)appendToCategory:(NSArray *)category forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"category"] == nil){
                NSMutableArray *tempData = [[NSMutableArray alloc] init];
                [[self.series objectAtIndex:i] setObject:tempData forKey:@"category"];
            }
            for(int j=0;j<category.count;j++){
                [[[self.series objectAtIndex:i] objectForKey:@"category"] addObject:[category objectAtIndex:j]];
            }
        }
    }
}

-(void)clearCategoryforName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqual:name]){
            if([[self.series objectAtIndex:i] objectForKey:@"category"] != nil){
                [[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
            }
        }
    }
}

-(void)clearCategory{
    for(int i=0;i<self.series.count;i++){
        [[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
    }
}

-(void)setCategory:(NSMutableArray *)category forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            [[self.series objectAtIndex:i] setObject:category forKey:@"category"];
        }
    }
}

/*
 * Sections
 */
-(Section *)getSection:(int) index{
    
    return [self.sections objectAtIndex:index];
}

-(int)getIndexOfSection:(CGPoint) point{
    for(int i=0;i<self.sections.count;i++){
        Section *sec = [self.sections objectAtIndex:i];
        if (CGRectContainsPoint(sec.frame, point)){
            
            return i;
        }
    }
    return -1;
}

/*
 * series
 */
-(NSMutableDictionary *)getSerie:(NSString *)name{
    NSMutableDictionary *serie = nil;
    for(int i=0;i<self.series.count;i++){
        if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
            serie = [self.series objectAtIndex:i];
            break;
        }
    }
    return serie;
}

-(void)addSerie:(id)serie{
    if([serie isKindOfClass:[NSArray class]]){
        int section = 0;
        for (NSDictionary *ser in serie) {
            section = [[ser objectForKey:@"section"] intValue];
            [self.series addObject:ser];
        }
        [[[self.sections objectAtIndex:section] series] addObject:serie];
    }else{
        int section = [[serie objectForKey:@"section"] intValue];
        [self.series addObject:serie];
        [[[self.sections objectAtIndex:section] series] addObject:serie];
    }
}

/*
 *  Chart Sections
 */
-(void)addSection:(NSString *)ratio{
    Section *sec = [[Section alloc] init];
    [self.sections addObject:sec];
    [self.ratios addObject:ratio];
}

-(void)removeSection:(int)index{
    [self.sections removeObjectAtIndex:index];
    [self.ratios removeObjectAtIndex:index];
}

-(void)addSections:(int)num withRatios:(NSArray *)rats{
    for (int i=0; i< num; i++) {
        Section *sec = [[Section alloc] init];
        [self.sections addObject:sec];
        [self.ratios addObject:[rats objectAtIndex:i]];
    }
}

-(void)removeSections{
    [self.sections removeAllObjects];
    [self.ratios removeAllObjects];
}

// 画区域 sections
-(void)initSections{
    float height = self.frame.size.height-(self.paddingTop+self.paddingBottom);
    float width  = self.frame.size.width-(self.paddingLeft+self.paddingRight);
    
    int total = 0;
    for (int i=0; i< self.ratios.count; i++) {
        if([[self.sections objectAtIndex:i] hidden]){
            continue;
        }
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        total+=ratio;
    }
    
    Section *prevSec = nil;
    for (int i=0; i< self.sections.count; i++) {
        int ratio = [[self.ratios objectAtIndex:i] intValue];
        Section *sec = [self.sections objectAtIndex:i];
        if([sec hidden]){
            continue;
        }
        // 根据ratio算出高度比例
        float h = height*ratio/total;
        float w = width;
        
        if(i==0){
            [sec setFrame:CGRectMake(0+self.paddingLeft, 0+self.paddingTop, w,h)];
        }else{
            if(i==([self.sections count]-1)){
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,self.paddingTop+height-(prevSec.frame.origin.y+prevSec.frame.size.height))];
            }else {
                [sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,h)];
            }
        }
        prevSec = sec;
        
    }
    // 标记已初始化
    self.isSectionInitialized = YES;
}


-(YAxis *)getYAxis:(int) section withIndex:(int) index{
    Section *sec = [self.sections objectAtIndex:section];
    YAxis *yaxis = [sec.yAxises objectAtIndex:index];
    return yaxis;
}

/*
 * UIView Methods
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.enableSelection = YES;     // 是否可选中
        self.isInitialized   = NO;      // 是否已初始化
        self.isSectionInitialized   = NO;   // section是否已初始化
        self.selectedIndex   = -1;      // 选中位
        self.padding         = nil; // 放一个数组，上、右、下、左
        self.paddingTop      = 0;
        self.paddingRight    = 0;
        self.paddingBottom   = 0;
        self.paddingLeft     = 0;
        self.rangeFrom       = 0;
        self.rangeTo         = 0;
        self.range           = 120;   // 天数
        //        self.range           = 240;
        self.touchFlag       = 0;
        self.touchFlagTwo    = 0;
        NSMutableArray *rats = [[NSMutableArray alloc] init];
        self.ratios          = rats;
        
        NSMutableArray *secs = [[NSMutableArray alloc] init];
        self.sections        = secs;
        
        NSMutableDictionary *mods = [[NSMutableDictionary alloc] init];
        self.models        = mods;
        
        [self setMultipleTouchEnabled:YES];
        
        //init models
        [self initModels];
    }
    return self;
}

-(void)initModels{
    //line
    ChartModel *model = [[LineChartModel alloc] init];
    [self addModel:model withName:@"line"];
    
    //area
    model = [[AreaChartModel alloc] init];
    [self addModel:model withName:@"area"];
    
    //column
    model = [[ColumnChartModel alloc] init];
    [self addModel:model withName:@"column"];
    
    //candle
    model = [[CandleChartModel alloc] init];
    [self addModel:model withName:@"candle"];
    
    //candle
    model = [[TimeChartModel alloc] init];
    [self addModel:model withName:@"time"];
    
    //vol 只有值
    model = [[VolChartModel alloc] init];
    [self addModel:model withName:@"vol"];
    
}

-(void)addModel:(ChartModel *)model withName:(NSString *)name{
    [self.models setObject:model forKey:name];
}

-(ChartModel *)getModel:(NSString *)name{
    return [self.models objectForKey:name];
}

- (void)drawRect:(CGRect)rect {
    [self initChart];
    [self initSections];
    [self initXAxis];
    [self initYAxis];
    [self drawYAxis];
    [self drawChart];
    [self drawXAxis];
    [self drawSelected];
}

- (void)dealloc {

}

#pragma mark -触摸
// 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.enableSelection) {
        return;
    }
    NSArray *ts = [touches allObjects];
    self.touchFlag = 0;
    self.touchFlagTwo = 0;
    // 记录 选中的x/y
    if([ts count]==1){
        sliding = YES;
        UITouch* touch = [ts objectAtIndex:0];
        if([touch locationInView:self].x < 40){
            self.touchFlag = [touch locationInView:self].y;
        }
    }else if ([ts count]==2) {
        self.touchFlag = [[ts objectAtIndex:0] locationInView:self].x ;
        self.touchFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
    }
}

// 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //
    if (!self.enableSelection) {
        return;
    }
    
    NSArray *ts = [touches allObjects];
    if([ts count]==1){
        UITouch* touch = [ts objectAtIndex:0];
        
        // 选中的section
        int i = [self getIndexOfSection:[touch locationInView:self]];
        if(i!=-1){
            Section *sec = [self.sections objectAtIndex:i];
            // 点在section内部，设置选中项
            if([touch locationInView:self].x > sec.paddingLeft)
                [self setSelectedIndexByPoint:[touch locationInView:self]];
            int interval = 5;
            // 点在section左边
            if([touch locationInView:self].x < sec.paddingLeft){
                // 向下移动超过3格
                if(abs([touch locationInView:self].y - self.touchFlag) >= MIN_INTERVAL){
                    if([touch locationInView:self].y - self.touchFlag > 0){
                        // 总数据量大于显示的数据量
                        if(self.plotCount > (self.rangeTo-self.rangeFrom)){
                            // 总体左移5个
                            if(self.rangeFrom - interval >= 0){
                                self.rangeFrom -= interval;
                                self.rangeTo   -= interval;
                                if(self.selectedIndex >= self.rangeTo){
                                    self.selectedIndex = self.rangeTo-1;
                                }
                            }else {
                                self.rangeFrom = 1;
                                self.rangeTo  -= self.rangeFrom;
                                if(self.selectedIndex >= self.rangeTo){
                                    self.selectedIndex = self.rangeTo-1;
                                }
                            }
                            [self setNeedsDisplay];
                        }
                    }else{
                        // 向上右移
                        if(self.plotCount > (self.rangeTo-self.rangeFrom)){
                            if(self.rangeTo + interval <= self.plotCount){
                                self.rangeFrom += interval;
                                self.rangeTo += interval;
                                if(self.selectedIndex < self.rangeFrom){
                                    self.selectedIndex = self.rangeFrom;
                                }
                            }else {
                                self.rangeFrom  += self.plotCount-self.rangeTo;
                                self.rangeTo     = self.plotCount;
                                
                                if(self.selectedIndex < self.rangeFrom){
                                    self.selectedIndex = self.rangeFrom;
                                }
                            }
                            [self setNeedsDisplay];
                        }
                    }
                    self.touchFlag = [touch locationInView:self].y;
                }
            }
        }
        
    }else if ([ts count]==2) {
        float currFlag = [[ts objectAtIndex:0] locationInView:self].x;
        float currFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
        if(self.touchFlag == 0){
            self.touchFlag = currFlag;
            self.touchFlagTwo = currFlagTwo;
        }else{
            int interval = 5;
            
            if((currFlag - self.touchFlag) > 0 && (currFlagTwo - self.touchFlagTwo) > 0){
                if(self.plotCount > (self.rangeTo-self.rangeFrom)){
                    if(self.rangeFrom - interval >= 0){
                        self.rangeFrom -= interval;
                        self.rangeTo   -= interval;
                        if(self.selectedIndex >= self.rangeTo){
                            self.selectedIndex = self.rangeTo-1;
                        }
                    }else {
                        self.rangeFrom = 1;
                        self.rangeTo  -= self.rangeFrom;
                        if(self.selectedIndex >= self.rangeTo){
                            self.selectedIndex = self.rangeTo-1;
                        }
                    }
                    [self setNeedsDisplay];
                }
            }else if((currFlag - self.touchFlag) < 0 && (currFlagTwo - self.touchFlagTwo) < 0){
                if(self.plotCount > (self.rangeTo-self.rangeFrom)){
                    if(self.rangeTo + interval <= self.plotCount){
                        self.rangeFrom += interval;
                        self.rangeTo += interval;
                        if(self.selectedIndex < self.rangeFrom){
                            self.selectedIndex = self.rangeFrom;
                        }
                    }else {
                        self.rangeFrom  += self.plotCount-self.rangeTo;
                        self.rangeTo     = self.plotCount;
                        
                        if(self.selectedIndex < self.rangeFrom){
                            self.selectedIndex = self.rangeFrom;
                        }
                    }
                    [self setNeedsDisplay];
                }
            }else {
                if(abs(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag)) >= MIN_INTERVAL){
                    if(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag) > 0){
                        if(self.plotCount>self.rangeTo-self.rangeFrom){
                            if(self.rangeFrom + interval < self.rangeTo){
                                self.rangeFrom += interval;
                            }
                            if(self.rangeTo - interval > self.rangeFrom){
                                self.rangeTo -= interval;
                            }
                        }else{
                            if(self.rangeTo - interval > self.rangeFrom){
                                self.rangeTo -= interval;
                            }
                        }
                        [self setNeedsDisplay];
                    }else{
                        
                        if(self.rangeFrom - interval >= 0){
                            self.rangeFrom -= interval;
                        }else{
                            self.rangeFrom = 0;
                        }
                        self.rangeTo += interval;
                        [self setNeedsDisplay];
                    }
                }
            }
            
        }
        self.touchFlag = currFlag;
        self.touchFlagTwo = currFlagTwo;
    }
}

//滚动结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.enableSelection) {
        return;
    }
    sliding = NO;
    NSArray *ts = [touches allObjects];
    UITouch* touch = [[event allTouches] anyObject];
    if([ts count]==1){
        int i = [self getIndexOfSection:[touch locationInView:self]];
        if(i!=-1){
            Section *sec = [self.sections objectAtIndex:i];
            if([touch locationInView:self].x > sec.paddingLeft){
                if(sec.paging){
                    [sec nextPage];
                    [self setNeedsDisplay];
                }else{
                    [self setSelectedIndexByPoint:[touch locationInView:self]];
                }
            }
        }
    }
    self.touchFlag = 0;
}

@end
