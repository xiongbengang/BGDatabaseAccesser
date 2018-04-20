## 集成: pod "BGDatabaseAccesser"
## 类介绍
- BGDatabaseAccessible 数据model协议，遵循该协议之后可以建立起表和实体类之间的关系
- BGDatabaseManager  数据库初始化类，负责表的创建，数据库版本的升级以及数据库线程安全的保证工作
- BGBaseDataAccesser 数据库访问类，包括数据的增删改查操作。一个数据model应该对应一个accesser
- BGBaseDataEngine    提供对外的数据库访问类 调用BGBaseDataAccesser操作
- BGDatabaseColumnInfo  数据库列信息
- BGDatabaseTableInfo  数据库表信息 有缓存
- BGDatabaseConnection    数据库连接类
- BGDatabaseQueue   数据库线程安全保证类

## 使用介绍

1. 继承 BGDemoDatabaseManager  重写- (NSInteger)dbVersion 方法 以及 - (void)onCreate:(FMDatabase *)database; 等方法 
2. 针对业务继承 BGBaseDataEngine 自定义数据库访问逻辑

3. 创建BGBaseDataEngine 实例 进行数据库访问操作

eg:

BGDemoDatabaseManager
```
@implementation BGDemoDatabaseManager

- (NSInteger)dbVersion
{
    return 2;
}

- (void)onCreate:(FMDatabase *)database
{
    [super onCreate:database];
    [self createTableForClass:[BGPerson class] inDatabase:database];
}

@end

```
BGPersonEngine

```
@implementation BGPersonEngine

- (void)insertPerson:(BGPerson *)person
{
    [self inDatabase:^(FMDatabase *database) {
        [self.personAccesser insertObject:person];
    }];
}

- (BGPersonAccesser *)personAccesser
{
    if (!_personAccesser) {
        _personAccesser = [[BGPersonAccesser alloc] initWithDatabase:self.database];
    }
    return _personAccesser;
}

@end

```

ViewController

```
@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    BGDemoDatabaseManager *databaseManager = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).databaseManager;

    BGPerson *person = [[BGPerson alloc] init];
    person.pid = @"1001";
    person.age = 12;
    person.name = @"小明";
    person.address = @"北京市";

    BGPersonEngine *personEngine = [[BGPersonEngine alloc] initWithDatabaseProvider:databaseManager];
    [personEngine insertPerson:person];
}

@end

```


