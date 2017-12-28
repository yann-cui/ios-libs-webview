//
//  AppTools.m
//  gezilicai
//
//  Created by 7heaven on 2/3/16.
//  Copyright © 2016 yuexue. All rights reserved.
//

#import "AppTools.h"
#import <sys/utsname.h>

@implementation AppTools

static CGFloat __iOS_version;
static NSString *__bundle_id;
static NSString *__current_model_name;
static NSString *__bundle_id;

static NSString *__ua_string;

static NSString *__app_version;
static NSString *__app_build_version;
static NSString *__channel_name;

//static NSString *__appstore_comment_address;

+ (CGFloat) iOSVersion{
    @synchronized(self) {
        if(__iOS_version == 0){
            __iOS_version = [[[UIDevice currentDevice] systemVersion] floatValue];
        }
        
        return __iOS_version;
    }
}

+ (NSString *) modelName{
    @synchronized(self) {
        if(!__current_model_name){
            struct utsname systemInfo;
            uname(&systemInfo);
            
            __current_model_name = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        }
        
        return __current_model_name;
    }
}

+ (NSString *) bundleId{
    @synchronized(self) {
        if(!__bundle_id){
            __bundle_id = [[NSBundle mainBundle] bundleIdentifier];
        }
        
        return __bundle_id;
    }
}

+ (NSString *) userAgentString{
    @synchronized(self) {
        if(!__ua_string){
            __ua_string = [NSString stringWithFormat:@"%@/%@",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleIdentifier"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        }
        
        return __ua_string;
    }
}

+ (NSString *) appVersion{
    @synchronized(self) {
        if(!__app_version){
            __app_version = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        }
        
        return __app_version;
    }
}

+ (NSString *) appBuildVersion{
    @synchronized(self){
        if(!__app_build_version){
            __app_build_version = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        }
        
        return __app_build_version;
    }
}

+ (NSString *) channelName{
    @synchronized(self) {
        if(!__channel_name){
            __channel_name = @"app_store";
        }
        
        return __channel_name;
    }
}

//+ (NSString *) appStoreCommentAddress{
//    @synchronized(self) {
//        if(!__appstore_comment_address){
//            __appstore_comment_address = @"https://itunes.apple.com/us/app/ge-shang-ji-jin-ge-shang-li/id1112389855";
//        }
//        
//        return __appstore_comment_address;
//    }
//}

@end
