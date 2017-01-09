//
//  BJURLNavgation.m
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/3.
//  Copyright © 2017年 KuangBing. All rights reserved.
//

#import "BJURLNavgation.h"

@implementation BJURLNavgation
static id _instance;
/** 单例的实现 */
+(instancetype)sharedNavgation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}

/** 获取 applicationDelegate */
- (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

/** 返回当前控制器 */
-(UIViewController *)currentViewController{
    UIViewController *rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

/** 返回当前的导航控制器 */
- (UINavigationController *)currentNavigationViewController{
    UIViewController *currentViewController = self.currentViewController;
    return currentViewController.navigationController;
}

/** 返回当前的导航控制器 */
+(void)setRootViewController:(UIViewController *)viewController{
    [BJURLNavgation sharedNavgation].applicationDelegate.window.rootViewController = viewController;
}

/** 通过递归拿到当前控制器 */
-(UIViewController *)currentViewControllerFrom:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        // 如果传入的控制器是导航控制器,则返回最后一个
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }else if([viewController isKindOfClass:[UITabBarController class]]){
        // 如果传入的控制器是tabBar控制器,则返回选中的那个
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    }else if(viewController.presentedViewController != nil){
        // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }else{
        return viewController;
    }
}

/**
 *  push控制器 类似系统的
 *
 *  @param viewController 目标控制器
 *  @param replace        如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace{
    if (!viewController) {
        NSLog(@"%@不在匹配的控制器plist文件中",[viewController class]);
    }else{
        UINavigationController *navigationController = [[BJURLNavgation sharedNavgation] currentNavigationViewController];
        if (navigationController) {
            // In case it should replace, look for the last UIViewController on the UINavigationController, if it's of the same class, replace it with a new one.
            if (replace && [navigationController.viewControllers.lastObject isKindOfClass:[viewController class]]) {
                
                NSArray *viewControllers = [navigationController.viewControllers subarrayWithRange:NSMakeRange(0, navigationController.viewControllers.count-1)];
                [navigationController setViewControllers:[viewControllers arrayByAddingObject:viewController] animated:animated];
            } // 切换当前导航控制器 需要把原来的子控制器都取出来重新添加
            else {
                // 进行push 跳转
                [navigationController pushViewController:viewController animated:animated];
            }
            
        }else{
            // 如果导航控制器不存在,就会创建一个新的,设置为根控制器
            navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
            [BJURLNavgation sharedNavgation].applicationDelegate.window.rootViewController = navigationController;
        }
    }
}

/**
 *  modal控制器 类似系统的
 *
 *  @param viewController 目标控制器
 */
+(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion{
    if (!viewController) {
        NSLog(@"%@不在匹配的控制器plist文件中",[viewController class]);
    }else{
        UIViewController *currentViewController = [[BJURLNavgation sharedNavgation] currentViewController];
        if (currentViewController) { // 当前控制器存在
            [currentViewController presentViewController:viewController animated:animated completion:completion];
        } else { // 将控制器设置为根控制器
            [BJURLNavgation sharedNavgation].applicationDelegate.window.rootViewController = viewController;
        }
    }
}

/** 返回到上层控制器 */
+(void)popViewControllerAnimated:(BOOL)animated{
    [BJURLNavgation popViewControllerWithTimes:1 animated:animated];
}

/** 返回到times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated {
    UIViewController *currentViewController = [[BJURLNavgation sharedNavgation] currentViewController];
    NSUInteger count = currentViewController.navigationController.viewControllers.count;
    if(currentViewController){
        if(currentViewController.navigationController) {
            if (count > times){
                [currentViewController.navigationController popToViewController:[currentViewController.navigationController.viewControllers objectAtIndex:count-1-times] animated:animated];
            }else { // 如果times大于控制器的数量
                NSLog(@"确定可以pop掉那么多控制器?");
            }
        }
    }
}

/** 返回到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *currentViewController = [[BJURLNavgation sharedNavgation] currentViewController];
    NSUInteger count = currentViewController.navigationController.viewControllers.count;
    [BJURLNavgation popViewControllerWithTimes:count-1 animated:YES];
}

/** dismiss到上层控制器 */
+(void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion{
    [BJURLNavgation dismissViewControllerWithTimes:2 animated:animated completion:completion];
}

/** dismiss 到 times 层控制器 */
+(void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated completion:(void (^)(void))completion{
    UIViewController *rootVC = [[BJURLNavgation sharedNavgation] currentViewController];
    
    if (rootVC) {
        while (times > 0) {
            rootVC = rootVC.presentingViewController;
            times -= 1;
        }
        [rootVC dismissViewControllerAnimated:animated completion:completion];
    }
    
    if (!rootVC.presentedViewController) {
        NSLog(@"确定能dismiss掉这么多控制器?");
    }
}

/** dismiss 到根层控制器 */
+(void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion{
    UIViewController *currentViewController = [[BJURLNavgation sharedNavgation] currentViewController];
    UIViewController *rootVC = currentViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:completion];
}

@end
