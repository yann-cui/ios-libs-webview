//
//  GZWebViewController.h
//  gezilicai
//
//  Created by 7heaven on 16/2/26.
//  Copyright © 2016年 yuexue. All rights reserved.
//
#import "GZWebManagerDelegate.h"
#import "GZWebViewDelegate.h"
#import "InterfaceProvider.h"
#import "GZBaseWebViewController.h"

#define kGZWebViewControllerCallback "gezi_webview_callback_notification"

@interface GZWebViewController : UIViewController<GZWebManagerDelegate,GZWebViewDelegate,InterfaceProvider>{
    
    GZBaseWebViewController* _webViewController;
}

@property (strong, nonatomic) NSString *url;

+ (instancetype) newInstanceWithUrl:(NSString *) url;

@end
