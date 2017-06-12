//
//  UserTableViewCell.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/12.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoModel;

@interface UserTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *date;

- (void)setValueWithModel:(VideoModel *)model;

@end
