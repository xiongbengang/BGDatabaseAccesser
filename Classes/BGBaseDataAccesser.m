//
//  BGBaseDataAccesser.m
//  Kiwi
//
//  Created by CC on 2018/4/5.
//

#import "BGBaseDataAccesser.h"
#import <YYModel/YYModel.h>
#import "BGDatabaseAccessible.h"

@interface BGBaseDataAccesser();

@property (nonatomic, strong, readwrite) BGDatabaseTableInfo *tableInfo;

@end

@implementation BGBaseDataAccesser

- (instancetype)initWithDatabase:(FMDatabase *)database
{
    self = [super init];
    if (self) {
        _database = database;
    }
    return self;
}

- (Class)itemClass
{
    if (_itemClass) {
        return _itemClass;
    }
    @throw @"must has specified itemClass";
}

- (BOOL)insertObject:(id)obj
{
    NSParameterAssert([obj isKindOfClass:[self itemClass]]);
    NSMutableArray *columNames = [NSMutableArray arrayWithCapacity:self.tableInfo.columns.count];
    NSMutableArray *queries = [NSMutableArray arrayWithCapacity:self.tableInfo.columns.count];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.tableInfo.columns.count];
    for (int i = 0; i < self.tableInfo.columns.count; i++) {
        BGDatabaseColumnInfo *columnInfo = self.tableInfo.columns[i];
        id value = [obj valueForKeyPath:columnInfo.propertyName];
        if (!value || columnInfo.systemManaged) {
            continue;
        }
        [columNames addObject:columnInfo.columnName];
        [values addObject:value];
        [queries addObject:@"?"];
    }
    NSString *columnString = [columNames componentsJoinedByString:@","];
    NSString *queryString = [queries componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)", self.tableInfo.tableName, columnString, queryString];
    BOOL executeResult = [self.database executeUpdate:sql withArgumentsInArray:values];
    return executeResult;
}

- (BOOL)updateWithItem:(id)obj
{
    return [self updateWithItem:obj updateKeyPaths:nil ignoredKeyPaths:nil];
}

- (BOOL)updateWithItem:(id)obj ignoredKeyPaths:(NSArray<NSString *> *)ignoredKeyPaths
{
    return [self updateWithItem:obj updateKeyPaths:nil ignoredKeyPaths:ignoredKeyPaths];
}

- (BOOL)updateWithItem:(id)obj forKeyPaths:(NSArray<NSString *> *)keyPaths
{
    return [self updateWithItem:obj updateKeyPaths:keyPaths ignoredKeyPaths:nil];
}

- (BOOL)updateWithKeyPaths:(NSArray<NSString *> *)keyPaths values:(NSArray *)values condition:(NSString *)condition, ...
{
    NSParameterAssert(keyPaths.count == values.count);
    NSMutableArray *updateComponents = [NSMutableArray arrayWithCapacity:keyPaths.count];
    for (int i = 0; i < self.tableInfo.columns.count; i++) {
        BGDatabaseColumnInfo *columnInfo = self.tableInfo.columns[i];
        if (columnInfo.systemManaged) {  //  系统控制的字段 自增字段
            continue;
        }
        if (![keyPaths containsObject:columnInfo.propertyName]) {
            continue;
        }
        [updateComponents addObject:[NSString stringWithFormat:@"%@=?", columnInfo.columnName]];
    }
    NSString *updateString = [updateComponents componentsJoinedByString:@","];
    NSMutableArray *arguments = [NSMutableArray arrayWithArray:values];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@", self.tableInfo.tableName, updateString];
    if (condition.length) {
        sql = [sql stringByAppendingFormat:@" %@", condition];
        va_list args;
        va_start(args, condition);
        id obj = nil;
        while ((obj = va_arg(args, id))) {
            [arguments addObject:obj];
        }
        va_end(args);
    }
    BOOL rs = [self.database executeUpdate:sql withArgumentsInArray:arguments];
    return rs;
}

- (BOOL)updateWithItem:(id)obj updateKeyPaths:(NSArray<NSString *> *)updateKeyPaths ignoredKeyPaths:(NSArray<NSString *> *)ignoredKeyPaths
{
    NSParameterAssert([obj isKindOfClass:[self itemClass]]);
    NSMutableArray *updateValues = [NSMutableArray arrayWithCapacity:self.tableInfo.columns.count];
    NSMutableArray *updateComponents = [NSMutableArray arrayWithCapacity:self.tableInfo.columns.count];
    for (int i = 0; i < self.tableInfo.columns.count; i++) {
        BGDatabaseColumnInfo *columnInfo = self.tableInfo.columns[i];
        if (columnInfo.systemManaged || columnInfo.isPrimaryKey ||
            (updateKeyPaths && ![updateKeyPaths containsObject:columnInfo.propertyName]) ||
            (ignoredKeyPaths && [ignoredKeyPaths containsObject:columnInfo.propertyName])) {
            continue;
        }
        id value = [obj valueForKeyPath:columnInfo.propertyName];
        if (!value) {
            continue;
        }
        [updateValues addObject:value];
        [updateComponents addObject:[NSString stringWithFormat:@"%@=?", columnInfo.columnName]];
    }
    NSString *updateString = [updateComponents componentsJoinedByString:@","];
    
    id primaryKeyValue = [obj valueForKeyPath:self.tableInfo.primaryKey.propertyName];
    NSAssert(primaryKeyValue, @"Primary key value must not be nil");
    [updateValues addObject:primaryKeyValue];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?", self.tableInfo.tableName, updateString, self.tableInfo.primaryKey.columnName];
    BOOL rs = [self.database executeUpdate:sql withArgumentsInArray:updateValues];
    return rs;
}

