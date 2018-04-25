//
//  BGPersonTableViewCell.m
//  Demo
//
//  Created by Bengang on 2018/4/24.
//  Copyright © 2018年 Bengang. All rights reserved.
//

#import "BGPersonTableViewCell.h"

@implementation BGPersonTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bind:(BGPerson *)person
{
    self.personIdLabel.text = [NSString stringWithFormat:@"id：%@", person.pid];
    self.personNameLabel.text = [NSString stringWithFormat:@"姓名：%@",  person.name];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@", person.address];
    self.ageLabel.text = [NSString stringWithFormat:@"年龄：%@", @(person.age)];
}

@end
