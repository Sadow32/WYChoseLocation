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

@end
