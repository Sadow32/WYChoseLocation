//
//  AddressButton.m
//  iOSUITest
//
//  Created by 武月洋 on 2019/3/11.
//  Copyright © 2019 武月洋. All rights reserved.
//

#import "AddressButton.h"

@interface AddressButton ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation AddressButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bottomLineColor = UIColor.orangeColor;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 2, frame.size.width, 2)];
        _lineView.backgroundColor = _bottomLineColor;
        [self addSubview:_lineView];
        _lineView.hidden = YES;
    }
    return self;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    _lineView.backgroundColor = _bottomLineColor;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _lineView.frame = CGRectMake(0, frame.size.height - 2, frame.size.width, 2);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _lineView.hidden = !selected;
}

@end
