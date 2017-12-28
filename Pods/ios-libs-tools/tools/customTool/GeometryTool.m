//
//  MathTool.m
//  gezilicai
//
//  Created by 7heaven on 16/4/1.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#include "GeometryTool.h"

extern CGPoint centerRadiusPoint(int centerX, int centerY, CGFloat angle, CGFloat radius){
    CGFloat x = (CGFloat) (radius * cos(angle) + centerX);
    CGFloat y = (CGFloat) (radius * sin(angle) + centerY);
    
    return CGPointMake(x, y);
}

extern CGPoint segLine(CGFloat x0, CGFloat y0, CGFloat x1, CGFloat y1, CGFloat ratio){
    CGFloat dx = x1 - x0;
    CGFloat dy = y1 - y0;
    
    dx *= ratio;
    dy *= ratio;
    
    return CGPointMake(x0 + dx, y0 + dy);
}

extern CGFloat distance(CGPoint p0, CGPoint p1){
    CGFloat dx = p1.x - p0.x;
    CGFloat dy = p1.y - p0.y;
    
    return sqrt(dx * dx + dy * dy);
}
