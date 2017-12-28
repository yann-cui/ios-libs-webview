//
//  GZWebViewController.m
//  gezilicai
//
//  Created by 7heaven on 16/2/26.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#import "GZWebViewController.h"

#import "GZUIWebViewController.h"
#import "GZWKWebViewController.h"
#import "AppTools.h"
#import "MJExtension.h"
#import "Masonry.h"

#define USE_WKWEBVIEW

const NSString* GZWebViewSelect = @"gz_webviewselect";

@interface GZWebViewController () {
    NSDictionary *_replacementSelectorDict;
    NSString *_pendingCallbackString;
}

@end

@implementation GZWebViewController

+ (instancetype) newInstanceWithUrl:(NSString *) url{
    GZWebViewController *webViewController = [[[self class] alloc] init];
    webViewController.url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return webViewController;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_webViewController evaluateJavaScript:@"onPageResume();" completeBlock:nil];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置 UA
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString* newUA = [NSString stringWithFormat:@"%@ %@",userAgent,[AppTools userAgentString]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : newUA, @"User-Agent" : newUA}];
    });
    [self createWebViewController];
    
//    self.navigationController.navigationBarHidden = YES;
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    }else{
        UIView *naviView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 88))];
        naviView.backgroundColor = [UIColor whiteColor];
        naviView.userInteractionEnabled = YES;
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 44, 44, 44);
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(dismiss:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.imageView.contentMode = UIViewContentModeCenter;
        [naviView addSubview:btn];
        [self.view addSubview:naviView];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webViewController evaluateJavaScript:@"onPagePause();" completeBlock:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}

- (void)createWebViewController{
    
#ifdef USE_WKWEBVIEW
    _webViewController = [GZWKWebViewController newInstanceWithUrl:self.url andDelegate:self];
    _webViewController.webViewAdapter = self;
    _webViewController.interfaceProvider = self;
    _webViewController.disableRefresh = NO;
    _webViewController.interfaceName = @"nativeCommon";
    _webViewController.compatibility_interfaceName = @"gezi";
    [self addChildViewController:_webViewController];
    [self.view addSubview:_webViewController.view];
    [_webViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
    }];
#else
    _webViewController = [GZUIWebViewController newInstanceWithUrl:self.url andDelegate:self];
    _webViewController.webViewAdapter = self;
    _webViewController.interfaceProvider = self;
    _webViewController.interfaceName = @"nativeCommon";
    _webViewController.compatibility_interfaceName = @"gezi";
    [self addChildViewController:_webViewController];
    [self.view addSubview:_webViewController.view];
    [_webViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
    }];
#endif
}

