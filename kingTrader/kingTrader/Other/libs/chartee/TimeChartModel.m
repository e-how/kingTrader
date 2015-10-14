//
//  LineChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeChartModel.h"
#import "NSNull+LTCast.h"
@implementation TimeChartModel

// 画波线
-(void)drawSerie:(Chart *)chart serie:(NSMutableDictionary *)serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
   
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);  // 抗锯齿
	CGContextSetLineWidth(context, 1.0f);
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
	int            section        = [[serie objectForKey:@"section"] intValue];
     float iyy = 0.0;
//	NSString       *color         = [serie objectForKey:@"color"];
	
//	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
//	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
//	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;	
    
	Section *sec = [chart.sections objectAtIndex:section];

//   YAxis *yaxis = [[[chart.sections objectAtIndex:section] yAxises] objectAtIndex:yAxis];
    
    //NSLog(@"one: %@", [data objectAtIndex:0]);
    // fix 默认会传多一个昨天的值
    if (data.count > 1) {
        chart.rangeFrom = 1;
    } else {
        chart.rangeFrom = 0;
    }
    
   
    CGContextSetRGBFillColor(context, 76.0/255, 190.0/255, 241.0/255, 0.2);
    CGContextSetShouldAntialias(context, YES);
    float starty = sec.frame.origin.y + sec.frame.size.height; // 起点y
    float startx = sec.frame.origin.x+sec.paddingLeft; // 起点x
    float endx = startx;
    CGContextMoveToPoint(context, startx, starty);
    // 移到第一个
    NSString *s = [NSString stringWithFormat:@"%@",[[data objectAtIndex:chart.rangeFrom] objectAtIndex:0]];
    
    //KTLog(@"真的很生气  %@",[NSString stringWithFormat:@"%f",[chart getLocalY:[s floatValue] withSection:section withAxis:yAxis]]);
    if (![[NSString stringWithFormat:@"%f",[chart getLocalY:[s floatValue] withSection:section withAxis:yAxis]]isEqualToString:@"nan"] ) {
          CGContextAddLineToPoint(context, startx, [chart getLocalY:[s floatValue] withSection:section withAxis:yAxis]);
    }
  
    // 波线下线的阴影
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count-1){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        if (i<chart.rangeTo-1 && [data objectAtIndex:(i+1)] != nil) {
            
            float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
            float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
            float iNx  = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
            float iy = [chart getLocalY:value withSection:section withAxis:yAxis];
            
            /*
            float Nvalue = [[[data objectAtIndex:i+1] objectAtIndex:0] floatValue];
            float iNy = [chart getLocalY:Nvalue withSection:section withAxis:yAxis];
            */
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor);
           // KTLog(@"%f",iy);
            if (![[NSString stringWithFormat:@"%f",iy]isEqualToString:@"nan"]) {
                  CGContextAddLineToPoint(context, ix+chart.plotWidth/2, iy);    // 当前价位置
            }
          
            endx = ix+chart.plotWidth/2;
            
            
            float y = [chart getLocalY:([[[data objectAtIndex:(i+1)] objectAtIndex:0] floatValue]) withSection:section withAxis:yAxis];
            if(!isnan(y)){
                CGContextAddLineToPoint(context, iNx+chart.plotWidth/2, y);
                endx = iNx+chart.plotWidth/2;
            }
            

        }
    }
    CGContextAddLineToPoint(context, endx, starty);
    CGContextAddLineToPoint(context, startx, starty);
    CGContextFillPath(context);
    
    
    //  float offset = -12;
    // 波线
    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:76.0/255 green:190.0/255 blue:241.0/255 alpha:1.0].CGColor);
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count-1){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
    

        if (i<chart.rangeTo-1 && [data objectAtIndex:(i+1)] != nil) {
            
            float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
            float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
            float iNx  = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
            float iy = [chart getLocalY:value withSection:section withAxis:yAxis];
           
            
            NSString *iyStr = [NSString stringWithFormat:@"%f",iy];
            
            //CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
            if (![iyStr isEqualToString:@"nan"]) {
               CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
            }
            
            

            
            float y = [chart getLocalY:([[[data objectAtIndex:(i+1)] objectAtIndex:0] floatValue]) withSection:section withAxis:yAxis];
            if(!isnan(y)){
                CGContextAddLineToPoint(context, iNx+chart.plotWidth/2, y);
            }
            
           
            
            
            NSString *str = [[data objectAtIndex:i]objectAtIndex:2];
           //  NSString *str4 = [[data objectAtIndex:i+1]objectAtIndex:0];
           
           // KTLog(@"%@",chart.datasFenShi);
            
            for ( int j = 0; j < [chart.datasFenShi count]; j++) {
                
               
                NSString *str1 = [[chart.datasFenShi objectAtIndex:j ]objectAtIndex:0];
                NSString *number = nil;
                if (number == nil) {
                    number = [[NSString alloc]init];
                }
                number = [NSString stringWithFormat:@"%@",[[chart.datasFenShi objectAtIndex:j ]objectAtIndex:1]];
                NSString *upDown = [NSString stringWithFormat:@"%@",[[chart.datasFenShi objectAtIndex:j ]objectAtIndex:3]];
                

                
                if ([str isEqualToString:str1]) {
              
                    if ([[NSString stringWithFormat:@"%@",[[chart.datasFenShi objectAtIndex:j ]objectAtIndex:2]]floatValue] == 1) {
                       [UIColor colorWithRed:0.37f green:1.00f blue:0.00f alpha:1.00f];
                        
                         CGContextSetRGBFillColor(context, 0.37, 1.0, 0.0, 1.0);
                    }else{
                       
                         CGContextSetRGBFillColor(context, 0.93, 0.0, 0.57, 1.0);
                       
                    }
                    
                    if ([upDown isEqualToString:@"0"]) {
                        iyy = 3;
                    }else{
                        iyy =  -15;
                    }
                
                    
//                    KTLog(@"纵坐标的值  %f,%f",iy+iyy,iyy);
                    if ([number isEqualToString:@"9"]||j == chart.datasFenShi.count-1) {
                         [number drawAtPoint:CGPointMake(ix+chart.plotWidth/2,iy+iyy) withFont:[UIFont systemFontOfSize: 8]];
                    }else{
                        
                         [@"." drawAtPoint:CGPointMake(ix+chart.plotWidth/2,iy+iyy) withFont:[UIFont boldSystemFontOfSize: 12]];
                    }
                    

                }
               
            }
            
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:76.0/255 green:190.0/255 blue:241.0/255 alpha:1.0].CGColor);
            if (![[NSString stringWithFormat:@"%f",iy]isEqualToString:@"nan"]) {
                 CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
            }
           
            
           CGContextStrokePath(context);
            
            
        }
        
     

    }
    
    
    

    
}


