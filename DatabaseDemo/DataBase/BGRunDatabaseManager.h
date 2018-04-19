//
//  BGRunDatabaseManager.h
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import <Foundation/Foundation.h>
#import "BGDatabaseQueue.h"

@interface BGRunDatabaseManager : NSObject

@property (nonatomic, assign, readonly) NSInteger dbVersion;
@property (nonatomic, strong, readonly) BGDatabaseQueue *databaseQueue;

- (void)initializeWithDBPath:(NSString *)dbPath;
- (void)onConfigure:(FMDatabase *)database;
- (void)onCreate:(FMDatabase *)database;
- (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;
- (void)onDowngrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;
- (void)onOpen:(FMDatabase *)database;

@end
