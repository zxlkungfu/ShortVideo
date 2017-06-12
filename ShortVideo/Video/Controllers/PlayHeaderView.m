//
//  PlayHeaderView.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/8.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "PlayHeaderView.h"
#import <WebKit/WebKit.h>

@implementation PlayHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor tabSelectedColor];
        CGFloat height = Screen_Width/16.0*9.0;
        _videoView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, height)];
        [self addSubview:_videoView];
        _videoView.scrollView.scrollEnabled = NO;
//        _videoView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        // 40: :80: :60: = screenwidth;
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, height+5, 50, 50)];
        [self addSubview:_headerImage];
        _headerImage.layer.cornerRadius = 25;
        _headerImage.layer.masksToBounds = YES;
        
        _ownerName = [[UILabel alloc] initWithFrame:CGRectMake(60, height+5, Screen_Width - 70, 20)];
        [self addSubview:_ownerName];
//        _ownerName.textAlignment = NSTextAlignmentCenter;
        _ownerName.textColor = [UIColor whiteColor];
//        _ownerName.backgroundColor = [UIColor orangeColor];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.frame = CGRectMake(Screen_Width/3.0-10, height+25, 80, 30);
        [_commentButton setTitle:@"撰写评论" forState:UIControlStateNormal];
        
        [self addSubview:_commentButton];
        
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        _attentionButton.frame = CGRectMake(Screen_Width/3.0*2.0, height+25, 60, 30);
        [self addSubview:_attentionButton];
//        _attentionButton.backgroundColor = [UIColor redColor];
//        _commentButton.backgroundColor = [UIColor greenColor];
        
//        _separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, height+58, Screen_Width, 2)];
//        [self addSubview:_separateLine];
//        
//        _separateLine.backgroundColor = [UIColor separateColor];
    }
    return self;
}

@end
