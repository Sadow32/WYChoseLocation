//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressBaseModel.h"

@interface AddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;
@end
@implementation AddressTableViewCell

- (void)setItem:(AddressBaseModel *)item {
    
    _item = item;
    _addressLabel.text = item.name;
    _addressLabel.textColor = item.isSelected ? [UIColor orangeColor] : [UIColor blackColor] ;
    _selectFlag.hidden = !item.isSelected;
}
@end
