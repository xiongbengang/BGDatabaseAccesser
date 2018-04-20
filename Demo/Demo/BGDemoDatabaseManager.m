//
//  BGDemoDatabaseManager.m
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGDemoDatabaseManager.h"
#import "BGPerson.h"

@implementation BGDemoDatabaseManager

- (NSInteger)dbVersion
{
    return 2;
}

- (void)onCreate:(FMDatabase *)database
{
    [super onCreate:database];
    [self createTableForClass:[BGPerson class] inDatabase:database];
}

@end
