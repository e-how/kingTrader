//
//  YAxis.h
//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XAxis : NSObject {
	bool isUsed;
	NSMutableArray *values;
    NSMutableArray *indexs;
	int pos;    // 位置
}

@property(nonatomic) bool isUsed;

@property(nonatomic) int pos;
@property(nonatomic,strong) NSMutableArray *values;
@property(nonatomic,strong) NSMutableArray *indexs;

-(void)reset;

@end
