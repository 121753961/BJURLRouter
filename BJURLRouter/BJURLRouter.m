//
//  BJURLRouter.m
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/3.
//  Copyright © 2017年 KuangBing. All rights reserved.
//

#import "BJURLRouter.h"
#import "BJURLNavgation.h"

@interface BJURLRouter()

/** 存储读取的plist文件数据 */
@property (nonatomic, strong) NSDictionary *configDict;

@end

@implementation BJURLRouter
static id _instance;

/** 单例的实现 */
+(instancetype)sharedRouter{
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

/**
 *  加载plist文件中的URL配置信息
 *  @param pistName plist文件名称,不用加后缀
 */
+ (void)loadConfigDictFromPlist:(NSString *)pistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:pistName ofType:nil];
    NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (configDict) {
        [BJURLRouter sharedRouter].configDict = configDict;
        NSLog(@"%@",configDict);
    }else {
        NSLog(@"请按照说明添加对应的plist文件");
    }
}

/** 获取URL的配置 */
+(NSDictionary *)getConfig{
    return [BJURLRouter sharedRouter].configDict;
}

#pragma mark -------- 拿到导航控制器 和 当前控制器 --------
/** 返回当前控制器 */
- (UIViewController *)currentViewController{
    return [BJURLNavgation sharedNavgation].currentViewController;
}

/** 返回当前控制器的导航控制器 */
- (UINavigationController *)currentNavigationViewController{
    return [BJURLNavgation sharedNavgation].currentNavigationViewController;
}

#pragma mark --------  push 控制器 --------
/**
 *  push控制器 同系统的
 *  @param viewController 目标控制器
 */
+(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [BJURLNavgation pushViewController:viewController animated:animated replace:NO];
}

/**
 *  push控制器 类似系统的
 *
 *  @param viewController 目标控制器
 *  @param replace        如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated replace:(BOOL)replace{
    [BJURLNavgation pushViewController:viewController animated:animated replace:replace];
}

/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 */
+(void)pushURLString:(NSString *)urlString animated:(BOOL)animated{
    [self pushURLString:urlString animated:animated replace:NO];
}

/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+(void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated{
    [self pushURLString:urlString query:query animated:animated replace:NO];
}

/**
 *  push控制器
 *
 *  @param urlString 自定义的URL,可以拼接参数
 *  @param replace   如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+(void)pushURLString:(NSString *)urlString animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *viewController = [UIViewController initWithString:urlString withConfig:[BJURLRouter getConfig]];
    [BJURLNavgation pushViewController:viewController animated:animated replace:replace];
}

/**
 *  push控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param replace   如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.同一个才能替换哦!
 */
+(void)pushURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated replace:(BOOL)replace{
    UIViewController *
        viewController = [UIViewController initWithString:urlString withConfig:[BJURLRouter getConfig]];
    [BJURLNavgation pushViewController:viewController animated:animated replace:replace];
}


#pragma mark --------  pop控制器 --------

/** pop掉一层控制器 */
+ (void)popViewControllerAnimated:(BOOL)animated{
    [BJURLNavgation popViewControllerAnimated:animated];
}
/** pop掉两层控制器 */
+ (void)popTwiceViewControllerAnimated:(BOOL)animated{
    [BJURLNavgation popViewControllerWithTimes:2 animated:animated];
}
/** pop掉times层控制器 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated{
    [BJURLNavgation popViewControllerWithTimes:times animated:animated];
}
/** pop到根层控制器 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated{
    [BJURLNavgation popToRootViewControllerAnimated:animated];
}


#pragma mark --------  modal 控制器 --------
/**
 *  modal控制器 同系统的
 *
 *  @param viewController 目标控制器
 */
+(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion{
    [BJURLNavgation presentViewController:viewController animated:animated completion:completion];
}

+(void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^)(void))completion{
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav = [[classType alloc]initWithRootViewController:viewController];
        [BJURLNavgation presentViewController:nav animated:animated completion:completion];
    }
}

/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 */
+(void)presentURLString:(NSString *)urlString animated:(BOOL)animated completion:(void (^)(void))completion{
    UIViewController *viewController = [UIViewController initWithString:urlString withConfig:[BJURLRouter getConfig]];
    [BJURLNavgation presentViewController:viewController animated:animated completion:completion];
}

/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 */
+(void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated completion:(void (^)(void))completion{
    UIViewController *viewController = [UIViewController initWithString:urlString withQuery:query withConfig:[BJURLRouter getConfig]];
    [BJURLNavgation presentViewController:viewController animated:animated completion:completion];
}

/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param classType     需要添加的导航控制器 eg.[UINavigationController class]
 */
+(void)presentURLString:(NSString *)urlString animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^)(void))completion{
    UIViewController *viewController = [UIViewController initWithString:urlString withConfig:[BJURLRouter getConfig]];
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [BJURLNavgation presentViewController:nav animated:animated completion:completion];
    }
}

/**
 *  modal控制器,并且给modal出来的控制器添加一个导航控制器
 *
 *  @param urlString 自定义URL,也可以拼接参数,但会被下面的query替换掉
 *  @param query     存放参数
 *  @param classType     需要添加的导航控制器 eg.[UINavigationController class]
 */
+(void)presentURLString:(NSString *)urlString query:(NSDictionary *)query animated:(BOOL)animated withNavigationClass:(Class)classType completion:(void (^)(void))completion{
    UIViewController *viewController = [UIViewController initWithString:urlString withQuery:query withConfig:[BJURLRouter getConfig]];
    if ([classType isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *nav =  [[classType alloc]initWithRootViewController:viewController];
        [BJURLNavgation presentViewController:nav animated:animated completion:completion];
    }
}

#pragma mark --------  dismiss控制器 --------
+(void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion{
    [BJURLNavgation dismissViewControllerAnimated:animated completion:completion];
}

+(void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated completion:(void (^)(void))completion{
    [BJURLNavgation dismissViewControllerWithTimes:times animated:animated completion:completion];
}

+(void)dismissTwiceViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion{
    [BJURLNavgation dismissViewControllerWithTimes:2 animated:animated completion:completion];
}

+(void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion{
    [BJURLNavgation dismissToRootViewControllerAnimated:animated completion:completion];
}


@end
