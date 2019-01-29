//
//  AreaModel.h
//  iOSUITest
//
//  Created by 武月洋 on 2019/1/23.
//  Copyright © 2019 武月洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBaseModel.h"

@interface AreaModel : AddressBaseModel

@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityCode;

@end
