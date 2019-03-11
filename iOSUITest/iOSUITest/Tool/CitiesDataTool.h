//
//  CitiesDataTool.h
//  ChooseLocation
//
//  Created by Sekorm on 16/10/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"
#import "StreetModel.h"

@interface CitiesDataTool : NSObject

+ (instancetype)sharedManager;

/**
 缓存全部数据,(建库,建表,读\存数据)
 */
- (void)requestAllData;

/**
 查询所有省
 
 @return 省
 */
- (NSMutableArray *)queryAllProvince;
- (ProvinceModel *)queryProvinceWithCode:(NSString *)code;

/**
 根据省查询市
 
 @param province 省code
 @return 市
 */
- (NSMutableArray *)queryAllCitiesWithProvinceID:(NSString *)province;
- (CityModel *)queryCityWithCode:(NSString *)code;

/**
 根据省\市 查询县区
 
 @param province 省
 @param city 市
 @return 县区
 */
- (NSMutableArray *)queryAllAreasWithProvinceID:(NSString *)province cityID:(NSString *)city;
- (AreaModel *)queryAreaWithCode:(NSString *)code;

/**
 根据省\市\县区 查询镇
 
 @param province 省
 @param city 市
 @param area 区
 @return 镇
 */
- (NSMutableArray *)queryAllStreetsWithProvinceID:(NSString *)province cityID:(NSString *)city areaID:(NSString *)area;
- (StreetModel *)queryStreetWithCode:(NSString *)code;

@end
