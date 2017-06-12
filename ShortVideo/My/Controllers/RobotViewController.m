//
//  RobotViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/12.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "RobotViewController.h"

@interface RobotViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *question;
- (IBAction)submit:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *answer;

@end

@implementation RobotViewController

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
    self.question.delegate = self;
    self.title = @"问答机器人";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(UIButton *)sender {
    
    [Request askQuestionWithURL:@"http://op.juhe.cn/robot/index" parameters:@{@"info":self.question.text, @"key":@"264e4168bbca883f32c42d2dd426fa8c"} andSuccessBlock:^(BOOL success, id data) {
    
        if (success) {
//            NSLog(@"%@", data);
            self.answer.text = (NSString *)data;
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}
@end
