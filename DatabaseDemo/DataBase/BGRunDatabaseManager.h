//
//  BGRunDatabaseManager.h
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import <Foundation/Foundation.h>
#import "BGDatabaseQueue.h"

@interface BGRunDatabaseManager : NSObject

@property (nonatomic, strong, readonly) BGDatabaseQueue *databaseQueue;

- (void)initializeWithDBPath:(NSString *)dbPath dbVersion:(NSInteger)dbVersion;

@end
