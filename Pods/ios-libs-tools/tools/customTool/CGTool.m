//
//  CGTool.m
//  gezilicai
//
//  Created by 7heaven on 16/3/1.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#include "CGTool.h"
#include "GeometryTool.h"
#include "math.h"

#define ANGLE_START -M_PI_2

void CGContextAddRoundRect(CGContextRef context, CGRect rect, CGFloat radius)
{
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                    radius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                    rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                    radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                    -M_PI / 2, M_PI, 1);
}

void CGContextAddPolygon(CGContextRef context, int count, CGRect rect, CGFloat cornerRadius){
    CGContextAddStar(context, count, rect, cornerRadius, NO, 0.0F);
}
void CGContextAddStar(CGContextRef context, int count, CGRect rect, CGFloat cornerRadius, BOOL asStar, CGFloat starRatio){
    
    //绘制正多边形 正多边形的相邻顶点到外接圆圆心连线形成的夹角相等，所以只需pi * 2 / 顶点数量 得到相邻顶点间的夹角，然后从角度0开始 夹角递增得到每一个顶点到外接圆圆心连线的角度，并通过半径和角度得到顶点的位置，然后把相邻的顶点连线得到一个正多边形
    //绘制星型 只需要在正多边形的基础上获取相邻两个顶点夹角一半的角度，并结合半径 * starRatio计算出星型凹角的顶点坐标 然后把前一个正多边形顶点连线到新计算出来的凹角顶点坐标 再连接到下一个正多边形顶点
    
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    CGFloat radius = rect.size.width > rect.size.height ? centerY : centerX;
    
    //当前角度，起始点为-pi/2，即为矩形的正上方
    CGFloat angle = ANGLE_START;
    
    //根据边数得出多边形相邻两个顶点到中心连线的角度
    CGFloat angleStep = M_PI * 2 / count;
    
    //两个顶点间角度的一半，用于绘制星型（绘制星型时候）
    CGFloat halfStep = angleStep * 0.5F;
    CGPoint positions;
    
    //如果cornerRadius为零，避开不必要的计算
    if(cornerRadius == 0){
        positions = centerRadiusPoint(centerX, centerY, angle, radius);
        CGContextMoveToPoint(context, positions.x, positions.y);
        if(asStar){
            positions = centerRadiusPoint(centerX, centerY, angle, radius);
            CGContextAddLineToPoint(context, positions.x, positions.y);
        }
        for(int i = 0; i < count - 1; i++){
            angle += angleStep;
            positions = centerRadiusPoint(centerX, centerY, angle, radius);
            CGContextAddLineToPoint(context, positions.x, positions.y);
            
            if(asStar){
                positions = centerRadiusPoint(centerX, centerY, angle + halfStep, radius * starRatio);
                CGContextAddLineToPoint(context, positions.x, positions.y);
            }
        }
    }else{
        //               (
        //                \
        //    /\  <----    )  绘制圆角的多边形， 每个角包含一条曲线和一条直线，曲线用来实现圆角 直线用来连接下一个角，曲线的控制点为原角的顶点，
        //    \/          /    起点和终点分别是以corner为百分比取到得两边线段上的点（绘制星型多边形时 对 凹角做类似处理）
        //
        
        CGPoint startP = centerRadiusPoint(centerX, centerY, angle - (asStar ? halfStep : angleStep), asStar ? radius * starRatio : radius);
        CGPoint centerP = centerRadiusPoint(centerX, centerY, angle, radius);
        CGPoint endP = centerRadiusPoint(centerX, centerY, angle + (asStar ? halfStep : angleStep), asStar ? radius * starRatio : radius);
        
        CGFloat lineDistance = distance(startP, centerP);
        CGFloat rCornerRadius = cornerRadius / lineDistance;
        
        CGPoint bezierStart = segLine(centerP.x, centerP.y, startP.x, startP.y, rCornerRadius);
        CGPoint bezierEnd = segLine(centerP.x, centerP.y, endP.x, endP.y, rCornerRadius);
        
        CGPoint nextStart = segLine(endP.x, endP.y, centerP.x, centerP.y, rCornerRadius);
        
        CGContextMoveToPoint(context, bezierStart.x, bezierStart.y);
        CGContextAddQuadCurveToPoint(context, centerP.x, centerP.y, bezierEnd.x, bezierEnd.y);
        CGContextAddLineToPoint(context, nextStart.x, nextStart.y);
        
        int cpIndex = 0;
        
        if(asStar){
            cpIndex += 3;
            centerP.x = endP.x, centerP.y = endP.y;
            
            endP = centerRadiusPoint(centerX, centerY, angle + angleStep, radius);
            bezierEnd = segLine(centerP.x, centerP.y, endP.x, endP.y, rCornerRadius);
            nextStart = segLine(endP.x, endP.y, centerP.x, centerP.y, rCornerRadius);
            
            CGContextAddQuadCurveToPoint(context, centerP.x, centerP.y, bezierEnd.x, bezierEnd.y);
            CGContextAddLineToPoint(context, nextStart.x, nextStart.y);
        }
        
        for(int i = 0; i < count - 1; i++){
            cpIndex += 3;
            
            angle += angleStep;
            centerP.x = endP.x, centerP.y = endP.y;
            
            endP = centerRadiusPoint(centerX, centerY, angle + (asStar ? halfStep : angleStep), asStar ? radius * starRatio : radius);
            bezierEnd = segLine(centerP.x, centerP.y, endP.x, endP.y, rCornerRadius);
            nextStart = segLine(endP.x, endP.y, centerP.x, centerP.y, rCornerRadius);
            
            CGContextAddQuadCurveToPoint(context, centerP.x, centerP.y, bezierEnd.x, bezierEnd.y);
            CGContextAddLineToPoint(context, nextStart.x, nextStart.y);
            
            if(asStar){
                cpIndex += 3;
                centerP.x = endP.x, centerP.y = endP.y;
                
                endP = centerRadiusPoint(centerX, centerY, angle + angleStep, radius);
                bezierEnd = segLine(endP.x, endP.y, centerP.x, centerP.y, rCornerRadius);
                nextStart = segLine(endP.x, endP.y, centerP.x, centerP.y, rCornerRadius);
                
                CGContextAddQuadCurveToPoint(context, centerP.x, centerP.y, bezierEnd.x, bezierEnd.y);
                CGContextAddLineToPoint(context, nextStart.x, nextStart.y);
            }
        }
    }
}

