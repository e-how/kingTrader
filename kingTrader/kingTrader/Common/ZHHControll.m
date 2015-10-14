





#import "ZHHControll.h"

@interface myButton()
@property (nonatomic,copy)block tempBlock;
@end
@implementation myButton

+(myButton *)buttonWithFrame:(CGRect)frame
                        font:(int)size
                       title:(NSString *)title
                        type:(UIButtonType )type
             backgroundImage:(NSString *)backgroundImage
                       image:(NSString *)image
                    andBlock:(block)myBlock{
    myButton *button = [myButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:size]];
    if (backgroundImage) {
       [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
    if (image) {
       [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }else{
        [button setImage:nil forState:UIControlStateNormal];
    }
    
    //字体颜色
    [button setTitleColor:KTNavTextColor forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tempBlock = myBlock;
    return button;
}
-(void)buttonClicked:(myButton *)button{
    self.tempBlock(button);
}
@end

@implementation UIImageView(ZHHController)

+(UIImageView *)imageViewWithFrame:(CGRect)frame image:(NSString *)image{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    
    imageView.image = [UIImage imageNamed:image];
    return imageView;
}

@end


@implementation UILabel(ZHHController)

static UILabel *label = nil;


+(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title font:(int)size{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    
    label.font = [UIFont systemFontOfSize:size];
    
    return label;
}

+(UILabel *)boldLabelWithFrame:(CGRect)frame title:(NSString *)title font:(int)size{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    
    label.font = [UIFont boldSystemFontOfSize:size];
    
    return label;
}
@end





