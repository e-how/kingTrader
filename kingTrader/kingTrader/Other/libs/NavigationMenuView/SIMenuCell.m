//
//  SAMenuCell.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import "UIColor+Extension.h"
#import "SICellSelection.h"
#import <QuartzCore/QuartzCore.h>

@interface SIMenuCell ()
@property (nonatomic, strong) SICellSelection *cellSelection;
@end

@implementation SIMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.10f green:0.10f blue:0.10f alpha:1.f];//[UIColor color:[SIMenuConfiguration itemsColor] withAlpha:[SIMenuConfiguration menuAlpha]];
        self.textLabel.textColor = [SIMenuConfiguration itemTextColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.shadowColor = [UIColor darkGrayColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        
        self.selectionStyle = UITableViewCellEditingStyleNone;
        
        self.cellSelection = [[SICellSelection alloc] initWithFrame:self.bounds andColor:[SIMenuConfiguration selectionColor]];
        [self.cellSelection.layer setCornerRadius:6.0];
        [self.cellSelection.layer setMasksToBounds:YES];
        
        self.cellSelection.alpha = 0.0;
        [self.contentView insertSubview:self.cellSelection belowSubview:self.textLabel];
        
//        UIView *lbl = [[UIView alloc] init];
//        lbl.frame = CGRectMake(10 , self.frame.size.height-10, SCREEN_WIDTH-20 , 10);
//        lbl.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"0x3d3d3d"];
//        [self.contentView addSubview:lbl];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.5f);
    
    CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 0.5f);
    CGContextMoveToPoint(ctx, 0, self.contentView.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    CGContextStrokePath(ctx);
    //[UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.00f];
    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.7f);
        
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, 0);
    CGContextStrokePath(ctx);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSelected:(BOOL)selected withCompletionBlock:(void (^)())completion
{
    float alpha = 0.0;
    if (selected) {
        alpha = 1.0;
    } else {
        alpha = 0.0;
    }
    [UIView animateWithDuration:[SIMenuConfiguration selectionSpeed] animations:^{
        self.cellSelection.alpha = alpha;
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)dealloc
{
    self.cellSelection = nil;
}

@end
