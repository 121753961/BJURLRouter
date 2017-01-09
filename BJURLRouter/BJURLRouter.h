//
//  BJURLRouter.h
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/3.
//  Copyright © 2017年 KuangBing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+BJURLRouter.h"

NS_ASSUME_NONNULL_BEGIN
@interface BJURLRouter : NSObject


/** 单例的实现 */
+ (instancetype)sharedRouter;

/**
 *  加载plist文件中的URL配置信息
 *
 *  @param pistName plist文件名称,不用加后缀
 */
+ (void)loadConfigDictFromPlist:(NSString *)pistName;

/** 获取URL的配置 */
+(NSDictionary *)getConfig;

#pragma mark -------- 拿到导航控制器 和 当前控制器 --------
/** 返回当前控制器 */
- (UIViewController *)currentViewController;

/** 返回当前控制器的导航控制器 */
- (UINavigationController *)currentNavigationViewController;

#pragma mark --------  push 控制器 --------
/**
 *  push控制器 同系统的
 *
 *  @param viewController 目标控制器
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  push控制器 类似系统的
 *
 *  @param viewController 目标控制器
 *  @param replace        如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace;

/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated;

/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated;

/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param replace   如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+ (void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace;

/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param replace   如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+ (void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace;

#pragma mark --------  pop控制器 --------
/** pop掉一层控制器 */
+ (void)popViewControllerAnimated:(BOOL)animated;
/** pop掉两层控制器 */
+ (void)popTwiceViewControllerAnimated:(BOOL)animated;
/** pop掉times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;
/** pop到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;


#pragma mark --------  modal 控制器 --------
/**
 *  modal控制器 同系统的
 *
 *  @param viewController 目标控制器
 */
+(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^__nullable)(void))completion;


/**
 *  modal控制器
 *
 *  @param viewController          目标控制器
 *  @param classType               需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentViewController:(UIViewController *)viewController animated: (BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param classType 需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;


/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param classType     需要添加的导航控制器 eg.[UINavigationController class]
 */
+ (void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^ __nullable)(void))completion;

#pragma mark --------  dismiss控制器 --------
/** dismiss掉1层控制器 */
+ (void)dismissViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;

/** dismiss掉2层控制器 */
+ (void)dismissTwiceViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;

/** dismiss掉times层控制器 */
+ (void)dismissViewControllerWithTimes:(NSUInteger)times animated: (BOOL)animated completion: (void (^ __nullable)(void))completion;

/** dismiss到根层控制器 */
+ (void)dismissToRootViewControllerAnimated: (BOOL)animated completion: (void (^ __nullable)(void))completion;


NS_ASSUME_NONNULL_END
@end
