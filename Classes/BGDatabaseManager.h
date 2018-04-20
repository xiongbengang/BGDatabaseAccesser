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

- (void)initializeWithDBPath:(NSString *)dbPath;
- (void)onConfigure:(FMDatabase *)database;
- (void)onCreate:(FMDatabase *)database;
- (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;
- (void)onDowngrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;
- (void)onOpen:(FMDatabase *)database;

@end
