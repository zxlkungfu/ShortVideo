//
//  MyViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "MyViewController.h"
#import "HomeViewController.h"
#import "RepairPasswordViewController.h"
#import "VerifyViewController.h"
#import "RobotViewController.h"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_iconArray;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    _dataArray = @[
                   @[@"设置验证信息", @"我的收藏", @"消息中心", @"清除缓存"],
                   @[@"分享应用", @"给我打分", @"当前版本号"],
                   @[@"修改密码",@"机器人", @"设置"]
                   ];
    _iconArray = @[
                   @[@"输入",@"收藏",@"消息",@"清理缓存"],
                   @[@"分享",@"评分",@"版本号"],
                   @[@"修改密码",@"机器人",@"设置"]
                   ];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    logout.frame = CGRectMake(20, 0, Screen_Width-40, 40);
    logout.backgroundColor = [UIColor tabSelectedColor];
    logout.titleLabel.textColor = [UIColor whiteColor];
    
    [view addSubview:logout];
    _tableView.tableFooterView = view;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [logout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)logoutClick {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self presentViewController:[[HomeViewController alloc] init] animated:NO completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *temp = _dataArray[section];
    return temp.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCellIdentifier = @"myCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCellIdentifier];
    }
    
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor tabSelectedColor];
    cell.detailTextLabel.textColor = [UIColor tabSelectedColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageNamed:_iconArray[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            cell.detailTextLabel.text = [self getCacheSize];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
            cell.detailTextLabel.text = [info objectForKey:@"CFBundleShortVersionString"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VerifyViewController *verifyVC = [[VerifyViewController alloc] init];
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
        if (indexPath.row == 3) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"建议经常清理缓存" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                // 清理缓存
                [self clearCache];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:NO completion:nil];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSArray *items = @[@"短视频", [UIImage imageNamed:@"logo.png"], [NSURL URLWithString:@"www.baidu.com"]];
            
            UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
            shareController.excludedActivityTypes = @[UIActivityTypePostToTwitter, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeOpenInIBooks, UIActivityTypePostToFacebook];
            [self presentViewController:shareController animated:NO completion:nil];
        }
    }
    
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIViewController *vc = [[RepairPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            RobotViewController *vc = [[RobotViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 2) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"打开系统设置"
                                                                           message:@"可以修改此软件的访问权限哦"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction* confirm = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{@"":@""} completionHandler:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (NSString *)getCacheSize {
    long long sumSize = 0;
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES).firstObject;
    NSString *cachePath = [libPath stringByAppendingString:@"/Caches"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsOfDirectoryAtPath:cachePath error:nil];
    for (NSString *subPath in subPaths) {
        NSString *filePath = [cachePath stringByAppendingFormat:@"/%@", subPath];
        long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        sumSize += fileSize;
    }
    float size_m = sumSize/1024.0/1024.0;
    return [NSString stringWithFormat:@"%0.2fM", size_m];
}

- (void)clearCache {
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES).firstObject;
    NSString *cachePath = [libPath stringByAppendingString:@"/Caches"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cachePath error:nil];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
