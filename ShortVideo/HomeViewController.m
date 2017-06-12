//
//  HomeViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "HomeViewController.h"
#import "RootViewController.h"
#import "UserModel.h"

@interface HomeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginClick:(UIButton *)sender;
- (IBAction)registerClick:(UIButton *)sender;
- (IBAction)forgetPWDClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UITextField *verify;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.username.delegate = self;
    self.password.delegate =self;
    self.verify.delegate = self;
    self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verify.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.secureTextEntry = YES;
//    self.verify.hidden = YES;
    
    NSString *headerImage = [[NSUserDefaults standardUserDefaults] objectForKey:KHeaderImage];
    
    [self.logo setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"shortVideo.png"]];
    
    self.username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.verify.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证信息" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
   
    NSString *currentName = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    if (currentName.length > 0) {
        self.username.text = currentName;
    }
    self.logo.layer.cornerRadius = 30;
    self.logo.layer.masksToBounds = YES;
   
    
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

- (IBAction)loginClick:(UIButton *)sender {
    if (!self.username.text.length || !self.password.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请完善信息，不可空白"];
        return;
    }
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.username.text,@"username", self.password.text, @"password", nil];
    [Request loginWithURL:@"login.php" parameters:param andSuccessBlock:^(BOOL success, id data) {

        if (success) {
            NSDictionary *temp = [data objectForKey:@"data"];
            
            NSString *headerURL = [temp objectForKey:@"headerURL"];
            [[NSUserDefaults standardUserDefaults] setObject:headerURL forKey:KHeaderImage];
            [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:KUsername];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLoginStatus];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self presentViewController:[[RootViewController alloc] init] animated:NO completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:[data objectForKey:@"error"]];
        }
    } andFailureBolck:^(NSError *error) {

        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];

    }];
}

- (IBAction)registerClick:(UIButton *)sender {
    if ([self.username.text isEqualToString:@"请输入用户名"]) {
        [SVProgressHUD showErrorWithStatus:@"请完善信息，不可空白"];
        return;
    }
    
    if ([self.password.text isEqualToString:@"请输入密码"]) {
        [SVProgressHUD showErrorWithStatus:@"请完善信息，不可空白"];
        return;
    }
    if (!self.username.text.length || !self.password.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请完善信息，不可空白"];
        return;
    }
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.username.text,@"username", self.password.text, @"password", nil];
    [Request loginWithURL:@"register.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
//        NSLog(@"%d%@", success, data);
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:[data objectForKey:@"error"]];
        }
    } andFailureBolck:^(NSError *error) {
//        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
    
}

- (IBAction)forgetPWDClick:(UIButton *)sender {
    
    if (!self.username.text.length) {
        [SVProgressHUD showErrorWithStatus:@"用户名不可为空"];
        return;
    }

    
    NSDictionary *param = @{@"username":self.username.text,
                            @"verify":self.verify.text};
    [Request loginWithURL:@"forgetPassword.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
//        NSLog(@"%d%@", success, data);
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"密码查询成功"];
            NSDictionary *tmp = [data objectForKey:@"data"];
            
            self.messageLabel.text = [NSString stringWithFormat:@"密码是：%@", tmp[@"password"]];
        } else {
            [SVProgressHUD showErrorWithStatus:[data objectForKey:@"error"]];
        }
    } andFailureBolck:^(NSError *error) {
//        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
}
@end