-(void)drawSelected:(Chart *) chart serie:(NSMutableDictionary *) serie
{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);  // 抗锯齿
    CGContextSetLineWidth(context, 1.0f);
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    int            section        = [[serie objectForKey:@"section"] intValue];
    
    
    Section *sec = [chart.sections objectAtIndex:section];
    
    
    //分时十字定位 选中的竖线
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil&&chart.sliding){
        // 选中的值
        
        
        NSString *str = [NSString stringWithFormat:@"%.2f",[[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue]];
        
        float value = [str floatValue];
//        KTLog(@"莉莉莉莉莉莉   %f",value);
        float selectX = sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2;
        
        CGContextSetShouldAntialias(context, NO);
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.4 green:0.41 blue:0.41 alpha:1.0].CGColor);
        // 竖线
       
        CGContextMoveToPoint(context, selectX, sec.frame.origin.y+sec.paddingTop);
        CGContextAddLineToPoint(context,selectX,sec.frame.size.height+sec.frame.origin.y);
        CGContextStrokePath(context);
        
        
        // 画点
        CGContextSetShouldAntialias(context, YES);
        CGContextSetLineWidth(context, 1.0f);
        CGContextBeginPath(context);
        //        CGContextSetRGBFillColor(context, R, G, B, 1.0);
        CGContextSetRGBFillColor(context, 0.9, 0.0, 0.0, 0.0);
        
        if(!isnan([chart getLocalY:value withSection:section withAxis:yAxis])){
            float selectY = [chart getLocalY:value withSection:section withAxis:yAxis];
            CGContextAddArc(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, selectY, 3, 0, 2*M_PI, 1);
            CGContextFillPath(context);
            
            // 横线
            //CGContextBeginPath(context);
            CGContextSetShouldAntialias(context, NO);
            CGContextSetLineWidth(context, 1.0f);
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.41 green:0.41 blue:0.41 alpha:1.0].CGColor);
            CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft, selectY);
            CGContextAddLineToPoint(context,sec.frame.size.width , selectY);
            CGContextStrokePath(context);
            
            // 线左边对应提示
            CGContextSetRGBFillColor(context, 76.0/255, 190.0/255, 241.0/255,0.0);
            CGContextSetShouldAntialias(context, YES);
            CGContextMoveToPoint(context, sec.frame.origin.x, selectY-7);
            CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft , selectY-7);
            CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft , selectY+7);
            CGContextAddLineToPoint(context,sec.frame.origin.x , selectY+7);
            CGContextFillPath(context);
            
            //  提示上面的文字
            //
            
              CGSize valShowLen = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:str,[UIFont systemFontOfSize:10], nil]];
            
