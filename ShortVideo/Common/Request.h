//
//  Request.h
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject


/**
 网络请求成功的回调

 @param success BOOL
 @param data 返回的有效数据
 */
typedef void(^SuccessBlock)(BOOL success, id data);


/**
 网络请求失败的回调

 @param error 错误信息
 */
typedef void(^FailureBlock)(NSError *error);

/**
 通用请求接口

 @param url 接口地址
 @param param 请求的拼接的参数
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 @param status 网络请求状态字符串
 */
+ (void)requestWithURL:(NSString *)url
            parameters:(NSDictionary *)param
       andSuccessBlock:(SuccessBlock)successBlock
       andFailureBlock:(FailureBlock)failureBlock
             andStatus:(NSString *)status;

/**
 登录

 @param url login.php
 @param param username=用户名&password=密码
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)loginWithURL:(NSString *)url
            parameters:(NSDictionary *)param
       andSuccessBlock:(SuccessBlock)successBlock
       andFailureBolck:(FailureBlock)failureBlock;


/**
 注册

 @param url register.php
 @param param username= &password=
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)registerWithURL:(NSString *)url
             parameters:(NSDictionary *)param
        andSuccessBlock:(SuccessBlock)successBlock
        andFailureBolck:(FailureBlock)failureBlock;



/**
 忘记密码

 @param url forgetPassword.php
 @param param username=用户名, verify=验证信息
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)forgetPWDWithURL:(NSString *)url
              parameters:(NSDictionary *)param
         andSuccessBlock:(SuccessBlock)successBlock
         andFailureBolck:(FailureBlock)failureBlock;


/**
 所有视频

 @param url listVideo
 @param param nil or where = 用户名或视频名
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)listVideoWithURL:(NSString *)url
              parameters:(NSDictionary *)param
         andSuccessBlock:(SuccessBlock)successBlock
         andFailureBolck:(FailureBlock)failureBlock;


/**
 所有好友和粉丝

 @param url listFriendAndFans
 @param param username=用户名
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)listFriendWithURL:(NSString *)url
              parameters:(NSDictionary *)param
         andSuccessBlock:(SuccessBlock)successBlock
         andFailureBolck:(FailureBlock)failureBlock;


/**
 修改密码

 @param url repairPassword
 @param param password=新密码&verify=验证信息
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)repairPasswordWithURL:(NSString *)url
               parameters:(NSDictionary *)param
          andSuccessBlock:(SuccessBlock)successBlock
              andFailureBolck:(FailureBlock)failureBlock;


/**
 上传视频或图片，返回服务器上相应资源的地址

 @param url uploadFile
 @param param username=用户名
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 @param status status description
 @param mime 文件类型
 @param data 文件的二进制数据
 @param ext 文件的扩展名
 */
+ (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)param
          andSuccessBlock:(SuccessBlock)successBlock
          andFailureBolck:(FailureBlock)failureBlock
                andStatus:(NSString *)status
                  andMimeType:(NSString *)mime
                  andData:(NSData *)data
             andExtension:(NSString *)ext;


/**
 上传头像

 @param url uploadHeaderImage
 @param param username=用户名&headerURL=
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)uploadHeaderImageWithURL:(NSString *)url
                      parameters:(NSDictionary *)param
                 andSuccessBlock:(SuccessBlock)successBlock
                 andFailureBolck:(FailureBlock)failureBlock;


/**
 上传视频

 @param url uploadVieo
 @param param username=用户&title=标题&duration=时长&date=日期&url=视频网址&imgURL=截图网址
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
+ (void)uploadVideoWithURL:(NSString *)url
                      parameters:(NSDictionary *)param
                 andSuccessBlock:(SuccessBlock)successBlock
           andFailureBolck:(FailureBlock)failureBlock;


/**
 关注某个用户

 @param url playAttention
 @param param username=用户名&friend=被关注对象
 @param successBlock None
 @param failureBlock None
 */
+  (void)playAttentionWithURL:(NSString *)url
                   parameters:(NSDictionary *)param
              andSuccessBlock:(SuccessBlock)successBlock
              andFailureBolck:(FailureBlock)failureBlock;

/**
 取消关注

 @param url cancelAttention
 @param param param username=用户名&friend=取消关注对象
 @param successBlock None
 @param failureBlock None
 */
+  (void)cancelAttentionWithURL:(NSString *)url
                   parameters:(NSDictionary *)param
              andSuccessBlock:(SuccessBlock)successBlock
              andFailureBolck:(FailureBlock)failureBlock;

/**
 获取用户详细信息

 @param url getInfo
 @param param username=用户名
 @param successBlock None
 @param failureBlock None
 */
+ (void)getInfoWithURL:(NSString *)url
            parameters:(NSDictionary *)param
       andSuccessBlock:(SuccessBlock)successBlock
       andFailureBolck:(FailureBlock)failureBlock;


/**
 是否关注某个用户

 @param url isAttention
 @param param username=用户名&currentName=某个用户
 @param successBlock None
 @param failureBlock None
 */
+ (void)isAttentionWithURL:(NSString *)url
                parameters:(NSDictionary *)param
           andSuccessBlock:(SuccessBlock)successBlock
           andFailureBolck:(FailureBlock)failureBlock;


/**
 设置验证信息

 @param url setVerify
 @param param username=用户名
 @param successBlock None
 @param failureBlock None
 */
+ (void)setVerifyWithURL:(NSString *)url
                     parameters:(NSDictionary *)param
                andSuccessBlock:(SuccessBlock)successBlock
                andFailureBolck:(FailureBlock)failureBlock;


/**
 获取评论信息

 @param url getComment
 @param param url=视频网址
 @param successBlock None
 @param failureBlock None
 */
+ (void)getCommentWithURL:(NSString *)url
               parameters:(NSDictionary *)param
          andSuccessBlock:(SuccessBlock)successBlock
          andFailureBolck:(FailureBlock)failureBlock;

/**
 发表评论

 @param url comment
 @param param username=评论者&url=视频网址&date=评论时间&content=评论内容
 @param successBlock None
 @param failureBlock None
 */
+ (void)commentWithURL:(NSString *)url
            parameters:(NSDictionary *)param
       andSuccessBlock:(SuccessBlock)successBlock
       andFailureBolck:(FailureBlock)failureBlock;


/**
 问答机器人

 @param url 聚合数据上的地址
 @param param Info=问题&key= 聚合的AppKey
 @param successBlock None
 @param failureBlock None
 */
+ (void)askQuestionWithURL:(NSString *)url
                parameters:(NSDictionary *)param
           andSuccessBlock:(SuccessBlock)successBlock
           andFailureBolck:(FailureBlock)failureBlock;

@end
