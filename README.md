# BJURLRouter

## 介绍
通过自定义URL实现控制器之间的跳转.

主要功能:
* 支持URL后面拼接参数;
* 支持参数作为字典传入;
* 支持在push的时候进行导航控制器的替换;
* 支持在modal的时候添加导航控制器;

## 1.配置
1. 创建BJURLRouter.一个plist文件,文件夹中有,只要修改下就行了,大概的对应关系如下图所示

2. 加载BJURLRouter文件数据

```Objective-C 
[BJURLRouter loadConfigDictFromPlist:@"BJURLRouter.plist"];

```

## 2. push和modal的使用
所有的push和modal方法都可以通过DCURLRouter这个类方法来调用.这样在push和modal的时候就不需要拿到导航控制器或控制器再跳转了.也就是说,以后push和modal控制器跳转就不一定要在控制器中进行了.

1.push控制器

```Objective-C 
// 不需要拼接参数直接跳转
[BJURLRouter pushURLString:@"url://userView" animated:YES];

// 直接把参数拼接在自定义url末尾
NSString *urlStr = @"url://userView?name=bj&userid=123321";
[BJURLRouter pushURLString:urlStr animated:YES];

// 可以将参数放入一个字典
NSDictionary *dict = @{@"userName":@"BJ", @"userid":@"32342"};
[BJURLRouter pushURLString:@"url://userView" query:dict animated:YES];

// 如果当前控制器和要push的控制器是同一个,可以将replace设置为Yes,进行替换.
[BJURLRouter pushURLString:@"userView" query:dict animated:YES replace:YES];

// 重写了系统的push方法,直接通过控制器跳转
BJUserViewController *userVC = [[BJUserViewController alloc] init];
[BJURLRouter pushViewController:userVC animated:YES];
```
2.modal控制器
用法和push差不多,只是这里添加了一个给modal出来的控制器加一个导航控制器的方法.


```Objective-C
// 不需要拼接参数直接跳转
[BJURLRouter presentURLString:@"url://userView" animated:YES completion:nil];

// 直接把参数拼接在自定义url末尾
NSString *urlStr = @"url://userView?name=bj&userid=213213";
[BJURLRouter presentURLString:urlStr animated:YES completion:nil];

// 可以将参数放入一个字典
NSDictionary *dict = @{@"userName":@"BJ", @"userid":@"32342"};
[BJURLRouter presentURLString:@"url://userView" query:dict animated:YES completion:nil];

// 给modal出来的控制器添加一个导航控制器
[BJURLRouter presentURLString:@"url://userView" animated:YES withNavigationClass:[UINavigationController class] completion:nil];

// 重写了系统的modal方法
BJUserViewController *userVC = [[BJUserViewController alloc] init];
[BJURLRouter presentViewController:three animated:YES completion:nil];
```