//            CGSize valShowLen = [str sizeWithFont:[UIFont systemFontOfSize:10]];
            
            CGFloat offset = sec.paddingLeft - valShowLen.width -2;
            if (offset < 0) {
                offset = 0;
            }
            CGContextSetFillColorWithColor(context, [[UIColor alloc] initWithRed:0.9 green:0.0 blue:0.0 alpha:0.0].CGColor);
   
            [str drawAtPoint:CGPointMake(sec.frame.origin.x+offset, selectY-7) withFont:[UIFont systemFontOfSize: 10]];
            
            
            
        }
    }
}

-(void)drawXAxis:(Chart *) chart serie:(NSMutableDictionary *) serie
{
    
   // NSMutableArray *data    = [serie objectForKey:@"data"];
    NSString       *xAxis   = [serie objectForKey:@"xAxis"];
    NSString       *section = [serie objectForKey:@"section"];
    
   XAxis *xaxis = [[[chart.sections objectAtIndex:[section intValue]] xAxises] objectAtIndex:[xAxis intValue]];
    
    // 固定
    [xaxis.values addObject:@"9:30"];
    [xaxis.values addObject:@"10:30"];
    [xaxis.values addObject:@"11:30/13:00"];
    [xaxis.values addObject:@"14:00"];
    [xaxis.values addObject:@"15:00"];
    
    [xaxis.indexs addObject:@(0)];
    [xaxis.indexs addObject:@(59)];
    [xaxis.indexs addObject:@(119)];
    [xaxis.indexs addObject:@(179)];
    [xaxis.indexs addObject:@(239)];
    
//    for (int i=chart.rangeFrom; i< chart.rangeTo; i++) {
//        if (<#condition#>) {
//            <#statements#>
//        }
//    }
}

