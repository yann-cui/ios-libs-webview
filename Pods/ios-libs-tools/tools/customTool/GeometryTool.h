//
//  MathTool.h
//  gezilicai
//
//  Created by 7heaven on 16/4/1.
//  Copyright © 2016年 yuexue. All rights reserved.
//

#ifndef gezilicai_GeometryTool
#define gezilicai_GeometryTool

/**
 * 根据圆心和半径，计算出圆上角度为angle的点坐标
 *
 * @param centerX 圆心X坐标
 * @param centerY 圆心Y坐标
 * @param angle 需要计算的点到圆心连线与以圆心为原点的坐标轴上X轴正方向之间的夹角
 * @param radius 圆的半径
 * 
 */
extern CGPoint centerRadiusPoint(int centerX, int centerY, CGFloat angle, CGFloat radius);

/**
 * 得到x0,y0-x1,y1线段上到x0,y0的距离 / 整个线段距离等于radio的点坐标
 * 
 * @param x0 起点x坐标
 * @param y0 起点y坐标
 * @param x1 终点x坐标
 * @param y1 终点y坐标
 * @param ratio 比率
 *
 */
extern CGPoint segLine(CGFloat x0, CGFloat y0, CGFloat x1, CGFloat y1, CGFloat ratio);

/**
 * 得到两个点之间的距离
 * 
 * @param p0 起点
 * @param p1 终点
 *
 */
extern CGFloat distance(CGPoint p0, CGPoint p1);


#endif
