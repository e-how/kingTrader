//
//  KTNetManager.m
//  kingTrader
//
//  Created by 张益豪 on 15/9/2.
//  Copyright (c) 2015年 张益豪. All rights reserved.
//

#import "KTNetManager.h"
#import "AFNetworking.h"
#import "KTNetCheck.h"
#import "KTDataCache.h"

@implementation KTNetManager
/**
 *  请求前缀为liangtou.com 接口的数据
 *
 *  @param url     接口字符串
 *  @param params  参数
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{

    if (![KTNetCheck isReachable]) {
        KTLog(@"网络不可用");//读取缓存数据
        if ([[[[KTDataCache sharedInstance] getDataWithPath:url] objectForKey:@"info"] isEqualToString:@"ok"]){
            
                success([[[KTDataCache sharedInstance] getDataWithPath:url] objectForKey:@"data"]);
        }else{
            KTLog(@"无缓存");
        }

        return;
    }
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    // 2.发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              if ([[responseObject objectForKey:@"info"] isEqualToString:@"ok"]) {
                  success([responseObject objectForKey:@"data"]);

                  //缓存到本地一份
                  KTDataCache* cache = [KTDataCache sharedInstance];
                  [cache saveData:responseObject path:url];
                  
              }else{
                  KTLog(@"error");
              }
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              KTLog(@"error=%@",error.localizedDescription);
              failure(error);
          }
      }];
}
/**
 *  请求前缀为ktkt.com 接口的数据
 *
 *  @param url     接口字符串
 *  @param params  参数
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
+ (void)postWithKTKTURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    if (![KTNetCheck isReachable]) {
        KTLog(@"网络不可用");
        return;
    }
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    // 2.发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
            
              if ([[responseObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                  success([responseObject objectForKey:@"data"]);
                  
              }else{
                  KTLog(@"error");
              }
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}



+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}
@end
