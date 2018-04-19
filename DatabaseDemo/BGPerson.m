//
//  BGPerson.m
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGPerson.h"

@implementation BGPerson

+ (NSDictionary<NSString *, NSString *> *)propertyColumnMapper
{
    return @{@"pid": @"id"};
}

+ (NSString *)tableName
{
    return @"Person";
}

+ (NSArray<NSString *> *)databasePropertyBlacklist
{
    return @[@"address"];
}


@end
