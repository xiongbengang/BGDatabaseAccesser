//
//  BGDatabaseQueue.h
//  Kiwi
//
//  Created by Bengang on 10/01/2018.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface BGDatabaseQueue : NSObject

@property (nonatomic, strong, readonly) FMDatabase *database;

- (instancetype)initWithDatabase:(FMDatabase *)database;

- (void)inDatabase:(void (^)(FMDatabase *database))block;

- (BOOL)inTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block;

@end
