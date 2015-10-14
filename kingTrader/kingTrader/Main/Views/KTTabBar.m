//
//  KTTabBar.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTTabBar.h"
#import "KTTabBarButton.h"


@interface KTTabBar()

@property (nonatomic, strong) NSMutableArray* tabbarArrays;
@property (nonatomic, weak) KTTabBarButton *selectedButton;


@end
@implementation KTTabBar

-(NSMutableArray *)tabbarArrays{
    
    if (_tabbarArrays == nil) {
        _tabbarArrays = [NSMutableArray array];
    }
    return _tabbarArrays;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KTNavColor;
    }
    return self;
}
- (void)addTabBarButtonWithItem:(UITabBarItem*) item{
    
    KTTabBarButton* tabbarBtn = [[KTTabBarButton alloc] init];
    [self addSubview:tabbarBtn];
    [self.tabbarArrays addObject:tabbarBtn];

    tabbarBtn.item = item;

    [tabbarBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    if (self.tabbarArrays.count == 1) {
        [self btnClicked:tabbarBtn];
    }
}
- (void)btnClicked:(KTTabBarButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:dicSelectedBtnFrom:to:)]) {
        [self.delegate tabBar:self dicSelectedBtnFrom:self.selectedButton.tag to:sender.tag];
    }
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabbarArrays.count; index++) {
        KTTabBarButton * button = self.tabbarArrays[index];
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW+1, buttonH);
        button.tag = index;
    }
    
}
@end
