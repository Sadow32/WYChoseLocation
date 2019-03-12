//
//  AddressView.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *btnArray;

- (void)addButton:(UIButton *)button;
- (void)refreshAllFreame;

@end
