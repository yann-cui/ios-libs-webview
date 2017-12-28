//
//  ScreelTool.h
//  gezilicai
//
//  Created by 7heaven on 16/3/2.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenTool : NSObject

+ (BOOL)snapshotAndSaveForTarget:(id)target;
+ (UIImage *)snapshotAndReturn;
+ (UIImage *) snapshotForView:(UIView *) targetView offset:(UIEdgeInsets) offset;

+ (CGFloat)getStatusBarHeight;

+ (NSString *) getLaunchImageName;

@end
