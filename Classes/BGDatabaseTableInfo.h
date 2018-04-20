//
//  BGDatabaseTableInfo.h
//  Kiwi
//
//  Created by Bengang on 2018/4/13.
//

#import <Foundation/Foundation.h>
#import "BGDatabaseColumnInfo.h"

@interface BGDatabaseTableInfo : NSObject

@property (nonatomic, copy, readonly) NSString *tableName;
@property (nonatomic, strong, readonly) BGDatabaseColumnInfo *primaryKey;
@property (nonatomic, copy, readonly) NSArray<BGDatabaseColumnInfo *> *columns;

+ (instancetype)tableInfoForClass:(Class)itemClass;

@end