- (BOOL)deleteAll
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", self.tableInfo.tableName];
    BOOL rs = [self.database executeUpdate:sql];
    return rs;
}

- (BOOL)deleteItem:(id)obj
{
    id primaryValue = [obj valueForKeyPath:self.tableInfo.primaryKey.propertyName];
    NSString *condition = [NSString stringWithFormat:@"WHERE %@=?", self.tableInfo.primaryKey.propertyName];
    return [self deleteWithCondition:condition, primaryValue];
}

- (BOOL)deleteWithCondition:(NSString *)condition, ...
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", self.tableInfo.tableName, condition];
    va_list args;
    va_start(args, condition);
    BOOL rs = [self.database executeUpdate:sql withVAList:args];
    va_end(args);
    return rs;
}

- (BOOL)itemExists:(id)item
{
    NSParameterAssert([item isKindOfClass:[self itemClass]]);
    NSParameterAssert(self.tableInfo.primaryKey);
    BGDatabaseColumnInfo *primaryKey = self.tableInfo.primaryKey;
    id primaryValue = [item valueForKeyPath:primaryKey.propertyName];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=?", primaryKey.columnName, self.tableInfo.tableName, primaryKey.columnName];
    BOOL exists = [self.database executeQuery:sql, primaryValue];
    return exists;
}

- (BOOL)existsForQuery:(NSString *)query, ...
{
    va_list args;
    va_start(args, query);
    FMResultSet *rs = [self.database executeQuery:query withVAList:args];
    va_end(args);
    BOOL exists = [rs next] ? YES : NO;
    [rs close];
    return exists;
}

- (long long)longlongWithDefault:(long long)defaultValue sql:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    FMResultSet *rs = [self.database executeQuery:sql withVAList:args];
    va_end(args);
    long long result = defaultValue;
    if ([rs next]) {
        result = [rs longLongIntForColumnIndex:0];
    }
    [rs close];
    return result;
}

- (NSArray *)queryAllItems
{
    return [self queryItemsWithCondition:nil];
}

- (NSArray *)queryItemsWithCondition:(NSString *)condition, ...
{
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *columnNames = [NSMutableArray arrayWithCapacity:self.tableInfo.columns.count];
    for (BGDatabaseColumnInfo *columnInfo in self.tableInfo.columns) {
        [columnNames addObject:columnInfo.columnName];
    }
    NSString *columnString = [columnNames componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", columnString, self.tableInfo.tableName];
    if (condition.length) {
        sql = [sql stringByAppendingFormat:@" %@",condition];
    }
    va_list args;
    va_start(args, condition);
    FMResultSet *resultSet = [self.database executeQuery:sql withVAList:args];
    va_end(args);
    
    while (resultSet.next) {
        [items addObject:[self itemFromResultSet:resultSet]];
    }
    [resultSet close];
    return items;
}

- (id)itemFromResultSet:(FMResultSet *)resultSet
{
    id item = [[[self itemClass] alloc] init];
    for (BGDatabaseColumnInfo *columnInfo in self.tableInfo.columns) {
        id value = nil;
        switch (columnInfo.type) {
            case BGDatabaseColunTypeText: {
                value = [resultSet stringForColumn:columnInfo.columnName];
                break;
            }
            case BGDatabaseColunTypeReal:
            case BGDatabaseColunTypeFloat:
            case BGDatabaseColunTypeDouble:
            case BGDatabaseColunTypeLongDouble: {
                float floatValue = [resultSet doubleForColumn:columnInfo.columnName];
                value = @(floatValue);
                break;
            }
            case  BGDatabaseColunTypeInteger: {
                long long intValue = [resultSet longLongIntForColumn:columnInfo.columnName];
                value = @(intValue);
                break;
            }
            case BGDatabaseColunTypeBoolean: {
                BOOL boleanValue = [resultSet boolForColumn:columnInfo.columnName];
                value = @(boleanValue);
                break;
            }
            case BGDatabaseColunTypeBlob: {
                NSData *dataValue = [resultSet dataForColumn:columnInfo.columnName];
                value = dataValue;
                break;
            }
            case BGDatabaseColunTypeDate: {
                NSDate *date = [resultSet dateForColumn:columnInfo.columnName];
                value = date;
                break;
            }
            default:
                break;
        }
        if ([item respondsToSelector:@selector(setValueForProperty:dabaseValue:)]) {
            [(id<BGDatabaseAccessible>)item setValueForProperty:columnInfo.propertyName dabaseValue:value];
        } else {
            [item setValue:value forKey:columnInfo.propertyName];
        }
    }
    return item;
}

- (BGDatabaseTableInfo *)tableInfo
{
    if (!_tableInfo) {
        _tableInfo = [BGDatabaseTableInfo tableInfoForClass:[self itemClass]];
    }
    return _tableInfo;
}

@end
