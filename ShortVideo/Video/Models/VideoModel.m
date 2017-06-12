//
//  VideoModel.m
//  JsonToModelTest
//
//  Created by zhengxiaolong on 17/05/26.
//  Copyright © 2017年 zhengxiaolong. All rights reserved.
//

#import "VideoModel.h"
#import "CommentModel.h"

@implementation VideoModel

+ (NSString*)protocolForArrayProperty:(NSString *)propertyName {
	if ([propertyName isEqualToString:@"comment"]) {
		return NSStringFromClass([CommentModel class]);
	}
	return nil;
}


@end