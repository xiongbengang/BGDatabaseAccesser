//
//  BGRunDatabaseManager.m
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import "BGDatabaseManager.h"
#import "BGDatabaseConnection.h"
#import "BGDatabaseTableInfo.h"

const NSInteger BGRunDBVersion = 1;

@interface BGDatabaseManager () <BGDatabaseConnectionDelegate>

@property (nonatomic, strong) BGDatabaseConnection *connection;
@property (nonatomic, strong) BGDatabaseQueue *dbQueue;
@property (nonatomic, strong) BGDatabaseQueue *dbMainQueue;

@end

@implementation BGDatabaseManager

- (void)initializeWithDBPath:(NSString *)dbPath
{
    self.connection = [[BGDatabaseConnection alloc] initWithPath:dbPath version:self.dbVersion delegate:self];
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

- (BOOL)createTableForClass:(Class)cls inDatabase:(FMDatabase *)database
{
    BGDatabaseTableInfo *databaseInfo = [BGDatabaseTableInfo tableInfoForClass:cls];
    NSMutableArray *columnComponents = [NSMutableArray arrayWithCapacity:databaseInfo.columns.count];
    for (BGDatabaseColumnInfo *column in databaseInfo.columns) {
        NSString *columnTypeDesc = BGDatabaseColumnTypeDesc(column.type);
        NSMutableString *columnString = [NSMutableString stringWithFormat:@"%@ %@", column.columnName, columnTypeDesc];
        BOOL shouldInsert = NO;
        if ([column isPrimaryKey]) {
            shouldInsert = YES;
            [columnString appendString:@" PRIMARY KEY"];
        }
        if (shouldInsert) {
            [columnComponents insertObject:columnString atIndex:0];
        } else {
            [columnComponents addObject:columnString];
        }
    }
    NSString *columnsString = [columnComponents componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)", databaseInfo.tableName, columnsString];
    BOOL executeResult = [database executeUpdate:sql];
    return executeResult;
}

#pragma mark - BGDatabaseConnectionDelegate

- (void)onConfigure:(FMDatabase *)database
{
    
}

- (void)onCreate:(FMDatabase *)database
{
    
}

- (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion
{
    
}

- (void)onDowngrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion
{
    
}

- (void)onOpen:(FMDatabase *)database
{
    
}

@end
