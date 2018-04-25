//
//  BGPersonAccesser.h
//  DatabaseDemo
//
//  Created by Bengang on 2018/4/19.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGBaseDataAccesser.h"
#import "BGPerson.h"

@interface BGPersonAccesser : BGBaseDataAccesser

- (long long)queryMaxPersonId;

@end
