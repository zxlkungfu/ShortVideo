//
//  VideoCollectionViewCell.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/27.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "VideoModel.h"

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoImage.layer.cornerRadius = 10;
    self.videoImage.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setValueWithModel:(VideoModel *)model {
    self.videoTitle.text = model.title;
    [self.videoImage setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.username.text = model.username;
    self.videoDuration.text = model.duration;
//    self.videoDuration.text = [self calculDuration:model.duration];
}




@end
