//
//  AddressBaseModel.h
//  iOSUITest
//
//  Created by 武月洋 on 2019/1/29.
//  Copyright © 2019 武月洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface AddressBaseModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) BOOL isSelected;

@end
