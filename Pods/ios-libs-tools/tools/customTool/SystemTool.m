//
//  SystemTool.m
//  gezilicai
//
//  Created by 7heaven on 16/3/2.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#include "SystemTool.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#define MIB_SIZE 2

NSTimeInterval getSystemBootTime(){
    int mib[MIB_SIZE];
    size_t size;
    struct timeval  boottime;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, MIB_SIZE, &boottime, &size, NULL, 0) != -1)
    {
        // successful call
        return boottime.tv_sec;
        
        
        
    }
    
    return 0;
}
