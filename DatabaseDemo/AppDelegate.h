//
//  AppDelegate.h
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/13.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGDemoDatabaseManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) BGDemoDatabaseManager *databaseManager;
@property (strong, nonatomic) UIWindow *window;


@end

