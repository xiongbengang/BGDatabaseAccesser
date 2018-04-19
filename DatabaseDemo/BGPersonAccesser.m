//
//  BGPersonAccesser.m
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGPersonAccesser.h"
#import "BGPerson.h"

@implementation BGPersonAccesser

- (Class)itemClass
{
    return [BGPerson class];
}

@end
