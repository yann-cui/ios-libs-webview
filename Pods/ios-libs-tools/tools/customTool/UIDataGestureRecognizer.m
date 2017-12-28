//
//  UIDataGestureRecognizer.m
//  gezilicai
//
//  Created by 7heaven on 16/3/1.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#import "UIDataGestureRecognizer.h"

@implementation UIDataGestureRecognizer

+ (UIDataGestureRecognizer *)addGestureForView:(UIView *)view
                                     withOwner:(id)owner
                                        action:(SEL)selector
                                     extraData:(id)extraData {
    UIDataGestureRecognizer *recognizer = [[UIDataGestureRecognizer alloc] initWithTarget:owner action:selector];
    [recognizer setData:extraData];
    
    for (UIGestureRecognizer *rec in view.gestureRecognizers) {
        [view removeGestureRecognizer:rec];
    }
    
    [view addGestureRecognizer:recognizer];
    [view setUserInteractionEnabled:YES];
    
    return recognizer;
}

@end
