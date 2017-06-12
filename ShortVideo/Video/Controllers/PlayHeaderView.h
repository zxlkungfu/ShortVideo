//
//  PlayHeaderView.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/8.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKWebView;

@interface PlayHeaderView : UIView

@property (nonatomic, strong) WKWebView *videoView;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *ownerName;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *attentionButton;
//@property (nonatomic, strong) UIView *separateLine;

@end
