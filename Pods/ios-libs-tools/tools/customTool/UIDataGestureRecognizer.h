//
//  UIDataGestureRecognizer.h
//  gezilicai
//
//  Created by 7heaven on 16/3/1.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDataGestureRecognizer : UITapGestureRecognizer

@property (strong, nonatomic) id data;

+ (UIDataGestureRecognizer *)addGestureForView:(UIView *)view
                                     withOwner:(id)owner
                                        action:(SEL)selector
                                     extraData:(id)extraData;

@end
