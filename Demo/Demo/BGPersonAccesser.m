//
//  BGPersonAccesser.m
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGPersonAccesser.h"

@implementation BGPersonAccesser

- (Class)itemClass
{
    return [BGPerson class];
}

- (long long)queryMaxPersonId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT MAX(id) FROM %@", self.tableInfo.tableName];
    long long maxPersonId = [self longlongWithDefault:-1 sql:sql];
    return maxPersonId;
}

@end
