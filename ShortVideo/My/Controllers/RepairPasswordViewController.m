//
//  RepairPasswordViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/31.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "RepairPasswordViewController.h"

@interface RepairPasswordViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *verify;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
- (IBAction)submitClick:(UIButton *)sender;

@end

@implementation RepairPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.password.delegate = self;
    self.confirmPassword.delegate = self;
    self.verify.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat keyboardHeight = textField.inputView.frame.size.height;
        CGFloat fieldBottom = textField.frame.size.height + textField.frame.origin.y;
        CGRect frame = self.view.frame;
        if (fieldBottom + keyboardHeight > Screen_Width) {
            frame.origin.y = Screen_Width - fieldBottom - keyboardHeight;
            self.view.frame = frame;
        }
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.view.frame = frame;
        
    }];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitClick:(UIButton *)sender {
    
    if (!self.password.text.length || !self.confirmPassword.text.length || ![self.password.text isEqualToString:self.confirmPassword.text]) {
        [SVProgressHUD showErrorWithStatus:@"请检查密码"];
        return;
    }
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
   
    NSDictionary *param = @{
                            @"username":username,
                            @"password":self.password.text,
                            @"verify": self.verify.text
                           };
    
    
    [Request repairPasswordWithURL:@"repairPassword.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        if (success) {
//            NSLog(@"%@", data);
            [SVProgressHUD showSuccessWithStatus:@"更改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *message = [data objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    } andFailureBolck:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
    
    
}
@end
