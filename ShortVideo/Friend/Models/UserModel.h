//
//  UserModel.h
//  JsonToModelTest
//
//  Created by zhengxiaolong on 17/05/29.
//  Copyright © 2017年 zhengxiaolong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property (nonatomic, copy) NSString * headerURL;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * username;

- (BOOL)isEqual:(id)object;

@end
