//
//  BGDatabase.h
//  Kiwi
//
//  Created by Bengang on 2018/4/13.
//

#import <Foundation/Foundation.h>
#import "BGDatabaseColumnInfo.h"

@protocol BGDatabase <NSObject>

@optional
+ (NSString *)tableName;

+ (NSArray<NSString *> *)databasePropertyBlacklist;

+ (NSDictionary<NSString *, NSString *> *)propertyColumnMapper;

+ (void)configColumn:(BGDatabaseColumnInfo *)columnInfo forProperty:(NSString *)property;

- (void)setValueForProperty:(NSString *)property dabaseValue:(id)databaseValue;

@end
