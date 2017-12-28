//
//  CGTool.h
//  gezilicai
//
//  Created by 7heaven on 16/3/1.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#ifndef gezilicai_CGTool
#define gezilicai_CGTool

/**
 *
 * 增加CoreGraphics库不提供的绘制方法
 *
 */

/**
 * 绘制圆角矩形
 *
 * @param rect 矩形范围
 * @param radius 圆角大小
 *
 */
CG_EXTERN void CGContextAddRoundRect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 绘制圆角正多边形
 *
 * @param rect 多边形的外包矩形
 * @param cornerRadius 圆角大小
 *
 */
CG_EXTERN void CGContextAddPolygon(CGContextRef context, int count, CGRect rect, CGFloat cornerRadius);

/**
 * 绘制圆角星型
 *
 * @param rect 星型的外包矩形
 * @param cornerRadius 圆角大小
 * @param asStar 是否绘制成星型 NO的时候绘制结果和CGContextAddPolygon相同
 * @param startRatio 星型凹角到中心的距离 / 星型凸角到中心的距离
 *
 */
CG_EXTERN void CGContextAddStar(CGContextRef context, int count, CGRect rect, CGFloat cornerRadius, BOOL asStar, CGFloat starRatio);

CG_EXTERN void CGContextDrawGradientOnRect(CGContextRef context, CGRect rect, NSArray<UIColor *> *colors);
CG_EXTERN void CGContextDrawGradientOnRectOnDirection(CGContextRef context, CGRect rect, NSArray<UIColor *> *colors,  BOOL horLinear);

#endif
