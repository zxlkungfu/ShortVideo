//
//  UIColor+Custom.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)


+ (UIColor *)navColor {
    return [UIColor colorWithRed:0 green:191 blue:255];
}

+ (UIColor *)tabColor {
    return [UIColor whiteColor];
}

+ (UIColor *)tabSelectedColor{
    return [UIColor colorWithRed:0 green:206 blue:209];
}
/**
 枣红色

 @return UIColor OBJ
 */


+ (UIColor *)garnetColor {
//    return [UIColor colorWithRed:149 green:0 blue:6];
    return [UIColor colorWithRed:47 green:79 blue:79];
}

+ (UIColor *)tradGreen {
    return [UIColor colorWithRed:0 green:102/255.0 blue:51/255.0 alpha:1.0];
}

+ (UIColor *)navyBlue {
    return [UIColor colorWithRed:0 green:0 blue:128/255.0 alpha:1.0];
}

+ (UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (UIColor *)bkColor {
//    return [UIColor colorWithRed:0 green:128 blue:128];
//    return [UIColor colorWithRed:173 green:255 blue:47];
    return [UIColor whiteColor];
}

+ (UIColor *)separateColor {
//    return [UIColor colorWithRed:0 green:140 blue:140];
    return [UIColor colorWithRed:220 green:220 blue:220];
//    return [UIColor yellowColor];
}


@end
