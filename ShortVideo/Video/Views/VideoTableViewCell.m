//
//  VideoTableViewCell.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "VideoModel.h"

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithModel:(VideoModel *)model {
    self.username.text = model.username;
    self.videoTitle.text = model.title;
}

@end
