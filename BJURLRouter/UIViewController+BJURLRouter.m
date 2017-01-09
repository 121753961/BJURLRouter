//
//  UIViewController+BJURLRouter.m
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/7.
//  Copyright © 2017年 KuangBing. All rights reserved.
//

#import "UIViewController+BJURLRouter.h"
#import <objc/runtime.h>

static char URLoriginUrl;
static char URLpath;
static char URLparams;

@implementation UIViewController (BJURLRouter)

/** 为分类设置属性值 */
-(void)setPath:(NSString *)path{
    objc_setAssociatedObject(self, &URLpath, path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)path{
    return objc_getAssociatedObject(self, &URLpath);
}

-(void)setOriginUrl:(NSURL *)originUrl{
    objc_setAssociatedObject(self, &URLoriginUrl, originUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSURL *)originUrl{
    return objc_getAssociatedObject(self, &URLoriginUrl);
}

-(void)setParams:(NSDictionary *)params{
    objc_setAssociatedObject(self, &URLparams, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary *)params{
    return objc_getAssociatedObject(self, &URLparams);
}

/** 根据参数创建控制器 */
+(UIViewController *)initWithString:(NSString *)urlString withConfig:(NSDictionary *)configDict{
    // 支持对中文字符的编码
    NSString *encodeStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodeStr];
    return [UIViewController initWithURL:url withQuery:nil withConfig:configDict];
}

+(UIViewController *)initWithString:(NSString *)urlString withQuery:(NSDictionary *)query withConfig:(NSDictionary *)configDict{
    // 支持对中文字符的编码
    NSString *encodeStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodeStr];
    return [UIViewController initWithURL:url withQuery:query withConfig:configDict];
}

+(UIViewController *)initWithURL:(NSURL *)url withQuery:(NSDictionary *)query withConfig:(NSDictionary *)configDict{
    UIViewController *viewController = nil;
    
    NSString *BJScheme = url.scheme;
    NSString *BJPath = url.path;
    NSString *BJHost = url.host;
    
    NSString *BJHome;
    if (BJPath == nil) {
        BJHome = [NSString stringWithFormat:@"%@://%@",BJScheme,BJHost];
    }else{
        BJHome = [NSString stringWithFormat:@"%@://%@%@",BJScheme,BJHost,BJPath];
    }
    
    // 协议头是否包含在配置字典中
    if ([configDict.allKeys containsObject:BJScheme]) {
        id config = [configDict objectForKey:BJScheme];
        Class class = nil;
        
        // 当协议头是 http https 的情况
        if ([config isKindOfClass:[NSString class]]) {
            class = NSClassFromString(config);
        }else if ([config isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)config;
            if ([dict.allKeys containsObject:BJHome]) {
                // 根据key拿到对应的控制器名称
                class = NSClassFromString([dict objectForKey:BJHome]);
            }
        }
        
        // 如果这个控制器存在
        if (class != nil) {
            viewController = [[class alloc]init];
            if ([viewController respondsToSelector:@selector(open:withQuery:)]) {
                [viewController open:url withQuery:query];
            }
        }
        
        // 处理网络地址的情况
        if ([BJScheme isEqualToString:@"http"] || [BJScheme isEqualToString:@"https"]) {
            class = NSClassFromString([configDict objectForKey:BJScheme]);
            viewController.params = @{@"urlStr" : [url absoluteString]};
        }
    }
    
    return viewController;
}

-(void)open:(NSURL *)url withQuery:(NSDictionary *)query{
    self.path = [url path];
    self.originUrl = url;
    
    // 如果自定义url后面有拼接参数,而且又通过query传入了参数,那么优先query传入了参数
    if (query) {
        self.params = query;
    }else{
        self.params = [self paramsURL:url];
    }
}

/** 将url的参数部分转化成字典 */
-(NSDictionary *)paramsURL:(NSURL *)url{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}



@end
