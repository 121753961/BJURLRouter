//
//  UIViewController+BJURLRouter.h
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/7.
//  Copyright © 2017年 KuangBing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (BJURLRouter)

/** 跳转后控制器能拿到的url */
@property (nonatomic, strong) NSURL *originUrl;

/** url路径 */
@property(nonatomic,copy) NSString *path;

/** 跳转后控制器能拿到的参数 */
@property(nonatomic,strong) NSDictionary *params;

/** 根据参数创建控制器 */
+(UIViewController *)initWithString:(NSString *)urlString withConfig:(NSDictionary *)configDict;

// 根据参数创建控制器 带参数
+ (UIViewController *)initWithString:(NSString *)urlString withQuery:(NSDictionary *)query withConfig:(NSDictionary *)configDict;



NS_ASSUME_NONNULL_END
@end