// x轴
-(void)setValuesForXAxis:(Chart *)chart serie:(NSDictionary *)serie
{
    // 没有数据就不画
    if([[serie objectForKey:@"category"] count] == 0){
        return;
    }
//    KTLog(@"cc=%@",[[[serie objectForKey:@"data"] objectAtIndex:2] objectAtIndex:2]);
  
   
    NSInteger section = [[serie objectForKey:@"section"] intValue];
    
    Section *sec = [chart.sections objectAtIndex:section];
    
   
    // 固定
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:@"9:30"];
    [values addObject:@"10:30"];
    [values addObject:@"11:30/13:00"];
    [values addObject:@"14:00"];
    [values addObject:@"15:00"];
    

    NSMutableArray *indexs = [NSMutableArray array];
    [indexs addObject:@(0)];
    [indexs addObject:@(59)];
    [indexs addObject:@(119)];
    [indexs addObject:@(179)];
    [indexs addObject:@(239)];
    
    
    // 画线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);  // 抗锯齿
    CGContextSetLineWidth(context, 0.3f);
    
    
    NSString *v = @"";
    bool draw = true;
    float offset = -12;

    //如果是股指期货
    if (chart.isFuture) {
        for (int i=chart.rangeFrom; i<=chart.rangeTo ; i++) {
          /* 固定写死时间
           
           draw = true;
           offset = -12;
           switch (i) {
           case 1:
           draw = false;
           offset = 0;
           v = @"9:30";
           break;
           case 60:
           v = @"10:30";
           break;
           case 119:
           v = @"11:30/13:00";
           offset = -22;
           break;
           case 180:
           v = @"14:00";
           break;
           case 239:
           draw = false;
           v = @"15:00";
           offset = - 20;
           break;
           default:
           continue;
           }
           
           */
            
            draw = true;
            offset = -12;
           
            
                if (i == chart.rangeFrom) {
                    
                draw = false;
                offset = 0;
                    
                if (i >= [[serie objectForKey:@"data"] count]) {
                  break;
                }
                    v = [[[serie objectForKey:@"data"] objectAtIndex:i] objectAtIndex:2];
               
                
                }else if (i == ceilf(chart.rangeTo/4)) {
                
                if (i >= [[serie objectForKey:@"data"] count]) {
                    break;
                }
                    v = [[[serie objectForKey:@"data"] objectAtIndex:i] objectAtIndex:2];
                
                }else if (i == ceilf(chart.rangeTo/2-1)){
                    if (i >= [[serie objectForKey:@"data"] count]) {
                        break;
                        }
                    v = [[[serie objectForKey:@"data"] objectAtIndex:i] objectAtIndex:2];
                    
                }else if (i == ceilf(chart.rangeTo/4*3)){
                    
                    if (i >= [[serie objectForKey:@"data"] count]) {
                        break;
                    }
                    v = [[[serie objectForKey:@"data"] objectAtIndex:i] objectAtIndex:2];
                   
                }else if (i == chart.rangeTo-1){
                    
                    if (i >= [[serie objectForKey:@"data"] count]) {
                        break;
                    }
                    v = [[[serie objectForKey:@"data"] objectAtIndex:i] objectAtIndex:2];
                    offset = -20;
                    draw = false;
                    
                }else{
                    
                    continue;
                }
      
                
                float ix = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom+2)*chart.plotWidth;
                // 中间竖虚线
                if (draw == true) {
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.8].CGColor);
                    
                    CGContextMoveToPoint(context, ix, sec.frame.origin.y+sec.paddingTop);
                    CGContextAddLineToPoint(context, ix, sec.frame.origin.y+sec.frame.size.height);
                    CGContextStrokePath(context);
                }
                
                
                
                // 字
                CGContextSetShouldAntialias(context, YES);  // 抗锯齿
                
                float iy = sec.frame.origin.y + sec.frame.size.height;
                
                
                
                //时间段
                CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
                [v drawAtPoint:CGPointMake(ix+offset,iy) withFont:[UIFont systemFontOfSize: 8]];
                
                
                
            }
        return;
    }
    
    for (int i=chart.rangeFrom; i<=chart.rangeTo; i++) {
        draw = true;
        offset = -12;
        switch (i) {
            case 1:
                draw = false;
                offset = 0;
                v = @"9:30";
                break;
            case 60:
                v = @"10:30";
                break;
            case 119:
                v = @"11:30/13:00";
                offset = -22;
                break;
            case 180:
                v = @"14:00";
                break;
            case 239:
                draw = false;
                v = @"15:00";
                offset = - 20;
                break;
            default:
                continue;
        }
    
          //KTLog(@"=========range %d,=========%f", (i-chart.rangeFrom),chart.plotWidth);
 
             float ix = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom+2)*chart.plotWidth;
        // 中间竖虚线
        if (draw == true) {
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.8].CGColor);
            
            CGContextMoveToPoint(context, ix, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context, ix, sec.frame.origin.y+sec.frame.size.height);
            CGContextStrokePath(context);
        }
        
        
        
        // 字
        CGContextSetShouldAntialias(context, YES);  // 抗锯齿
        
        float iy = sec.frame.origin.y + sec.frame.size.height;
        
        
        
        //时间段
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        [v drawAtPoint:CGPointMake(ix+offset,iy) withFont:[UIFont systemFontOfSize: 8]];
        
       
        
    }
    
   
  
  

    /*
    for (NSInteger i=chart.rangeFrom; i<chart.rangeTo; i++) {
        if (i == data.count) {
            break;
        }
        
        if ([data objectAtIndex:i] == nil) {
            continue;
        }
        
        NSString *value = [data objectAtIndex:3];
        // 判断是否存在
        if ([value isEqualToString:@"09:30"]) {
            [xaxis.values addObject:@"09:30"];
            [xaxis.indexs addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
     */
    
}

