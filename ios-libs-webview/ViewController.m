//
//  ViewController.m
//  ios-libs-webview
//
//  Created by cyan on 2017/10/19.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "ViewController.h"
#import "GZWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enterClicked:(id)sender {
    
    GZWebViewController *webController = [GZWebViewController newInstanceWithUrl:@"https://fund.gstianfu.com/index/wx_index"];
    
//    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:webController];
//    [self presentViewController:naviController animated:YES completion:nil];
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
