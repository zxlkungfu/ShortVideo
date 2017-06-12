//
//  VideoModel.h
//  JsonToModelTest
//
//  Created by zhengxiaolong on 17/05/26.
//  Copyright © 2017年 zhengxiaolong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class CommentModel;

@interface VideoModel : JSONModel

@property (nonatomic, strong) NSArray<CommentModel *> * comment;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * duration;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * imgURL;

@end
