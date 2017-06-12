//
//  VideoTableViewCell.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoModel;

@interface VideoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *usernameImage;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparate;
@property (strong, nonatomic) IBOutlet UIView *topSeparate;

- (void)setValueWithModel:(VideoModel *)model;

@end
