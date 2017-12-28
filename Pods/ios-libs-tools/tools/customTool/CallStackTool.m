//
//  CallStackTool.m
//  gezilicai
//
//  Created by 7heaven on 2/17/16.
//  Copyright © 2016 yuexue. All rights reserved.
//

#import "CallStackTool.h"

@implementation CallStackTool

+ (void *) whoCalledMe{
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:2];
    // Example: 1   UIKit                               0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    
    NSLog(@"all_stack:%@", [NSThread callStackSymbols]);
    
    NSLog(@"Stack = %@", [array objectAtIndex:0]);
    NSLog(@"Framework = %@", [array objectAtIndex:1]);
    NSLog(@"Memory address = %@", [array objectAtIndex:2]);
    NSLog(@"Class caller = %@", [array objectAtIndex:3]);
    NSLog(@"Function caller = %@", [array objectAtIndex:4]);
    
    void *result_ptr;
    
    sscanf([[array objectAtIndex:2] cStringUsingEncoding:NSUTF8StringEncoding], "%p", &result_ptr);
    
    return result_ptr;
}

+ (void *) trackBackTo:(int) level{
    return NULL;
}

@end
