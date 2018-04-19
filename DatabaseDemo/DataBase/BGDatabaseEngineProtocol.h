//
//  BGDatabaseEngineProtocol.h
//  Kiwi
//
//  Created by CC on 2018/4/6.
//

#import <Foundation/Foundation.h>
#import "BGDatabaseQueue.h"

@protocol BGDatabaseEngineProtocol <NSObject>

@property (nonatomic, strong, readonly) FMDatabase *database;
@property (nonatomic, strong, readonly) BGDatabaseQueue *databaseQueue;

@end
