//
//  CustomTableViewCell.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/30.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

/**
 为了解决带有tableFooterView的tableView最后一行没有分割线的问题
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subView in self/*.contentView.superview*/.subviews) {
        if ([NSStringFromClass(subView.class) hasSuffix:@"SeparatorView"]) {
            if (subView.hidden) {
                subView.hidden = NO;
//                CGRect frame = subView.frame;
//                frame.origin.x += self.separatorInset.left;
//                frame.size.width -= (self.separatorInset.right + frame.origin.x);
//                subView.frame = frame;
                
            }

        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect {
//    CGRect frame = self.frame;
//    UIImage *image = self.imageView.image;
//    CGSize imageSize = CGSizeMake(44, 44);
//    UIGraphicsBeginImageContext(imageSize);
////    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    
//    CGRect imageRect = CGRectMake(0, 0, 44, 44);
//    [image drawInRect:imageRect];
////    [image drawAsPatternInRect:imageRect];
//    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.frame = frame;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.layer.cornerRadius = 22;
//    self.imageView.layer.masksToBounds = YES;
//    NSLog(@"重绘后%@-%@", [NSValue valueWithCGRect:self.imageView.frame], [NSValue valueWithCGRect:self.frame]);
//    
//}

@end
