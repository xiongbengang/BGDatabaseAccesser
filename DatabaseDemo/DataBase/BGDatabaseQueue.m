//
//  BGDatabaseQueue.m
//  Kiwi
//
//  Created by Bengang on 10/01/2018.
//

#import "BGDatabaseQueue.h"

@interface BGDatabaseQueue ()

@property (nonatomic, strong) dispatch_queue_t dbQueue;

@end

@implementation BGDatabaseQueue


- (instancetype)initWithDatabase:(FMDatabase *)database
{
    self = [super init];
    if (self) {
        _database = database;
        NSString *queueName = [NSString stringWithFormat:@"mmdb_queue_%@", self];
        _dbQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)inDatabase:(void (^)(FMDatabase *database))block
{
    dispatch_sync(_dbQueue, ^{
        block(self.database);
    });
}

- (BOOL)inTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block
{
    __block BOOL successful = YES;
    dispatch_sync(_dbQueue, ^{
        BOOL rollback = NO;
        BOOL inTransaction = [self.database isInTransaction];
        if (!inTransaction) {
            [self.database beginTransaction];
        }
        block(self.database, &rollback);
        successful = !rollback;
        if (!inTransaction) {
            rollback ? [self.database rollback] : [self.database commit];
        }
    });
    return successful;
}

@end
