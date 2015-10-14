//
//  KTUpingModel.h
//  kingTrader
//
//  Created by kt on 15/10/14.
//  Copyright © 2015年 张益豪. All rights reserved.
//

#import "KTConmonModel.h"

@interface KTUpingModel : KTConmonModel
/*
 code = sh600157;
 increase = "10.07";
 "last_price" = "5.03";
 "n_code" = 600157;
 name = "\U6c38\U6cf0\U80fd\U6e90";
*/

@property (nonatomic,copy) NSString* code;
@property (nonatomic,copy) NSString* increase;
@property (nonatomic,copy) NSString* last_price;
@property (nonatomic,copy) NSString* n_code;
@property (nonatomic,copy) NSString* name;



@end
