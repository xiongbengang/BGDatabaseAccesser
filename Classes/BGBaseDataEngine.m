//
//  BGBaseDataEngine.m
//  Kiwi
//
//  Created by CC on 2018/4/6.
//

#import "BGBaseDataEngine.h"

@interface BGBaseDataEngine ()

@property (nonatomic, strong) BGDatabaseManager *databaseProvider;
@property (nonatomic, strong) BGDatabaseQueue *databaseQueue;

@end

@implementation BGBaseDataEngine

- (instancetype)initWithDatabaseProvider:(__kindof BGDatabaseManager *)databaseProvider
{
    self = [super init];
    if (self) {
        _databaseProvider = databaseProvider;
    }
    return self;
}

- (BGDatabaseQueue *)databaseQueue
{
    return self.databaseProvider.databaseQueue;
}

- (FMDatabase *)database
{
    return self.databaseProvider.database;
}

- (void)inDatabase:(void (^)(FMDatabase *database))block
{
    [self.databaseQueue inDatabase:block];
}

- (BOOL)inTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block
{
    return [self.databaseQueue inTransaction:block];
}

@end
