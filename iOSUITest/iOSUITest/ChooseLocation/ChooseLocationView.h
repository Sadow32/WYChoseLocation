//
//  ChooseLocationView.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLocationView : UIView

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) void(^chooseFinish)(void);

@property (nonatomic,copy) NSString *addressCode;

/**
 标题, 默认为"所在地区"
 */
@property (nonatomic, copy) NSString *title;

/**
 标题字体, 默认为 系统字体 17号
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 标题颜色, 默认为黑色 black
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 正常状态下地址按钮字体 默认为 系统字体 14号
 */
@property (nonatomic, strong) UIFont *normalButtonTitleFont;

/**
 选中状态下地址按钮字体 默认为 系统字体 14号
 */
@property (nonatomic, strong) UIFont *selectedButtonTitleFont;

/**
 正常状态下地址按钮文字颜色 默认为 黑色 black
 */
@property (nonatomic, strong) UIColor *normalButtonTitleColor;

/**
 选中状态下地址按钮文字颜色 默认为 橘黄色 orange
 */
@property (nonatomic, strong) UIColor *selectedButtonTitleColor;

/**
 正常状态下地址按钮字体 默认为 系统字体 14号
 */
@property (nonatomic, strong) UIFont *normalAddressFont;

/**
 选中状态下地址按钮字体 默认为 系统字体 14号
 */
@property (nonatomic, strong) UIFont *selectedAddressFont;

/**
 正常状态下地址按钮文字颜色 默认为 黑色 black
 */
@property (nonatomic, strong) UIColor *normalAddressColor;

/**
 选中状态下地址按钮文字颜色 默认为 橘黄色 orange
 */
@property (nonatomic, strong) UIColor *selectedAddressColor;

@end