#pragma mark --
- (void) dismiss:(BOOL)animated{
    
    [_webViewController evaluateJavaScript:@"shouldInterceptEvent('back_button_press')" completeBlock:^(id  _Nullable obj) {
        if ([obj isKindOfClass:[NSString class]] && [(NSString *)obj boolValue]) {
            //do nothing
        }else if([_webViewController canGoBack]){
            [_webViewController goBack];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark -- GZWebviewDelegate
- (UIEdgeInsets)webViewInset:(UIViewController*)viewController{
    CGFloat margin_bottom = 0.;
    CGFloat _topInset = 88.;
    if (@available(iOS 11.0, *)) {
        margin_bottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    return UIEdgeInsetsMake( _topInset, 0, margin_bottom, 0);
}

- (void)webMonitorScroll:(UIScrollView *)scrollview{
 
}

- (BOOL)webAppearShouldScrollToTop:(UIScrollView *)scrolview{
    return NO;
}
- (BOOL)webScrollViewAutomaticallyAdjustInsets{
    return NO;
}
#pragma mark -- GZWebviewControllerDelegate
- (void)URLWillLoad:(NSURL *)url{

}
- (void)URLDidLoad:(NSURL *)url{

}
- (void)URLDidFinishLoad:(NSURL *)url{
    [_webViewController evaluateJavaScript:@"document.body.style.webkitTouchCallout='none';" completeBlock:nil];
}
- (void)URLDidFailLoad:(NSError *)error{
    
}
- (void)documentTitleChanged:(NSString*)title{
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        NSLog(@"--> %@",title);
        self.navigationItem.title = title;
    }
}
- (void)controllerViewLayoutSubviews{
    
}
- (void)cookieStoreDidChange:(WKHTTPCookieStore *)cookieStore{
    
}
- (NSDictionary *)requestHeaderField:(NSURL *)url{
    return nil;
}

#pragma mark -- InterProviderDelegate
- (NSDictionary<NSString *, NSValue *> *)javascriptInterfaces{
    
    if(!_replacementSelectorDict){
        _replacementSelectorDict = @{
//                                     @"openIntent" : [NSValue valueWithPointer:@selector(openIntentWithAction:callbackUrl:)],
//                                     @"safecard" : [NSValue valueWithPointer:@selector(openSafeCard)],
//                                     @"popupLoginDialog" : [NSValue valueWithPointer:@selector(popupLoginDialog)],
//                                     @"nativeRoute" :[NSValue valueWithPointer:@selector(nativeRoute:)],
//                                     @"switchtab" : [NSValue valueWithPointer:@selector(switchTab:shouldRefresh:)],
//                                     @"close" : [NSValue valueWithPointer:@selector(close)],
//                                     @"openUrl" : [NSValue valueWithPointer:@selector(openUrl:)],
//
                                     @"getClientInfo" :[NSValue valueWithPointer:@selector(getClientInfo)],
//                                     @"clearHistory" : [NSValue valueWithPointer:@selector(clearHistory)],
//                                     @"setNavigationBarBackgroundColor" : [NSValue valueWithPointer:@selector(setNavigationBarBackgroundColor:)],
//
                                     @"setupShareContent" : [NSValue valueWithPointer:@selector(setupShareContent:)],
//                                     @"addNavBarButton" :[NSValue valueWithPointer:@selector(addNavBarButton:style:method:title:)],
//                                     @"removeNavBarButton" : [NSValue valueWithPointer:@selector(removeNavBarButton:)],
                                     @"share" : [NSValue valueWithPointer:@selector(sharedPlatform:content:)],
//
//                                     @"getUnreadMessageCount" : [NSValue valueWithPointer:@selector(sendUnreadMessageCount)],
//                                     @"markAsRead" : [NSValue valueWithPointer:@selector(markAsRead:)],
//
//                                     @"setTitleText" : [NSValue valueWithPointer:@selector(setTitleText:)],
//                                     @"setTitleMenu" : [NSValue valueWithPointer:@selector(setTitleMenu:)],
                                     };
    }
    return _replacementSelectorDict;
}
- (NSArray<NSString *> *)injectingScripts{
    return nil;
}

- (NSString *)callbackString{
    
    return _pendingCallbackString;
}

- (BOOL)disableInjectJS{
    return NO;
}
- (void)nativeMethodWillStartInvoke:(SEL)selector{
    
}
- (void)nativeMethodFinishInvoke:(SEL)selector{
    
}
- (void)nativeMethodFailInvoke:(SEL)selector{
    
}


# pragma mark -- js bridge(sample)
- (void) setupShareContent:(NSString*)content{
    NSString* contentDecode = [content stringByRemovingPercentEncoding];
    [self showShareButton:contentDecode];
}

- (void)showShareButton:(nullable NSString*)content{
//    if (content != nil && content.length > 0) {
//        _shareMsgCache = content;
//    }else{
//        _shareMsgCache = nil;
//    }
    if (self.navigationItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareBarButtonItemClicked:)];
    }
}

- (void)shareBarButtonItemClicked:(UIBarButtonItem*)pSender{
    NSLog(@"--> share item clicked!!");
}

- (void)sharedPlatform:(NSString *)platform content:(NSString *)jsonContent{
    
    NSLog(@"--> js share_action invoked");
}

- (NSString *)getClientInfo{
    
    NSString *osType = @"iOS";
    NSString *osVersion = [[UIDevice currentDevice]systemVersion];
    NSString *packageName = [AppTools bundleId];
    NSString *channel = [AppTools channelName];
    NSString *version = [AppTools appVersion];
    NSDictionary *appInfo = @{@"osType":osType,@"osVersion":osVersion,@"packageName":packageName,@"channel":channel,@"version":version};
    NSString *jsonAppInfo = [appInfo mj_JSONString];
    
    return jsonAppInfo;
}

- (void)dealloc{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
