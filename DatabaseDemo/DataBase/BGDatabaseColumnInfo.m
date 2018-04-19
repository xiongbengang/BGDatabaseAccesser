//
//  BGDatabaseColumnInfo.m
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import "BGDatabaseColumnInfo.h"

NSString *BGDatabaseColumnTypeDesc(BGDatabaseColunType columnType) {
    static NSDictionary *colunTypeCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colunTypeCache = @{@(BGDatabaseColunTypeText): @"TEXT",
                           @(BGDatabaseColunTypeReal): @"REAL",
                           @(BGDatabaseColunTypeDate): @"DATE",
                           @(BGDatabaseColunTypeBlob): @"BLOB",
                           @(BGDatabaseColunTypeBoolean): @"BOOLEAN",
                           @(BGDatabaseColunTypeInteger): @"INTEGER",
                           @(BGDatabaseColunTypeFloat): @"FLOAT",
                           @(BGDatabaseColunTypeDouble): @"DOUBLE",
                           @(BGDatabaseColunTypeLongDouble): @"DOUBLE PRECISION",
                           };
    });
    return colunTypeCache[@(columnType)];
}

@implementation BGDatabaseColumnInfo

@end
