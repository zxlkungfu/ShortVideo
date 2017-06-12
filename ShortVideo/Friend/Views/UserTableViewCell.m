//
//  UserTableViewCell.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/12.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "UserTableViewCell.h"
#import "VideoModel.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithModel:(VideoModel *)model {
    [self.photoImage setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.title.text = model.title;
    self.duration.text = model.duration;
    self.date.text = [model.date substringToIndex:10];
    self.separatorView.backgroundColor = [UIColor tabSelectedColor];
}

@end
