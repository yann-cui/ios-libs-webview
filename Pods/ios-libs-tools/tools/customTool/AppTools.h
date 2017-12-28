//
//  AppTools.h
//  gezilicai
//
//  Created by 7heaven on 2/3/16.
//  Copyright © 2016 yuexue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTools : NSObject

+ (CGFloat) iOSVersion;
+ (NSString *) modelName;
+ (NSString *) bundleId;

+ (NSString *) userAgentString;

+ (NSString *) appVersion;
+ (NSString *) appBuildVersion;
+ (NSString *) channelName;
//+ (NSString *) appStoreCommentAddress;

@end
