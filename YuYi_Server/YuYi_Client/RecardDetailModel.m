//
//  RecardDetailModel.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/3/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "RecardDetailModel.h"

@implementation RecardDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end
