//
//  ViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "RootViewController.h"
#import "VideoViewController.h"
#import "FriendViewController.h"
#import "MyViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSArray *vcArray = @[
                         @"VideoViewController",
                         @"FriendViewController",
                         @"MyViewController"
                         ];
    NSArray *custom = @[
                        @[@"视频", @"video", @"videoSelect"],
                        @[@"好友",@"friend", @"friendSelect"],
                        @[@"我", @"my", @"mySelect"]
                        ];
    NSMutableArray *tabBarVCS = [NSMutableArray array];
    for (int i = 0; i < custom.count; i++) {
        UIViewController *vc = [[NSClassFromString(vcArray[i]) alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.navigationBar.barTintColor = [UIColor navColor];
        nc.navigationBar.tintColor = [UIColor whiteColor];
        [tabBarVCS addObject:nc];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:custom[i][0] image:[UIImage imageNamed:custom[i][1]] selectedImage:[UIImage imageNamed:custom[i][2]]];
        nc.tabBarItem = item;
        
    }
    [self setViewControllers:tabBarVCS animated:YES];
    
    self.tabBar.barTintColor = [UIColor tabColor];
    self.tabBar.tintColor = [UIColor tabSelectedColor];
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
