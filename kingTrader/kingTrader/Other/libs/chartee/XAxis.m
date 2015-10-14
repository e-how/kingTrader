//
//  YAxis.m
//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import "XAxis.h"

@implementation XAxis

@synthesize isUsed;
@synthesize pos;
@synthesize values;
@synthesize indexs;

- (id)init{
	self = [super init];
    if (self) {
		[self reset];
    }
	return self;
}

-(void)reset{
	self.isUsed = NO;
    self.pos = 0;
	self.values = [NSMutableArray array];
    self.indexs = [NSMutableArray array];
}

@end
