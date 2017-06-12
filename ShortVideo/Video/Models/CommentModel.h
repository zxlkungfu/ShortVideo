//
//  CommentModel.h
//  JsonToModelTest
//
//  Created by zhengxiaolong on 17/05/26.
//  Copyright © 2017年 zhengxiaolong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommentModel : JSONModel

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString <Optional>* headerURL;

@end
