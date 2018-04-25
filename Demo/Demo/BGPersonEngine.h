//
//  BGPersonEngine.h
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGBaseDataEngine.h"
#import "BGPersonAccesser.h"
#import "BGPerson.h"

@interface BGPersonEngine : BGBaseDataEngine

@property (nonatomic, strong) BGPersonAccesser *personAccesser;

@end