void CGContextDrawGradientOnRect(CGContextRef context, CGRect rect, NSArray<UIColor *> *colors){
    CGContextDrawGradientOnRectOnDirection(context,rect,colors,YES);
}

void CGContextDrawGradientOnRectOnDirection(CGContextRef context, CGRect rect, NSArray<UIColor *> *colors, BOOL horLinear){
    if(context && colors && colors.count > 0){
        if (colors.count < 2) {
            UIColor *color = colors[0];
            CGContextAddRect(context, rect);
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillPath(context);
        }else{
            CGFloat colorcpnts[colors.count * 4];
            for(int i = 0; i < colors.count; i++){
                CGColorRef color = colors[i].CGColor;
                size_t numberOfComponent = CGColorGetNumberOfComponents(color);
                const CGFloat *components = CGColorGetComponents(color);
                
                colorcpnts[i * 4] = components[0];
                colorcpnts[i * 4 + 1] = components[1];
                colorcpnts[i * 4 + 2] = components[2];
                colorcpnts[i * 4 + 3] = numberOfComponent == 4 ? components[3] : 1.0F;
            }
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorcpnts, NULL, colors.count);
            CGColorSpaceRelease(colorSpace);
            colorSpace = NULL;
            
            CGContextSaveGState(context);
            CGContextAddRect(context, rect);
            CGContextClip(context);
            
            CGPoint startPoint = CGPointZero;
            CGPoint endPoint = CGPointZero;
            
            if (horLinear) {
                startPoint = CGPointMake(rect.origin.x, 0);
                endPoint = CGPointMake(rect.origin.y + rect.size.width, 0);
            }else{
                startPoint = CGPointMake( 0.,rect.origin.y);
                endPoint = CGPointMake(0., rect.origin.y+rect.size.height);
            }
            
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
            CGGradientRelease(gradient);
            gradient = NULL;
            
            CGContextRestoreGState(context);
        }
    }
}
