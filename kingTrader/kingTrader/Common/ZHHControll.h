





#import <Foundation/Foundation.h>
@class myButton;
typedef void(^block)(myButton *button);
@interface myButton : UIButton

+(myButton *)buttonWithFrame:(CGRect)frame
                        font:(int)size
                       title:(NSString *)title
                        type:(UIButtonType )type
             backgroundImage:(NSString *)backgroundImage
                       image:(NSString *)image
                    andBlock:(block)myBlock;
@end

@interface UIImageView (ZHHController)

+(UIImageView *)imageViewWithFrame:(CGRect)frame image:(NSString *)image;

@end


@interface UILabel (ZHHController)



+(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title font:(int)size;

+(UILabel *)boldLabelWithFrame:(CGRect)frame title:(NSString *)title font:(int)size;
@end

