//
//  UIColor+Custom.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)


/**
 枣红色

 @return UIColor OBJ
 */
+ (UIColor *)garnetColor; // 枣红色

/**
 传统绿

 @return UIColor obj
 */
+ (UIColor *)tradGreen;


/**
 海水蓝

 @return <#return value description#>
 */
+ (UIColor *)navyBlue;


/**
 十进制三原色

 @param red 红色0-255
 @param green 绿色0-255
 @param blue 蓝色0-255
 @return UIColor
 */
+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue;


/**
 背景色

 @return 背景色
 */
+ (UIColor *)bkColor;


/**
 分割线的颜色

 @return UIColor
 */
+ (UIColor *)separateColor;


/**
 导航条颜色

 @return UIColor
 */
+ (UIColor *)navColor;


/**
 标签颜色

 @return UIColor
 */
+ (UIColor *)tabColor;


/**
 标签栏选中的颜色

 @return UIColor
 */
+ (UIColor *)tabSelectedColor;

@end
