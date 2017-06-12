//
//  Request.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "Request.h"

@implementation Request

+ (void)requestWithURL:(NSString *)url parameters:(NSDictionary *)param andSuccessBlock:(SuccessBlock)successBlock andFailureBlock:(FailureBlock)failureBlock andStatus:(NSString *)status {
    
    if (status.length > 0) {
        [SVProgressHUD showWithStatus:status];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", KBaseURL, url];
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (status.length > 0) {
            [SVProgressHUD dismiss];
        }
        NSString *message = [responseObject objectForKey:@"message"];
        BOOL success = [message boolValue];
        if (successBlock) {
            successBlock(success, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status.length > 0) {
            [SVProgressHUD dismiss];
        }
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)loginWithURL:(NSString *)url parameters:(NSDictionary *)param andSuccessBlock:(SuccessBlock)successBlock andFailureBolck:(FailureBlock)failureBlock {
    
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"正在登录"];
    
    
}

+ (void)registerWithURL:(NSString *)url parameters:(NSDictionary *)param andSuccessBlock:(SuccessBlock)successBlock andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"正在注册"];
    
}

+ (void)forgetPWDWithURL:(NSString *)url parameters:(NSDictionary *)param andSuccessBlock:(SuccessBlock)successBlock andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"正在查询密码"];
}

+ (void)listVideoWithURL:(NSString *)url
              parameters:(NSDictionary *)param
         andSuccessBlock:(SuccessBlock)successBlock
         andFailureBolck:(FailureBlock)failureBlock{
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+ (void)listFriendWithURL:(NSString *)url
              parameters:(NSDictionary *)param
         andSuccessBlock:(SuccessBlock)successBlock
         andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+ (void)repairPasswordWithURL:(NSString *)url
                   parameters:(NSDictionary *)param
              andSuccessBlock:(SuccessBlock)successBlock
              andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"正在处理中"];
}

+ (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)param
          andSuccessBlock:(SuccessBlock)successBlock
          andFailureBolck:(FailureBlock)failureBlock
                andStatus:(NSString *)status
                  andMimeType:(NSString *)mime
                  andData:(NSData *)data
           andExtension:(NSString *)ext{
    if (status.length > 0) {
        [SVProgressHUD showWithStatus:status];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", KBaseURL, url];
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = [NSString stringWithFormat:@"name.%@", ext];
        [formData appendPartWithFileData:data name:@"name" fileName:fileName mimeType:mime];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (status.length > 0) {
            [SVProgressHUD dismiss];
        }
        
        NSString *message = [responseObject objectForKey:@"message"];
        BOOL success = [message boolValue];
        if (successBlock) {
            successBlock(success, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status.length > 0) {
            [SVProgressHUD dismiss];
        }
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)uploadHeaderImageWithURL:(NSString *)url parameters:(NSDictionary *)param andSuccessBlock:(SuccessBlock)successBlock andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+  (void)playAttentionWithURL:(NSString *)url
                   parameters:(NSDictionary *)param
              andSuccessBlock:(SuccessBlock)successBlock
              andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+  (void)cancelAttentionWithURL:(NSString *)url
                     parameters:(NSDictionary *)param
                andSuccessBlock:(SuccessBlock)successBlock
                andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+ (void)uploadVideoWithURL:(NSString *)url
                parameters:(NSDictionary *)param
           andSuccessBlock:(SuccessBlock)successBlock
           andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+ (void)getInfoWithURL:(NSString *)url
            parameters:(NSDictionary *)param
       andSuccessBlock:(SuccessBlock)successBlock
       andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+ (void)isAttentionWithURL:(NSString *)url
                parameters:(NSDictionary *)param
           andSuccessBlock:(SuccessBlock)successBlock
           andFailureBolck:(FailureBlock)failureBlock{
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@""];
}

+ (void)setVerifyWithURL:(NSString *)url
                     parameters:(NSDictionary *)param
                andSuccessBlock:(SuccessBlock)successBlock
                andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"正在提交中"];
}

+ (void)getCommentWithURL:(NSString *)url
               parameters:(NSDictionary *)param
          andSuccessBlock:(SuccessBlock)successBlock
          andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"获取评论信息"];
}

+ (void)commentWithURL:(NSString *)url
               parameters:(NSDictionary *)param
          andSuccessBlock:(SuccessBlock)successBlock
          andFailureBolck:(FailureBlock)failureBlock {
    [Request requestWithURL:url parameters:param andSuccessBlock:successBlock andFailureBlock:failureBlock andStatus:@"提交评论信息"];
}

+ (void)askQuestionWithURL:(NSString *)url
                parameters:(NSDictionary *)param
           andSuccessBlock:(SuccessBlock)successBlock
           andFailureBolck:(FailureBlock)failureBlock {
    
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];

    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [responseObject objectForKey:@"error_code"];
        if ([result intValue] == 0) {
            if (successBlock) {
                successBlock(YES, [responseObject objectForKey:@"result"][@"text"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
