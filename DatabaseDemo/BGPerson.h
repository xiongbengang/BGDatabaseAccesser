//
//  BGPerson.h
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGDatabase.h"

@interface BGPerson : NSObject <BGDatabase>

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *address;

@end
