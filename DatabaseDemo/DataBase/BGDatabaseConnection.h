//
//  BGDatabaseConnection.h
//  Kiwi
//
//  Created by Bengang on 11/01/2018.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@protocol BGDatabaseConnectionDelegate <NSObject>

@optional
- (void)onConfigure:(FMDatabase *)database;

- (void)onCreate:(FMDatabase *)database;

- (void)onUpgrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;

- (void)onDowngrade:(FMDatabase *)database oldVersion:(NSInteger)oldVersion newVersion:(NSInteger)newVersion;

- (void)onOpen:(FMDatabase *)database;

@end

@interface BGDatabaseConnection : NSObject

@property (nonatomic, strong, readonly) FMDatabase *database;
@property (nonatomic, weak) id<BGDatabaseConnectionDelegate> delegate;

- (instancetype)initWithPath:(NSString *)path version:(NSInteger)version delegate:(id<BGDatabaseConnectionDelegate>)delegate;

- (void)close;

@end