// 设置Y轴的值
-(void)setValuesForYAxis:(Chart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
		return;
	}
   
    
	NSMutableArray *data    = [serie objectForKey:@"data"];
	NSString       *yAxis   = [serie objectForKey:@"yAxis"];
	NSString       *section = [serie objectForKey:@"section"];
    if ([data count] == 1) {
        return;
    }
   
	
	YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
	if([serie objectForKey:@"decimal"] != nil){
		yaxis.decimal = [[serie objectForKey:@"decimal"] intValue];
	}
	
    // 显示第一个数据的值 rangeFrom
    NSString *st = [NSString stringWithFormat:@"%.3f",[[[data objectAtIndex:chart.rangeFrom] objectAtIndex:0]floatValue]];
    
	float value = [st floatValue];
//    KTLog(@"滴滴滴哒哒哒 %f",value);

    // 初始化yaxis
    if(!yaxis.isUsed){
        [yaxis setMax:value];
        [yaxis setMin:value];
        yaxis.isUsed = YES;
    }
    // 取出最大值，最小值
    for(int i=0;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        
        if([data objectAtIndex:i] == nil){
            continue;
        }

        float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
       
        if(value > [yaxis max])
            [yaxis setMax:value];
        if(value < [yaxis min])
            [yaxis setMin:value];
    }
    
    // weisd设置baseValue
    [yaxis setBaseValue:[[[data objectAtIndex:0] objectAtIndex:0] floatValue]];
   
}

// 设置提示字符
-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	//NSString       *type          = [serie objectForKey:@"type"];
	NSString       *lbl           = [serie objectForKey:@"label"];
	int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
	int            section        = [[serie objectForKey:@"section"] intValue];
	NSString       *color         = [serie objectForKey:@"color"];
	
	YAxis *yaxis = [[[chart.sections objectAtIndex:section] yAxises] objectAtIndex:yAxis];
	NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
	
	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;

    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        // 设置价格 文本text 颜色color
        NSString *string = [NSString stringWithFormat:@"%@",[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0]];
        float value = [string floatValue];
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        NSString *fmt = [@"%@:" stringByAppendingFormat:@"%@",format];
        [l appendFormat:fmt,lbl,value];
        [tmp setObject:l forKey:@"text"];
        
        NSMutableString *clr = [[NSMutableString alloc] init];
        [clr appendFormat:@"%f,",R];
        [clr appendFormat:@"%f,",G];
        [clr appendFormat:@"%f",B];
        [tmp setObject:clr forKey:@"color"];
        
        [label addObject:tmp];
    }	    
}

