//
//  BGBaseDataEngine.h
//  Kiwi
//
//  Created by CC on 2018/4/6.
//

#import <Foundation/Foundation.h>
#import "BGDatabaseManager.h"

@interface BGBaseDataEngine : NSObject

@property (nonatomic, strong, readonly) FMDatabase *database;

- (instancetype)initWithDatabaseProvider:(__kindof BGDatabaseManager *)databaseProvider;

- (void)inDatabase:(void (^)(FMDatabase *database))block;

- (BOOL)inTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block;

@end
