//
//  LTHistoryLineView.h
//  xuangu
//
//  Created by weisd on 14-8-29.
//  Copyright (c) 2014年 liangtou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chart.h"

@interface LTHistoryLineView : UIView

@property (nonatomic, strong) Chart *mainChart;
@property (nonatomic,strong) NSString *showType;
@property (nonatomic,assign)CGRect chartFrame;



-(void)getLTdata:(NSString *) code;

-(void)setSelectEnable:(BOOL)ok;

@end
