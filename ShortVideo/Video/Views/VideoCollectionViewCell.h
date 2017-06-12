//
//  VideoCollectionViewCell.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/27.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;

@interface VideoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *videoDuration;

- (void)setValueWithModel:(VideoModel *)model;

@end
