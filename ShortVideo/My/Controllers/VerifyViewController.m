//
//  VerifyViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/7.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "VerifyViewController.h"

@interface VerifyViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *verify;
- (IBAction)submit:(UIButton *)sender;

@end

@implementation VerifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.verify.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)submit:(UIButton *)sender {
    if (self.verify.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证信息"];
    } else {
        NSString *currentName = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
        NSDictionary *param = @{@"username": currentName,
                                @"verify": self.verify.text};
        [Request setVerifyWithURL:@"setVerify.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"设置失败"];
            }
        } andFailureBolck:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
    }
}
@end
