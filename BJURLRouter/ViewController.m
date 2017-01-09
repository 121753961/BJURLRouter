//
//  ViewController.m
//  BJURLRouter
//
//  Created by KuangBing on 2017/1/3.
//  Copyright © 2017年 KuangBing. All rights reserved.
//

#import "ViewController.h"
#import "BJURLRouter.h"
#import "BJUserViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"BJ://user"];
    
    NSLog(@"%@---%@---%@---%@",url.scheme,url.host,url.path,url.baseURL);
    
    
    NSLog(@"kfsfjklsafa");
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(UIButton *)sender {
    [BJURLRouter pushURLString:@"url://userView" animated:YES];
//    BJUserViewController *userVC = [[BJUserViewController alloc]init];
//    [self.navigationController pushViewController:userVC animated:YES];
}


@end
