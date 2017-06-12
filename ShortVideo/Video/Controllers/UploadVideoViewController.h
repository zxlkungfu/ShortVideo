//
//  UploadVideoViewController.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/1.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadVideoViewController : UIViewController

@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, strong) NSURL *videoSource;

@end
