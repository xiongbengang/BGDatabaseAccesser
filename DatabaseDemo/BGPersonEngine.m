//
//  BGPersonEngine.m
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGPersonEngine.h"

@implementation BGPersonEngine

- (void)insertPerson:(BGPerson *)person
{
    [self inDatabase:^(FMDatabase *database) {
        [self.personAccesser insertObject:person];
    }];
}

- (BGPersonAccesser *)personAccesser
{
    if (!_personAccesser) {
        _personAccesser = [[BGPersonAccesser alloc] initWithDatabase:self.database];
    }
    return _personAccesser;
}

@end
