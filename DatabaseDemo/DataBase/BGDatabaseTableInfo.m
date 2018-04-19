//
//  BGDatabaseTableInfo.m
//  Kiwi
//
//  Created by Bengang on 2018/4/13.
//

#import "BGDatabaseTableInfo.h"
#import "BGDatabaseAccessible.h"
#import <YYModel/YYModel.h>

static inline BGDatabaseColunType BGColumnTypeForProperty(YYClassPropertyInfo *property) {
    YYEncodingType type = property.type & YYEncodingTypeMask;
    if (type == YYEncodingTypeObject) {
        if ([property.cls isSubclassOfClass:[NSString class]]) {
            return BGDatabaseColunTypeText;
        } else if ([property.cls isSubclassOfClass:[NSNumber class]]) {
            return BGDatabaseColunTypeReal;
        } else if ([property.cls isSubclassOfClass:[NSDate class]]) {
            return BGDatabaseColunTypeDate;
        } else if ([property.cls isSubclassOfClass:[NSData class]]) {
            return BGDatabaseColunTypeBlob;
        }
    } else if (type == YYEncodingTypeBool) {
        return BGDatabaseColunTypeBoolean;
    } else if (type == YYEncodingTypeInt8 ||
               type == YYEncodingTypeUInt8 ||
               type == YYEncodingTypeInt16 ||
               type == YYEncodingTypeUInt16 ||
               type == YYEncodingTypeInt32 ||
               type == YYEncodingTypeUInt32 ||
               type == YYEncodingTypeInt64 ||
               type == YYEncodingTypeUInt64) {
        return BGDatabaseColunTypeInteger;
    } else if (type == YYEncodingTypeFloat) {
        return BGDatabaseColunTypeFloat;
    } else if (type == YYEncodingTypeDouble) {
        return BGDatabaseColunTypeDouble;
    } else if (type == YYEncodingTypeLongDouble) {
        return BGDatabaseColunTypeLongDouble;
    }
    return BGDatabaseColunTypeUnknown;
}

@interface BGDatabaseTableInfo ()

@property (nonatomic, copy, readwrite) NSString *tableName;
@property (nonatomic, strong, readwrite) BGDatabaseColumnInfo *primaryKey;
@property (nonatomic, copy, readwrite) NSArray<BGDatabaseColumnInfo *> *columns;

@end

@implementation BGDatabaseTableInfo

+ (instancetype)tableInfoForClass:(Class)cls
{
    if (!cls) return nil;
    static NSMutableDictionary<NSString *, BGDatabaseTableInfo *> *tableInfoCache = nil;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        tableInfoCache = [NSMutableDictionary dictionary];
        lock = dispatch_semaphore_create(1);
    });
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:cls];
    BGDatabaseTableInfo *databaseInfo = nil;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    databaseInfo = tableInfoCache[classInfo.name];
    dispatch_semaphore_signal(lock);
    if (!databaseInfo) {
        databaseInfo = [[self alloc] initWithClass:cls];
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [tableInfoCache setObject:databaseInfo forKey:classInfo.name];
        dispatch_semaphore_signal(lock);
    }
    return databaseInfo;
}

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:cls];
        NSString *tableName = classInfo.name;
        if ([cls respondsToSelector:@selector(tableName)]) {
            tableName = [(id<BGDatabaseAccessible>)cls tableName];
        }
        self.tableName = tableName;
        NSSet<NSString *> *propertyBlacklist = [NSSet setWithArray:@[@"debugDescription", @"description", @"hash", @"superclass"]];
        if ([cls respondsToSelector:@selector(databasePropertyBlacklist)]) {
            NSArray *blacklist = [(id<BGDatabaseAccessible>)cls databasePropertyBlacklist];
            if (blacklist) {
                NSMutableSet *tempSet = [NSMutableSet setWithSet:propertyBlacklist];
                [tempSet addObjectsFromArray:blacklist];
                propertyBlacklist = [NSSet setWithSet:tempSet];
            }
        }
        NSDictionary<NSString *, NSString *> *propertyColumnMapper = nil;
        if ([cls respondsToSelector:@selector(propertyColumnMapper)]) {
            propertyColumnMapper = [(id<BGDatabaseAccessible>)cls propertyColumnMapper];
        }
        NSArray<YYClassPropertyInfo *> *properties = classInfo.propertyInfos.allValues;
        NSMutableArray<BGDatabaseColumnInfo *> *columns = [NSMutableArray arrayWithCapacity:properties.count];
        for (YYClassPropertyInfo *property in properties) {
            if ([propertyBlacklist containsObject:property.name] ||
                ![cls instancesRespondToSelector:property.setter]) {  // readOnly
                continue;
            }
            BGDatabaseColumnInfo *column = [[BGDatabaseColumnInfo alloc] init];
            column.propertyName = property.name;
            NSString *columnName = propertyColumnMapper[property.name];
            if (!columnName.length) {
                columnName = property.name;
            }
            column.columnName = columnName;
            column.type = BGColumnTypeForProperty(property);
            if ([cls respondsToSelector:@selector(configColumn:forProperty:)]) {
                [(id<BGDatabaseAccessible>)cls configColumn:column forProperty:property.name];
            }
            if (column.type == BGDatabaseColunTypeUnknown) {     // 类型不匹配 并且外面也没指定
                continue;
            }
            if (column.isPrimaryKey) {
                self.primaryKey = column;
            }
            [columns addObject:column];
        }
        self.columns = columns;
    }
    return self;
}



@end
