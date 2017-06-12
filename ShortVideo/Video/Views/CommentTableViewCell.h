//
//  CommentTableViewCell.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/10.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;

@interface CommentTableViewCell : UITableViewCell

typedef void (^JumpToUserVC)();
typedef void (^JumpToCommentVC)();

@property (nonatomic, copy) JumpToUserVC jumpToUserVC;
@property (nonatomic, copy) JumpToCommentVC jumpToCommentVC;

@property (strong, nonatomic) IBOutlet UIImageView *commentatorHeader;
@property (strong, nonatomic) IBOutlet UILabel *commentatorName;
@property (strong, nonatomic) IBOutlet UILabel *commentDate;
@property (strong, nonatomic) IBOutlet UILabel *commentContent;
@property (strong, nonatomic) IBOutlet UIView *separateView;

- (void)setValueWithModel:(CommentModel *)model;

@end
