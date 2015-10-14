//
//  CandleChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CandleChartModel.h"

@implementation CandleChartModel

-(void)drawSerie:(Chart *)chart serie:(NSMutableDictionary *)serie{

    // 蜡烛图颜色
//    [serie setObject:@"176,52,52" forKey:@"color"];
//    [serie setObject:@"77,143,42" forKey:@"negativeColor"];
//    [serie setObject:@"176,52,52" forKey:@"selectedColor"];
//    [serie setObject:@"77,143,42" forKey:@"negativeSelectedColor"];
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    int            section        = [[serie objectForKey:@"section"] intValue];
    NSString       *color         = [serie objectForKey:@"color"];
    NSString       *negativeColor = [serie objectForKey:@"negativeColor"];
    NSString       *selectedColor = [serie objectForKey:@"selectedColor"];
    NSString       *negativeSelectedColor = [serie objectForKey:@"negativeSelectedColor"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 1.0f);
   
    
    
  
    
    float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    float NR  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float NG  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float NB  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    float SR  = [[[selectedColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float SG  = [[[selectedColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float SB  = [[[selectedColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    float NSR = [[[negativeSelectedColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float NSG = [[[negativeSelectedColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float NSB = [[[negativeSelectedColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    
    Section *sec = [chart.sections objectAtIndex:section];
    
//    KTLog(@"chart.rangeFrom    %d",chart.rangeFrom);
    for(int i=chart.rangeFrom;i<data.count;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        
        float high  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        float open  = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        float close = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        
        float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
        float iNx = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
        float iyo = [chart getLocalY:open withSection:section withAxis:yAxis];
        float iyc = [chart getLocalY:close withSection:section withAxis:yAxis];
        float iyh = [chart getLocalY:high withSection:section withAxis:yAxis];
        float iyl = [chart getLocalY:low withSection:section withAxis:yAxis];
        
        //日线，周线 月线 的十字定位
        if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil&&chart.sliding){
            
            NSString *str = [NSString stringWithFormat:@"%.2f",[[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue]];
            
            float value = [str floatValue];
             float selectY = [chart getLocalY:value withSection:section withAxis:yAxis];
            
            float selectX = sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2;
            
            CGContextSetShouldAntialias(context, NO);
            CGContextSetLineWidth(context, 1.0f);
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.41 green:0.41 blue:0.41 alpha:1.0].CGColor);
            // 竖线
            CGContextMoveToPoint(context, selectX, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context,selectX,sec.frame.size.height+sec.frame.origin.y);
            CGContextStrokePath(context);
            
            //横线
            CGContextSetShouldAntialias(context, NO);
            CGContextSetLineWidth(context, 1.f);
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.41 green:0.41 blue:0.41 alpha:1.0].CGColor);
            CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft, selectY);
            CGContextAddLineToPoint(context,sec.frame.size.width , selectY);
            CGContextStrokePath(context);

        }
        
        //日线 周线 月线 锯齿图
        
        if(close == open){
            if(i == chart.selectedIndex){
                CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:SR green:SG blue:SB alpha:1.0].CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
            }
        }else{
            if(close < open){
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:NSR green:NSG blue:NSB alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, NSR, NSG, NSB, 1.0); 
                }else{
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:NR green:NG blue:NB alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, NR, NG, NB, 1.0); 
                }
            }else{
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:SR green:SG blue:SB alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, SR, SG, SB, 1.0); 
                }else{
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, R, G, B, 1.0); 
                } 
            }
        }
        
//       KTLog(@"日线，月线，周线  %f,%f",chart.plotPadding,chart.plotWidth);
        
//        chart.plotWidth = 4.53333;
        if(close == open){
          //  KTLog(@"%f",chart.plotPadding);
            CGContextMoveToPoint(context, ix+chart.plotPadding, iyo);
            CGContextAddLineToPoint(context, iNx-chart.plotPadding,iyo);
            CGContextStrokePath(context);
            
        }else{
            if(close < open){
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyo, chart.plotWidth-2*chart.plotPadding,iyc-iyo));
            }else{
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyc, chart.plotWidth-2*chart.plotPadding, iyo-iyc));
            }
        }
        
    

        if (iyl >0 ) {
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, iyh);
            CGContextAddLineToPoint(context,ix+chart.plotWidth/2,iyl);
            CGContextStrokePath(context);

        }
        
       
    }
}


-(void)setValuesForYAxis:(Chart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
		return;
	}
	
	NSMutableArray *data    = [serie objectForKey:@"data"];
	NSString       *yAxis   = [serie objectForKey:@"yAxis"];
	NSString       *section = [serie objectForKey:@"section"];
	
	YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
  //  KTLog(@"da.count=%ld,high=%d",data.count,chart.rangeFrom);
    if (chart.rangeFrom < data.count) {
        float high = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:2] floatValue];
        float low = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:3] floatValue];
        if(!yaxis.isUsed){
            [yaxis setMax:high];
            [yaxis setMin:low];
            yaxis.isUsed = YES;
        }
    }else{
        return;
    }
   
    

    
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        float high = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        if(high > [yaxis max])
            [yaxis setMax:high];
        if(low < [yaxis min])
            [yaxis setMin:low];
    }
}

