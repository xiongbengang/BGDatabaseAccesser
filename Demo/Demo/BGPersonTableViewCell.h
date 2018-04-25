//
//  BGPersonTableViewCell.h
//  Demo
//
//  Created by Bengang on 2018/4/24.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPerson.h"

@interface BGPersonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *personIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)bind:(BGPerson *)person;

@end
