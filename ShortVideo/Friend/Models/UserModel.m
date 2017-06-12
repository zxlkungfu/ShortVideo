//
//  UserModel.m
//  JsonToModelTest
//
//  Created by zhengxiaolong on 17/05/29.
//  Copyright © 2017年 zhengxiaolong. All rights reserved.
//

#import "UserModel.h"
@implementation UserModel
+ (JSONKeyMapper*)keyMapper {
	return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId":@"id"}];
}

- (BOOL)isEqual:(id)object {
    
    if ([object isKindOfClass:[self class]]) {
        UserModel *model = object;
        if (![_userId isEqualToString:model.userId]) {
            return NO;
        }
        if (![_username isEqualToString:model.username]) {
            return NO;
        }
        if (![_password isEqualToString:model.password]) {
            return NO;
        }
        if (![_headerURL isEqualToString:model.headerURL]) {
            return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

@end
