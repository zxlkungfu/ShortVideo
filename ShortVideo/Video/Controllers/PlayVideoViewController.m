//
//  PlayVideoViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/9.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "PlayHeaderView.h"
#import <WebKit/WebKit.h>
#import "UserModel.h"
#import "CommentModel.h"
#import "UserViewController.h"
#import "CommentViewController.h"

#import "CommentTableViewCell.h"
#define commentCellIdentifier @"commentCellIdentifier"

@interface PlayVideoViewController () <WKNavigationDelegate, UITableViewDataSource>

{
    PlayHeaderView *_headerView;
    UIButton *_forwardButton;
    UIButton *_shareButton;
    UITableView *_tableView;
    UserModel *_commentatorModel;
}

@end

@implementation PlayVideoViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [self getCommentData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createHeaderView];
    [self setToolBar];
    [self createTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCommentData {
    
    [Request getCommentWithURL:@"getComment.php" parameters:@{@"url":self.videoPath} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            NSArray *tempArray = [data objectForKey:@"data"];
            _commentArray = [NSMutableArray array];
            for (NSDictionary *dict in tempArray) {
                NSError *error = nil;
                CommentModel *model = [[CommentModel alloc] initWithDictionary:dict error:&error];
                if (!error) {
                   [_commentArray addObject:model];
                }
            }
            [_tableView reloadData];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}

- (void)createTableView {
    CGFloat Y = Screen_Width/16.0*9.0+60;
    CGRect frame = CGRectMake(0, Y, Screen_Width, Screen_Height - Y);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, Screen_Width, 100)];
    label.text = @"没有更多评论";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor tabSelectedColor];
    _tableView.tableFooterView = label;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    cell.commentContent.backgroundColor = [UIColor separateColor];
    
    CommentModel *model = _commentArray[indexPath.row];
    [cell setValueWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jumpToUserVC = ^ {
        [self setCommentatorModelAndJumpWithName:model.username];
    };
    
    cell.jumpToCommentVC = ^{
        CommentViewController *vc = [[CommentViewController alloc] init];
        vc.url = self.videoPath;
        vc.username = model.username;
        vc.comment = model.content;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)setCommentatorModelAndJumpWithName: (NSString *)name {
    [Request getInfoWithURL:@"getInfo.php" parameters:@{@"username":name} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            UserViewController *vc = [[UserViewController alloc] init];
            NSError *error;
            NSDictionary *dict = [data objectForKey:@"data"];
            UserModel *model = [[UserModel alloc] initWithDictionary:dict error:&error];
            if (!error) {
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}

- (void)createHeaderView {
    _headerView = [[PlayHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width/16.0*9.0+60)];
    
    _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forwardButton.frame = CGRectMake(20, 20, 40, 40);
    [_forwardButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_forwardButton addTarget:self action:@selector(forwardButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(Screen_Width-60, 20, 40, 40);
    [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _headerView.videoView.navigationDelegate = self;
    
    [_headerView addSubview:_forwardButton];
    [_headerView addSubview:_shareButton];
    [self.view addSubview:_headerView];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.videoPath]];
//    [_headerView.videoView loadRequest:request];
    
        NSString *htmlString = [self createHTMLString];
        [_headerView.videoView loadHTMLString:htmlString baseURL:nil];
}

- (void)shareButtonClick {
    NSArray *items = @[self.videoTitle, [NSURL URLWithString:self.videoPath]];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    shareController.excludedActivityTypes = @[UIActivityTypePostToTwitter, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeOpenInIBooks, UIActivityTypePostToFacebook];
    [self presentViewController:shareController animated:NO completion:nil];
}

- (void)setToolBar {
    [_headerView.headerImage setImageWithURL:[NSURL URLWithString:self.model.headerURL] placeholderImage:[UIImage imageNamed:@"placeHeader.png"]];
    _headerView.ownerName.text = [NSString stringWithFormat:@"所有者名字：%@", self.model.username];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSDictionary *param = @{
                            @"username":username,
                            @"currentName":self.model.username
                            };
    [Request isAttentionWithURL:@"isAttention.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            [_headerView.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            [_headerView.attentionButton setTitle:@"未关注" forState:UIControlStateNormal];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
    if ([username isEqualToString:self.model.username]) {
        _headerView.attentionButton.hidden = YES;
    }
    
    [_headerView.attentionButton addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToUserVC)];
    _headerView.headerImage.userInteractionEnabled = YES;
    [_headerView.headerImage addGestureRecognizer:tap];
    
    
    [_headerView.commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commentButtonClick {
    CommentViewController *vc = [[CommentViewController alloc] init];
    NSString *currentName = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    vc.username = currentName;
    vc.url = self.videoPath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToUserVC {
    UserViewController *vc = [[UserViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"webView进程出错");
}

- (void)forwardButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)attentionClick:(UIButton *)sender {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSDictionary *param = @{@"username":username,
                            @"friend":self.model.username};
    if ([sender.titleLabel.text isEqualToString:@"已关注"]) {
        
        
        [Request cancelAttentionWithURL:@"cancelAttention.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
            if (success) {
               [sender setTitle:@"未关注" forState:UIControlStateNormal];
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }
            
        } andFailureBolck:^(NSError *error) {
            
        }];
    } else {
        [Request playAttentionWithURL:@"playAttention.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
            if (success) {
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            }
        } andFailureBolck:^(NSError *error) {
            
        }];
    }
    }

- (NSString *)createHTMLString {
    NSString *htmlString = @"<!DOCTYPE html> <head> \
    <title></title> \
    <meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /> \
    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\" /> \
    </head> \
    <body> \
    <video width = '100%' poster = \" ";
    htmlString = [htmlString stringByAppendingString:self.imagePath];
    NSString *midString =  @"\" preload width = '100%' controls webkit-playsinline autoplay> <source src = \"";
    htmlString = [htmlString stringByAppendingString:midString];
    
    htmlString = [htmlString stringByAppendingString:self.videoPath];
    NSString *lastString = @" \"></video></body>";
    htmlString = [htmlString stringByAppendingString:lastString];
    return htmlString;
}
@end
