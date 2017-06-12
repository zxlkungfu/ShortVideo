//
//  UploadVideoViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/1.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "UploadVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UploadVideoViewController () <UITextFieldDelegate>

{
    UIActivityIndicatorView * _indicatorView;
}

@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UITextField *videoTitle;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *videoSize;
@property (strong, nonatomic) IBOutlet UILabel *date;


@property (strong, nonatomic) IBOutlet UIButton *submit;

@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *videoURL;

- (IBAction)publish:(UIButton *)sender;

@end

@implementation UploadVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageAndVideoPathComplete:) name:KGetImageAndVideoPathComplete object:nil];
    self.submit.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KGetImageAndVideoPathComplete object:nil];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoTitle.delegate = self;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:_indicatorView];
    [_indicatorView startAnimating];
    // 大小、时长、图片
    self.videoSize.text = [self getFileSize:self.videoPath];
    self.duration.text = [self getVideoLength:self.videoSource];
    self.date.text = [self getDateString];
    self.thumbnail.image = [self getImage:self.videoSource];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSData *imageData = UIImagePNGRepresentation(self.thumbnail.image);
    NSData *videoData = [NSData dataWithContentsOfURL:self.videoSource];
    
    // 上传图片获取网址， 上传视频获取网址
    [Request uploadFileWithURL:@"uploadFile.php" parameters:@{@"username":username} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            
            self.imageURL = [data objectForKey:@"data"];
//            NSLog(@"%@", self.imageURL);
            [Request uploadFileWithURL:@"uploadFile.php" parameters:@{@"username":username} andSuccessBlock:^(BOOL success, id data) {
                if (success) {
                    self.videoURL = [data objectForKey:@"data"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KGetImageAndVideoPathComplete object:nil];
                }
            } andFailureBolck:nil andStatus:@"" andMimeType:@"video/quicktime" andData:videoData andExtension:@"MOV"];
            
            
        }
    } andFailureBolck:^(NSError *error) {
        
    } andStatus:@"" andMimeType:@"image/png" andData:imageData andExtension:@"png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)getImageAndVideoPathComplete:(NSNotification *)note {
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    self.submit.hidden = NO;
}

//获取视频文件的时长。
- (NSString *)getVideoLength:(NSURL *)URL{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return [self calculDuration:(int)second];
}


- (NSString *)calculDuration:(int)duration {
    int h, m, s;
    s = duration % 60;
    h = duration / 3600;
    m = (duration - h*3600 - s) / 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}


//获取视频文件的大小，返回的是单位是M。
- (NSString *)getFileSize:(NSString *)path{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = (1.0*size/1024)/1024.0;
        
    }
    return [NSString stringWithFormat:@"%0.2fM", filesize];
}

//获取本地视频缩略图，网上说需要添加AVFoundation.framework
- (UIImage *)getImage:(NSURL *)URL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}


- (IBAction)publish:(UIButton *)sender {
    
    NSArray *video = @[
                       @{@"title":self.videoTitle.text},
                       @{@"date":self.date.text},
                       @{@"duration":self.duration.text},
                       @{@"url":self.videoURL},
                       @{@"imgURL":self.imageURL}
                       ];
//    NSLog(@"%@", video);
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSDictionary *param = @{@"username":username,
                           @"video":video};
    
    [SVProgressHUD showWithStatus:@"正在上传..."];
    [Request uploadVideoWithURL:@"uploadVideo.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        [SVProgressHUD dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    } andFailureBolck:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (NSString *)getDateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];
    df.locale = [NSLocale systemLocale];
    [df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [df stringFromDate:[NSDate date]];
}

@end
