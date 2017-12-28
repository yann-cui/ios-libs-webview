//
//  CustomTool.m
//  ZhangZhongBao
//
//  Created by cyan on 16/9/16.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "StringTool.h"

@implementation StringTool

+ (BOOL)judgeString:(NSString *)string{
    
    BOOL res = YES;
    if (string == nil  || [string isEqualToString:@"nsnull"] || [string isEqualToString:@"null"] || [string isEqualToString:@""]) {
        
        res = NO;
    }
    
    return res;
}

+ (BOOL)judgeValidString:(NSString *)string{
    
    BOOL res = YES;
    if (string == nil) {
        
        res = NO;
    }
    
    return res;
}

+ (NSString *)dealString:(NSString *)string defaultString:(NSString *)defaultString{
    
    NSString *resultStr = nil;
    
    if (![StringTool judgeString:string]) {
        resultStr = defaultString;
    }else{
        resultStr = string;
    }
    return resultStr;
    
}

+ (NSString *)dealString:(NSString *)string{
 
    return [StringTool dealString:string defaultString:@""];
}



@end
