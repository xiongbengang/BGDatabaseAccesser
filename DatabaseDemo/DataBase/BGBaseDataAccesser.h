//
//  BGBaseDataAccesser.h
//  Kiwi
//
//  Created by CC on 2018/4/5.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "BGDatabaseTableInfo.h"

@interface BGBaseDataAccesser : NSObject

@property (nonatomic, strong, readonly) FMDatabase *database;

@property (nonatomic, strong, readonly) BGDatabaseTableInfo *tableInfo;

@property (nonatomic, assign) Class itemClass;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDatabase:(FMDatabase *)database;

- (BOOL)insertObject:(id)obj;

- (BOOL)updateWithItem:(id)obj;

- (BOOL)deleteAll;

- (BOOL)deleteWithCondition:(NSString *)condition, ...;

- (id)itemFromResultSet:(FMResultSet *)resultSet;

- (NSArray *)queryItemsWithCondition:(NSString *)condition, ...;

- (BOOL)existsForQuery:(NSString *)query, ...;

- (long long)longlongWithDefault:(long long)defaultValue sql:(NSString *)sql, ...;

@end
