//
//  CallStackTool.h
//  gezilicai
//
//  Created by 7heaven on 2/17/16.
//  Copyright © 2016 yuexue. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct{
    
}CallInfo;

@interface CallStackTool : NSObject

+ (void *) whoCalledMe;


+ (void *) trackBackTo:(int) level;

@end
