//
//  BGColumnInfo.h
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BGDatabaseColunType) {
    BGDatabaseColunTypeUnknown = 0,
    BGDatabaseColunTypeText = 1,
    BGDatabaseColunTypeReal = 2,
    BGDatabaseColunTypeDate = 3,
    BGDatabaseColunTypeBlob = 4,
    BGDatabaseColunTypeBoolean = 5,
    BGDatabaseColunTypeInteger = 6,
    BGDatabaseColunTypeFloat = 7,
    BGDatabaseColunTypeDouble = 8,
    BGDatabaseColunTypeLongDouble = 9,
};

extern NSString *BGDatabaseColumnTypeDesc(BGDatabaseColunType columnType);

@interface BGDatabaseColumnInfo : NSObject

@property (nonatomic, copy) NSString *columnName;         // 列名
@property (nonatomic, copy) NSString *propertyName;       // 字段名
@property (nonatomic, assign) BGDatabaseColunType type;   // 字段类型
@property (nonatomic, copy) NSString *ext;                // 字段修饰
@property (nonatomic, assign) BOOL isPrimaryKey;
@property (nonatomic, assign) BOOL systemManaged;         // 根据item进行插入、更新的时候是否忽略掉该字段

@end
