//
//  CharTool.h
//  gezilicai
//
//  Created by 7heaven on 16/3/8.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharTool : NSObject{
    
}

+ (NSString *) num2ChineseNS:(int) num;
+ (BOOL) checkIdentityCard:(NSString *) cardNumber;

//获取url中的参数， 并拆分为key和value，如果url不带参数则返回空
+ (NSDictionary *) getUrlParams:(NSString *) urlString;

@end