-(void)drawTips:(Chart *)chart serie:(NSMutableDictionary *)serie{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 1.0f);
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *type          = [serie objectForKey:@"type"];
	NSString       *name          = [serie objectForKey:@"name"];
	int            section        = [[serie objectForKey:@"section"] intValue];
	NSMutableArray *category      = [serie objectForKey:@"category"];
	Section *sec = [chart.sections objectAtIndex:section];
	
	if([type isEqualToString:@"time"]){
		for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
          
			
			float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
				
				CGContextSetShouldAntialias(context, YES);
				CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 0.8);
                
                // 价格、成交量、时间、均价

                NSArray *values = [data objectAtIndex:i];
                NSString *pricev = [NSString stringWithFormat:@"现价：%.2f",  [[values objectAtIndex:0]floatValue]];
                NSString *volv = [NSString stringWithFormat:@"成交：%.2f万", [[values objectAtIndex:1]floatValue]/10000];
                NSString *timev = [NSString stringWithFormat:@"时间：%@", [values objectAtIndex:2]];
                NSString *avgv = [NSString stringWithFormat:@"均价：%.2f", [[values objectAtIndex:3]floatValue]];
               
                
                CGSize volsize = [volv sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:volv,[UIFont fontWithName:@"Helvetica" size:9.0], nil]];
    
                CGSize pricesize = [pricev sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:pricev,[UIFont fontWithName:@"Helvetica" size:9.0], nil]];

                CGSize timesize = [timev sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:timev,[UIFont fontWithName:@"Helvetica" size:9.0], nil]];
          
                
                
                
				
                float w = fmaxf(volsize.width, pricesize.width);
                w = fmax(w, timesize.width);
            
               // float h = volsize.height;
                float ww = sec.frame.size.width/4;
                
				int x = ix+chart.plotWidth/2;
				//int y = sec.frame.origin.y+sec.paddingTop;
//				if(x+w > sec.frame.size.width+sec.frame.origin.x){
//					x= x-(w+4);
//				}
                
                if (ix > sec.frame.origin.x+(sec.frame.size.width+sec.paddingLeft)/2) {
                    x= sec.frame.origin.x+sec.paddingLeft;
                } else {
                    x= sec.frame.origin.x + sec.frame.size.width - w - 4 ;
                }
                
                // 框体
//                CGContextSetRGBFillColor(context, 0.31, 0.31, 0.31, 1);
//				CGContextFillRect (context, CGRectMake (0, 0, w+4,h*values.count+2));
				
                // 字体颜色
                CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
                if (chart.isFuture) {
                    return;
                }
				
                
                if (chart.hostBan) {
                    
                    [timev drawAtPoint:CGPointMake(30,2) withFont:[UIFont fontWithName:@"Helvetica" size:8.5]];
                    
                    [[NSString stringWithFormat:@"涨幅：%.2f",  [[values objectAtIndex:0]floatValue]] drawAtPoint:CGPointMake( ww+30,2) withFont:[UIFont fontWithName:@"Helvetica" size:8.5]];
                    
                }else{
                    [volv drawAtPoint:CGPointMake(ww+5,2) withFont:[UIFont fontWithName:@"Helvetica" size:8.5]];
                    [avgv drawAtPoint:CGPointMake(ww*3+10,2) withFont:[UIFont fontWithName:@"Helvetica" size:8.5]];
                    [timev drawAtPoint:CGPointMake(5,2) withFont:[UIFont fontWithName:@"Helvetica" size:8.5]];
                    
                    [pricev drawAtPoint:CGPointMake( ww*2+15,2) withFont:[UIFont fontWithName:@"Helvetica" size:8.5]];
                }
                
                
                
                
				CGContextSetShouldAntialias(context, NO);
			}
		}
	}
	
	if([type isEqualToString:@"line"] && [name isEqualToString:@"price"]){
		for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
			
			float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
				
				CGContextSetShouldAntialias(context, YES);
				CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 0.8);
				CGSize size = [[category objectAtIndex:chart.selectedIndex] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
				
				int x = ix+chart.plotWidth/2;
				int y = sec.frame.origin.y+sec.paddingTop;
				if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
					x = x-(size.width+4);
				}
				CGContextFillRect (context, CGRectMake (x, y, size.width+4,size.height+2));
				CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0);
				[[category objectAtIndex:chart.selectedIndex] drawAtPoint:CGPointMake(x+2,y+1) withFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
				CGContextSetShouldAntialias(context, NO);
			}
		}
	}
	
}

@end
