//
//  CommentViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/6/10.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()<UITextViewDelegate>

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentView.delegate = self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
    self.navigationItem.rightBarButtonItem = done;
}

- (void)hideKeyboard {
    [self.contentView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(UIButton *)sender {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KUsername];
    NSString *content;
    if ([name isEqualToString:self.username]) {
        content = self.contentView.text;
    } else {
        content = [NSString stringWithFormat:@"%@//@%@:%@", self.contentView.text, self.username, self.comment];
    }
    NSString *date = [self getDateString];
    NSString *headerURL = [[NSUserDefaults standardUserDefaults] objectForKey:KHeaderImage];
    NSLog(@"%@", headerURL);
    NSDictionary *param = @{@"url":self.url,
                            @"date":date,
                            @"username":name,
                            @"content":content,
                            @"headerURL":headerURL};
    [Request commentWithURL:@"comment.php" parameters:param andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
    
}

- (NSString *)getDateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale systemLocale];
    df.timeZone = [NSTimeZone systemTimeZone];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [df stringFromDate:[NSDate date]];
}

@end
