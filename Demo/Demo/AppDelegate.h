//
//  AppDelegate.h
//  Demo
//
//  Created by Bengang on 2018/4/20.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGDemoDatabaseManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BGDemoDatabaseManager *databaseManager;


@end

