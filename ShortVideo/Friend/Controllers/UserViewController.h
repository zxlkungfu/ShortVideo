//
//  UserViewController.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/31.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel, CommentModel;

@interface UserViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *attentionButton;


/**
 1.好友界面，点击当前用户，跳转至UserVC页面，不显示关注按钮
 2.好友界面，点击关注或粉丝，跳转至UserVC页面，显示关注按钮
 3.视频界面点击某个视频，根据视频的所有者，判断是否显示关注按钮
（1）当前用户，不显示
 （2）已经关注用户，显示“已关注”
 （3）未关注用户，显示“未关注”
 总结，调用isAttention.php接口，进行判定
 */
@property (nonatomic, strong) UserModel *model;



@end
