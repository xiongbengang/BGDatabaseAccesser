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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BGDemoDatabaseManager *databaseManager = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).databaseManager;
    
    BGPerson *person = [[BGPerson alloc] init];
    person.pid = @"1001";
    person.age = 12;
    person.name = @"小明";
    person.address = @"北京市";
    
    BGPersonEngine *personEngine = [[BGPersonEngine alloc] initWithDatabaseProvider:databaseManager];
    [personEngine insertPerson:person];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
