//
//  CustomTool.h
//  ZhangZhongBao
//
//  Created by cyan on 16/9/16.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringTool : NSObject


+ (BOOL)judgeValidString:(NSString *)string;

+ (BOOL)judgeString:(NSString *)string;
+ (NSString *)dealString:(NSString *)string defaultString:(NSString *)defaultString;
+ (NSString *)dealString:(NSString *)string;

@end
