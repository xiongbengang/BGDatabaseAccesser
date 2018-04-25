//
//  ViewController.m
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/13.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "BGPersonEngine.h"
#import "BGDemoDatabaseManager.h"
#import "BGPersonTableViewCell.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) BGPersonEngine *personEngine;

@property (nonatomic, copy) NSArray<BGPerson *> *persons;

@property (nonatomic, assign) long long maxPersonId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryAndReloadDatas];
}

- (void)queryAndReloadDatas
{
    self.persons = [self.personEngine.personAccesser queryItemsWithCondition:@"ORDER BY id"];
    [self.tableView reloadData];
}

- (IBAction)insertButtonClick:(id)sender
{
    [self testInsert];
    [self queryAndReloadDatas];
}

- (IBAction)updateButtonClick:(id)sender
{
    [self testUpdate];
    [self queryAndReloadDatas];
}

- (IBAction)update2ButtonClick:(id)sender
{
    [self testUpdate2];
    [self queryAndReloadDatas];
}

- (IBAction)update4ButtonClick:(id)sender
{
    [self testUpdate4];
    [self queryAndReloadDatas];
}

- (IBAction)deleteAllButtonClick:(id)sender
{
    [self.personEngine.personAccesser deleteAll];
    [self queryAndReloadDatas];
}

- (IBAction)update3ButtonClick:(id)sender
{
    [self testUpdate3];
    [self queryAndReloadDatas];
}

- (void)testInsert
{
    BGPerson *person = [[BGPerson alloc] init];
    person.pid = [@(self.maxPersonId+1) stringValue];
    person.age = 12;
    person.name = @"小明";
    person.address = @"北京市";
    [self.personEngine.personAccesser insertObject:person];
    self.maxPersonId += 1;
}

- (void)testUpdate
{
    BGPerson *person = [[BGPerson alloc] init];
    person.pid = [@(self.maxPersonId) stringValue];
    person.age = 77;
    person.name = @"小明";
    person.address = @"上海市浦东区";

    [self.personEngine.personAccesser updateWithItem:person];
}

- (void)testUpdate2
{
    BGPerson *person = [[BGPerson alloc] init];
    person.pid = [@(self.maxPersonId) stringValue];
    person.age = 12;
    person.name = @"小华明";
    person.address = @"上海市浦东区 AAAAA";
    
    BOOL rs = [self.personEngine.personAccesser updateWithItem:person forKeyPaths:@[@"name", @"address"]];
    NSLog(@"execute result %@", @(rs));
}

- (void)testUpdate3
{
    BGPerson *person = [[BGPerson alloc] init];
    person.pid = [@(self.maxPersonId) stringValue];
    person.age = 22;
    person.name = @"张三";
    person.address = @"北京市 昭阳区  XXXX 东区";
    
//    BOOL rs = [self.personEngine.personAccesser updateWithItem:person forKeyPaths:@[@"age"]];
    BOOL rs = [self.personEngine.personAccesser updateWithItem:person ignoredKeyPaths:@[@"age"]];
    NSLog(@"execute result %@", @(rs));
}

- (void)testUpdate4
{
    BGPerson *person = [[BGPerson alloc] init];
    person.pid = [@(self.maxPersonId) stringValue];
    person.age = 33;
    person.name = @"李四";
    person.address = @"陕西省南关区 少时诵诗书";
    
//    BOOL rs = [self.personEngine.personAccesser updateWithItem:person ignoredKeyPaths:@[@"address"]];
    BOOL rs = [self.personEngine.personAccesser updateWithKeyPaths:@[@"name", @"address"] values:@[@"熊熊", @"大海南哈哈哈哈"] condition:@"WHERE id=?", @(self.maxPersonId), nil];
    NSLog(@"execute result %@", @(rs));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGPersonTableViewCell *personCell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    BGPerson *person = self.persons[indexPath.row];
    [personCell bind:person];
    return personCell;
}

- (BGPersonEngine *)personEngine
{
    if (!_personEngine) {
        BGDemoDatabaseManager *databaseManager = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).databaseManager;
        _personEngine = [[BGPersonEngine alloc] initWithDatabaseProvider:databaseManager];
    }
    return _personEngine;
}

- (long long)maxPersonId
{
    if (_maxPersonId <= 0) {
        _maxPersonId = [self.personEngine.personAccesser queryMaxPersonId];
    }
    return _maxPersonId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
