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

- (BOOL)updateWithItem:(id)obj forKeyPaths:(NSArray<NSString *> *)keyPaths;

- (BOOL)updateWithItem:(id)obj ignoredKeyPaths:(NSArray<NSString *> *)ignoredKeyPaths;

- (BOOL)updateWithKeyPaths:(NSArray<NSString *> *)keyPaths values:(NSArray *)values condition:(NSString *)condition, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)deleteAll;

- (BOOL)deleteItem:(id)obj;

- (BOOL)deleteWithCondition:(NSString *)condition, ...;

- (id)itemFromResultSet:(FMResultSet *)resultSet;

- (NSArray *)queryAllItems;

- (NSArray *)queryItemsWithCondition:(NSString *)condition, ...;

- (BOOL)itemExists:(id)item;

- (BOOL)existsForQuery:(NSString *)query, ...;

- (long long)longlongWithDefault:(long long)defaultValue sql:(NSString *)sql, ...;

@end
