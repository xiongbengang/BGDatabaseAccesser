//
//  BGRunDatabaseManager.h
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "BGDatabaseQueue.h"

@interface BGDatabaseManager : NSObject

@property (nonatomic, assign, readonly) NSInteger dbVersion;
@property (nonatomic, strong, readonly) FMDatabase *database;
@property (nonatomic, strong, readonly) BGDatabaseQueue *databaseQueue;

- (BOOL)createTableForClass:(Class)cls inDatabase:(FMDatabase *)database;

// 初始化数据库
- (void)initializeWithDBPath:(NSString *)dbPath;

- (void)onConfigure:(FMDatabase *)database;

// 创建表的操作在这里写
- (void)onCreate:(FMDatabase *)database;

 // 数据库升级逻辑
- (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;

// 数据库降级逻辑
- (void)onDowngrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;

- (void)onOpen:(FMDatabase *)database;

@end
