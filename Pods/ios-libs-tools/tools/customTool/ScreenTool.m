//
//  ScreelTool.m
//  gezilicai
//
//  Created by 7heaven on 16/3/2.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#import "ScreenTool.h"

#pragma GCC diagnostic ignored "-Wundeclared-selector"

@implementation ScreenTool

+ (BOOL)snapshotAndSaveForTarget:(id)target {
    
    if(![target respondsToSelector:@selector(image:didFinishSavingWithError:contextInfo:)]) return NO;
    
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, NO,
                                           [UIScreen mainScreen].scale);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, target, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    return YES;
}

+ (UIImage *) snapshotForView:(UIView *) targetView offset:(UIEdgeInsets)offset{
    
    if(!targetView) return nil;
    
    CGSize size = targetView.bounds.size;
    size = CGSizeMake(size.width - offset.left - offset.right, size.height - offset.top - offset.bottom);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.left, -offset.top);
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)snapshotAndReturn {
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, NO,
                                           [UIScreen mainScreen].scale);
    
    for(UIWindow *window in [UIApplication sharedApplication].windows){
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGFloat)getStatusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}


+ (NSString *)getLaunchImageName{
    NSString *launchImageName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height == 480) launchImageName = @"LaunchImage-700@2x.png"; // iPhone 4/4s, 3.5 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 568) launchImageName = @"LaunchImage-700-568h@2x.png"; // iPhone 5/5s, 4.0 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 667) launchImageName = @"LaunchImage-800-667h@2x.png"; // iPhone 6, 4.7 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 736) launchImageName = @"LaunchImage-800-Portrait-736h@3x.png"; // iPhone 6+, 5.5 inch screen
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([UIScreen mainScreen].scale == 1) launchImageName = @"LaunchImage-700-Portrait~ipad.png"; // iPad 2
        if ([UIScreen mainScreen].scale == 2) launchImageName = @"LaunchImage-700-Portrait@2x~ipad.png"; // Retina iPads
    }
    
    return launchImageName;
}
@end