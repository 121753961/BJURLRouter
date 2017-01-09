//
//  BJURLNavgation.h
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/3.
//  Copyright © 2017年 KuangBing. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface BJURLNavgation : NSObject

/** 单例的实现 */
+ (instancetype)sharedNavgation;

/** 返回当前控制器 */
- (UIViewController *)currentViewController;

/** 返回当前的导航控制器 */
- (UINavigationController *)currentNavigationViewController;

/** 返回当前的导航控制器 */
+(void)setRootViewController:(UIViewController *)viewController;

/** 通过递归拿到当前控制器 */
-(UIViewController *)currentViewControllerFrom:(UIViewController *)viewController;

/**
 *  push控制器 类似系统的
 *
 *  @param viewController 目标控制器
 *  @param replace        如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace;

/**
 *  modal控制器 类似系统的
 *
 *  @param viewController 目标控制器
 */
+(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

/** 返回到上层控制器 */
+ (void)popViewControllerAnimated:(BOOL)animated;

/** 返回到times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;

/** 返回到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;

/** dismiss到上层控制器 */
+ (void)dismissViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;

/** dismiss 到 times 层控制器 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)animated completion: (void (^ __nullable)(void))completion;

/** dismiss 到根层控制器 */
+ (void)dismissToRootViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;



NS_ASSUME_NONNULL_END

@end

