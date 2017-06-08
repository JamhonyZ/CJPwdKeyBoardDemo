//
//  UIButton+EnlargeEdge.h
//  WenLingCitizenCard
//
//  Created by 创建zzh on 2017/3/7.
//  Copyright © 2017年 zhusf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)
/**
 * 扩大按钮热响应区域 size 四边扩大的数值 
 * [defaultBtn setEnlargeEdge:10];  效果是点击按钮四周10像素之内都可以响应点击的方法
 */
- (void)setEnlargeEdge:(CGFloat)size;

/**
 * 扩大按钮热响应区域 各个边扩大的数值
 * 同上四个边 分别设值
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat) bottom left:(CGFloat)left;

@end
