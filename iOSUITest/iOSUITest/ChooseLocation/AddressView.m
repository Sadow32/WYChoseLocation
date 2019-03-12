//
//  AddressView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressView.h"
#import "UIView+Frame.h"

static  CGFloat  const  HYBarItemMargin = 20;
@interface AddressView ()

@end

@implementation AddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _btnArray = [NSMutableArray array];
        
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
        separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [self addSubview:separateLine];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, self.frame.size.height - 2)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
        underLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        [self addSubview:underLine];
    }
    return self;
}

- (void)addButton:(UIButton *)button {
    
    [_scrollView addSubview:button];
    [self refreshAllFreame];
}

- (void)layoutSubviews{
   
    [super layoutSubviews];
    [self refreshAllFreame];
}

- (void)refreshAllFreame {
    CGFloat maxWidth = 0;
    for (NSInteger i = 0; i < self.btnArray.count; i++) {
        
        UIButton *view = self.btnArray[i];
        CGFloat width = [view.titleLabel.text
                         boundingRectWithSize:CGSizeMake(1000, self.frame.size.height - 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        if (i == 0) {
            view.left = HYBarItemMargin;
        }
        if (i > 0) {
            UIView * preView = self.btnArray[i - 1];
            view.left = HYBarItemMargin  + preView.right;
        }
        maxWidth = view.left + width + HYBarItemMargin;
    }
    _scrollView.contentSize = CGSizeMake(maxWidth, self.frame.size.height - 2);
    if (maxWidth > self.frame.size.width) {
        [_scrollView setContentOffset:CGPointMake(maxWidth - self.frame.size.width, 0) animated:YES];
    }
}

- (NSMutableArray *)btnArray{
    
    NSMutableArray * mArray  = [NSMutableArray array];
    for (UIView * view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end
