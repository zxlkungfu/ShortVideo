//
//  CommentViewController.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/10.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

/**
 username:回复某个用户，或者自己撰写评论
 url:当前的视频路径
 comment:某个用户的评论
 */
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *comment;
@property (strong, nonatomic) IBOutlet UITextView *contentView;
- (IBAction)submit:(UIButton *)sender;

@end
