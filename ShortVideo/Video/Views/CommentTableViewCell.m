//
//  CommentTableViewCell.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/10.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.commentatorHeader.userInteractionEnabled = YES;
    self.commentatorHeader.layer.cornerRadius = 20;
    self.commentatorHeader.layer.masksToBounds = YES;
    UITapGestureRecognizer *clickHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToUserCenter)];
    [self.commentatorHeader addGestureRecognizer:clickHeader];
    
    UITapGestureRecognizer *replay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reply)];
    [self.commentContent addGestureRecognizer:replay];
    
}

- (void)jumpToUserCenter {
    if (self.jumpToUserVC) {
        self.jumpToUserVC();
    }
}

- (void)reply {
    if (self.jumpToCommentVC) {
        self.jumpToCommentVC();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithModel:(CommentModel *)model {
    [self.commentatorHeader setImageWithURL:[NSURL URLWithString:model.headerURL] placeholderImage:[UIImage imageNamed:@"placeHeader"]];
    self.commentatorName.text = model.username;
    self.commentDate.text = model.date;
//    self.commentContent.text = model.content;
    NSString *regex = @"@*:";
    NSRange range = [model.content rangeOfString:regex options:NSRegularExpressionSearch];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.content];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor tabSelectedColor] range:range];
    self.commentContent.attributedText = str;
    
}

@end
