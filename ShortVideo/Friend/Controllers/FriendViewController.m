//
//  FriendViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "FriendViewController.h"
#import "UserModel.h"
#import "CustomTableViewCell.h"
#import "UserViewController.h"

@interface FriendViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray<UserModel *> *_friendsArray;
    NSMutableArray<UserModel *> *_fansArray;
    UserModel *_model;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *username;

@end

@implementation FriendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.username.textColor = [UIColor tabSelectedColor];
    [self postData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self setTableFooterView];
    [self setTableHeaderView];
    [self setPullRefresh];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor tabSelectedColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
}

- (void)setPullRefresh {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self postData];
        dispatch_time_t dely = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(dely, dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
        });
    }];
}

- (void)setTableFooterView {
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.text = @"没有更多";
    footerLabel.textColor = [UIColor tabSelectedColor];
    _tableView.tableFooterView = footerLabel;
}

- (void)setTableHeaderView {
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil].lastObject;
    CGRect frame = self.headerView.frame;
    frame.size.height = 80;
    self.headerView.frame = frame;
    _tableView.tableHeaderView = self.headerView;
    self.headerImage.layer.cornerRadius = 30;
    self.headerImage.layer.masksToBounds = YES;
    NSString *headerImage = [[NSUserDefaults standardUserDefaults] objectForKey:KHeaderImage];
    
    [self.headerImage setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"placeHeader.png"]];
    
    [self addHeaderViewTap];
}

- (void)addHeaderViewTap {
    self.headerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)];
    [self.headerImage addGestureRecognizer:tap];
    
    UITapGestureRecognizer *headerViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap)];
    [self.headerView addGestureRecognizer:headerViewTap];
    [self.username addGestureRecognizer:headerViewTap];
}

- (void)postData {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    if (username.length > 0) {
        self.username.text = username;
        NSDictionary *param = @{@"username":username};
        [Request listFriendWithURL:@"listFriendAndFans.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
            if (success) {
                NSError *error1;
                NSError *error2;
                _dataArray = [NSMutableArray array];
                _friendsArray = [NSMutableArray array];
                _fansArray = [NSMutableArray array];
                
                NSArray *tempFriends = [data valueForKeyPath:@"data.friends"];
                NSArray *tempFans = [data valueForKeyPath:@"data.fans"];
                
                for (NSDictionary *tempDict in tempFriends) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:tempDict error:&error1];
                    if (!error1) {
                        [_friendsArray addObject:model];
                    }
                }
                [_dataArray addObject:_friendsArray];
                for (NSDictionary *tempDict in tempFans) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:tempDict error:&error2];
                    if (!error2) {
                        [_fansArray addObject:model];
                    }
                }
                [_dataArray addObject:_fansArray];
                [_tableView reloadData];
            } else {
                NSLog(@"%@", data);
            }
        } andFailureBolck:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
    }
}

- (void)headerViewTap {
    UserViewController *vc = [[UserViewController alloc] init];
    vc.attentionButton.hidden = YES;
    [Request getInfoWithURL:@"getInfo.php" parameters:@{@"username":self.username.text} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            NSDictionary *tempDict = [data objectForKey:@"data"];
            UserModel *model = [[UserModel alloc] initWithDictionary:tempDict error:nil];
            vc.model = model;
//            vc.name = model.username;
            [self.navigationController pushViewController:vc animated:YES];

        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeHeaderImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更换头像" message:@"请进行选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"通过相机拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:NO completion:nil];
        }
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:NO completion:nil];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headerImage.image = image;
    
    // 上传头像
    [self uploadFile: image];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self saveImage:image];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)uploadFile:(UIImage *)image {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSDictionary *param = @{@"username":username};
    NSData *imageData = UIImagePNGRepresentation(image);
    [Request uploadFileWithURL:@"uploadFile.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        if (success) {
//            NSLog(@"%@", [data objectForKey:@"data"]);
            NSString *imgURL = [data objectForKey:@"data"];
            [self uploadHeaderImage:imgURL username:username];
        } else {
            NSLog(@"%@", [data objectForKey:@"error"]);
        }
    } andFailureBolck:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    } andStatus:@"" andMimeType:@"image/png" andData:imageData andExtension: @"png"];
}

- (void)uploadHeaderImage:(NSString *)imgURL username:(NSString *)username {
    NSDictionary *param = @{
                            @"username":username,
                            @"imgURL":imgURL
                            };
    [Request uploadHeaderImageWithURL:@"uploadHeaderImage.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        if (success) {
//            NSLog(@"%@", [data objectForKey:@"data"]);
            NSString *headerImageURL = [data objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:headerImageURL forKey:KHeaderImage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (_dataArray.count) {
        if(section == 0) {
            return _friendsArray.count ? _friendsArray.count : 1;
        } else {
            return _fansArray.count ? _fansArray.count : 1;
        }
//    } else {
//        return 0;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *friendCellIdentifier = @"friendCellIdentifier";
    [tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:friendCellIdentifier];
    
//    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier];
    
    CustomTableViewCell *cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:friendCellIdentifier];
//    }
    if (indexPath.section == 0) {
        if (_friendsArray.count){
            UserModel *model = _friendsArray[indexPath.row];
            [cell.imageView setImageWithURL:[NSURL URLWithString:model.headerURL] placeholderImage:[UIImage imageNamed:@"placeHeader.png"]];
            cell.textLabel.text = model.username;
        } else {
            cell.textLabel.text = @"我没有关注的人";
        }
    } else {
        if (_fansArray.count) {
            UserModel *model = _fansArray[indexPath.row];
            [cell.imageView setImageWithURL:[NSURL URLWithString:model.headerURL] placeholderImage:[UIImage imageNamed:@"placeHeader.png"]];
            cell.textLabel.text = model.username;
        } else {
            cell.textLabel.text = @"我没有关注人";
        }
    }
    
    cell.textLabel.textColor = [UIColor tabSelectedColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.frame = CGRectMake(15, 0, 44, 44);
    cell.imageView.layer.cornerRadius = 22;
    cell.imageView.layer.masksToBounds = YES;
//    NSLog(@"%@-%@", [NSValue valueWithCGRect:cell.imageView.frame],[NSValue valueWithCGRect:cell.frame]);
//    cell.detailTextLabel.text = @"good friend";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserViewController *vc = [[UserViewController alloc] init];
    
    if (_friendsArray.count) {
        if (indexPath.section == 0) {
            UserModel *model = _friendsArray[indexPath.row];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (_fansArray.count) {
        if (indexPath.section == 1) {
            UserModel *model = _fansArray[indexPath.row];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!section) {
        return @"";
    } else {
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerSection = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 35)];
    label.textColor = [UIColor tabSelectedColor];
//    label.backgroundColor = [UIColor grayColor];
    label.layer.cornerRadius = 3;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor tabSelectedColor].CGColor;
    label.layer.borderWidth = 1;
    label.font = [UIFont systemFontOfSize:20];
    if (!section) {
        label.text = @"我的关注";
    } else {
        label.text = @"关注我的";
    }
    [headerSection addSubview:label];
    return headerSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
