//
//  UserViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/31.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "UserViewController.h"
#import "UserModel.h"
#import "CommentModel.h"
#import "UserTableViewCell.h"
#import "VideoModel.h"
#import "PlayVideoViewController.h"
#define UserCellIdentifier @"UserCellIdentifier"


@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *attentionCount;
@property (strong, nonatomic) IBOutlet UILabel *fansCount;

- (IBAction)attentionClick:(UIButton *)sender;

@end

@implementation UserViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self calculAttentionAndFansCount];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUsernameAndImage];
    [self setAttentionButtonStatus];
    [self createTableView];
    [self requestVideoData];
}

- (void)calculAttentionAndFansCount {
    [Request listFriendWithURL:@"listFriendAndFans.php" parameters:@{@"username":self.model.username} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            NSArray *tempFriends = [data valueForKeyPath:@"data.friends"];
            NSArray *tempFans = [data valueForKeyPath:@"data.fans"];
            self.attentionCount.text = [NSString stringWithFormat:@"%d", (int)(tempFriends.count)];
            self.fansCount.text = [NSString stringWithFormat:@"%d", (int)(tempFans.count)];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}

- (void)setAttentionButtonStatus {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSDictionary *param = @{
                            @"username":username,
                            @"currentName":self.model.username
                            };
    [Request isAttentionWithURL:@"isAttention.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            [self.attentionButton setTitle:@"未关注" forState:UIControlStateNormal];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
    if ([username isEqualToString:self.model.username]) {
        self.attentionButton.hidden = YES;
    }
}

- (void)setUsernameAndImage {
    self.username.text = self.model.username;
    [self.headerImage setImageWithURL:[NSURL URLWithString:self.model.headerURL] placeholderImage:[UIImage imageNamed:@"placeHeader.png"]];
    self.headerImage.layer.cornerRadius = 30;
    self.headerImage.layer.masksToBounds = YES;
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, Screen_Width, Screen_Height-150)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:UserCellIdentifier];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, Screen_Width, 100)];
    label.text = @"没有更多动态";
    label.textColor = [UIColor tabSelectedColor];
    label.textAlignment = NSTextAlignmentCenter;
    _tableView.tableFooterView = label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)attentionClick:(UIButton *)sender {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSDictionary *param = @{@"username":username,
                            @"friend":self.model.username};
    if ([sender.titleLabel.text isEqualToString:@"已关注"]) {
        
        
        [Request cancelAttentionWithURL:@"cancelAttention.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
            if (success) {
                sender.titleLabel.text = @"未关注";
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }
            
        } andFailureBolck:^(NSError *error) {
            
        }];
    } else {
        [Request playAttentionWithURL:@"playAttention.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
            if (success) {
                sender.titleLabel.text = @"已关注";
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            }
        } andFailureBolck:^(NSError *error) {
            
        }];
    }
}

- (void)requestVideoData {
    [Request listVideoWithURL:@"listVideo.php" parameters:@{@"where":self.model.username} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            NSArray *tempArray = [data objectForKey:@"data"];
            _dataArray = [NSMutableArray array];
            for (NSDictionary *dict in tempArray) {
                NSError *error;
                VideoModel *model = [[VideoModel alloc] initWithDictionary:dict error:&error];
                if (error == nil) {
                    [_dataArray addObject:model];
                }
            }
            [_tableView reloadData];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *model = _dataArray[indexPath.row];
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValueWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayVideoViewController *playVideoVC = [[PlayVideoViewController alloc] init];
    VideoModel *model = _dataArray[indexPath.row];
    playVideoVC.videoPath = model.url;
    playVideoVC.imagePath = model.imgURL;
    playVideoVC.videoTitle = model.title;
    
    [Request getInfoWithURL:@"getInfo.php" parameters:@{@"username":model.username} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            NSError *error;
            NSDictionary *dict = [data objectForKey:@"data"];
            UserModel *owner = [[UserModel alloc] initWithDictionary:dict error:&error];
            if (error == nil) {
                playVideoVC.model = owner;
                [self.navigationController pushViewController:playVideoVC animated:YES];
            }
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
    
}

@end
