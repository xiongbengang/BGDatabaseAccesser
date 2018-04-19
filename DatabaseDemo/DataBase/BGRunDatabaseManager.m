//
//  BGRunDatabaseManager.m
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import "BGRunDatabaseManager.h"
#import "BGDatabaseConnection.h"

const NSInteger BGRunDBVersion = 1;

@interface BGRunDatabaseManager () <BGDatabaseConnectionDelegate>

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) BGDatabaseConnection *connection;
@property (nonatomic, strong) BGDatabaseQueue *dbQueue;
@property (nonatomic, strong) BGDatabaseQueue *dbMainQueue;

@end

@implementation BGRunDatabaseManager

- (void)initializeWithDBPath:(NSString *)dbPath dbVersion:(NSInteger)dbVersion
{
    self.connection = [[BGDatabaseConnection alloc] initWithPath:dbPath version:dbVersion delegate:self];
}

#pragma mark - BGDatabaseEngineProtocol
- (BGDatabaseQueue *)databaseQueue
{
    if ([NSThread isMainThread]) {
        if (!self.dbMainQueue) {
            self.dbMainQueue = [[BGDatabaseQueue alloc] initWithDatabase:self.connection.database];
        }
        return self.dbMainQueue;
    } else {
        if (!self.dbQueue) {
            self.dbQueue = [[BGDatabaseQueue alloc] initWithDatabase:self.connection.database];
        }
        return self.dbQueue;
    }
}

- (FMDatabase *)database
{
    return self.connection.database;
}


#pragma mark - BGDatabaseConnectionDelegate

- (void)onCreate:(FMDatabase *)database
{
    
}

@end
