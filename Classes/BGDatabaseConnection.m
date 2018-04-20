//
//  BGDatabaseConnection.m
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import "BGDatabaseConnection.h"

@interface BGDatabaseConnection ()

@property (nonatomic, strong, readwrite) FMDatabase *database;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) NSInteger version;

@end

@implementation BGDatabaseConnection

- (instancetype)initWithPath:(NSString *)path version:(NSInteger)version delegate:(id<BGDatabaseConnectionDelegate>)delegate
{
    self = [super init];
    if (self) {
        _path = [path copy];
        _version = version;
        _delegate = delegate;
    }
    return self;
}

- (NSInteger)queryDBVersion:(FMDatabase *)database;
{
    return [database intForQuery:@"PRAGMA user_version;"];
}

- (void)saveDBVersion:(NSInteger)version database:(FMDatabase *)database
{
    NSString *updateVersion = [[NSString alloc] initWithFormat:@"PRAGMA user_version=%d;", (int)version];
    [database executeUpdate:updateVersion];
}

- (FMDatabase *)database
{
    if (_database && [_database open]) {
        return _database;
    }
    FMDatabase *db = [[FMDatabase alloc] initWithPath:self.path];
    [db open];
    self.database = db;
    [self onConfigure:db];
    NSInteger version = [self queryDBVersion:db];
    if (version != self.version) {
        [db beginTransaction];
        if (version == 0) {
            [self onCreate:db];
        } else {
            if (self.version > version) {
                [self onUpgrade:db oldVersion:version newVersion:self.version];
            } else {
                [self onDowngrade:db oldVersion:version newVersion:self.version];
            }
        }
        [self saveDBVersion:self.version database:db];
        [db commit];
    }
    [self onOpen:db];
    return _database;
}

- (void)close
{
    [self.database close];
}

- (void)onConfigure:(FMDatabase *)database
{
    if ([self.delegate respondsToSelector:@selector(onConfigure:)]) {
        [self.delegate onConfigure:database];
    }
}
- (void)onCreate:(FMDatabase *)database
{
    if ([self.delegate respondsToSelector:@selector(onCreate:)]) {
        [self.delegate onCreate:database];
    }
}
- (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion
{
    if ([self.delegate respondsToSelector:@selector(onUpgrade:oldVersion:newVersion:)]) {
        [self.delegate onUpgrade:database oldVersion:oldVersion newVersion:newVersion];
    }
}
- (void)onDowngrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion
{
    if ([self.delegate respondsToSelector:@selector(onDowngrade:oldVersion:newVersion:)]) {
        [self.delegate onDowngrade:database oldVersion:oldVersion newVersion:newVersion];
    }
}
- (void)onOpen:(FMDatabase *)database
{
    if ([self.delegate respondsToSelector:@selector(onOpen:)]) {
        [self.delegate onOpen:database];
    }
}

@end