-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *color         = [serie objectForKey:@"color"];
	NSString       *negativeColor = [serie objectForKey:@"negativeColor"];
	
	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	float NR  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float NG  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float NB  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	
	float ZR  = 0.9;
	float ZG  = 0.9;
	float ZB  = 0.9;
	
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){

        float high  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:3] floatValue];
        float open  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        float close = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:1] floatValue];
        //fix  zyh 幅： 开盘改为昨收价
        float zuoclose = [[[data objectAtIndex:chart.selectedIndex-1] objectAtIndex:1] floatValue];
        float inc   =  (close-zuoclose)*100/zuoclose;
        if (zuoclose == 0) {
            inc = 0.;
        }
//        float inc   =  (close-open)*100/open;
//        if (open == 0) {
//            inc = 0.;
//        }
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        [l appendFormat:@"开:%.2f",open];
        [tmp setObject:l forKey:@"text"];
        NSMutableString *clr = [[NSMutableString alloc] init];
        [clr appendFormat:@"%f,",ZR];
        [clr appendFormat:@"%f,",ZG];
        [clr appendFormat:@"%f",ZB];
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"收:%.2f",close];
        [tmp setObject:l forKey:@"text"];
        clr = [[NSMutableString alloc] init];
        if(close>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if (close < open) {
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"高:%.2f",high];
        [tmp setObject:l forKey:@"text"];
        clr = [[NSMutableString alloc] init];
        if(high>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"低:%.2f ",low];
        [tmp setObject:l forKey:@"text"];
        clr = [[NSMutableString alloc] init];
        if(low>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(low<open){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
        
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"幅:%.2f%@  ",inc,@"%"];
        [tmp setObject:l forKey:@"text"];
        clr = [[NSMutableString alloc] init];
        if(inc > 0){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(inc < 0){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        
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
	
	if([type isEqualToString:@"candle"]){
		for(int i=chart.rangeFrom;i<data.count;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
			
			float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil&&chart.sliding){
				// 日期
				CGContextSetShouldAntialias(context, YES);
				CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 0.8);
				CGSize size = [[category objectAtIndex:chart.selectedIndex] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
				
				int x = ix+chart.plotWidth/2;
				int y = sec.frame.origin.y+sec.paddingTop;
				if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
					x= x-(size.width+4);
				}
				CGContextFillRect (context, CGRectMake (x, y, size.width+4,size.height+2)); 
				CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0);
              
				[[category objectAtIndex:chart.selectedIndex] drawAtPoint:CGPointMake(x+2,y+1) withFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
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
