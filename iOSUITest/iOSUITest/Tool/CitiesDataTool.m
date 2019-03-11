//
//  CitiesDataTool.m
//  ChooseLocation
//
//  Created by Sekorm on 16/10/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "CitiesDataTool.h"
#import "FMDB.h"

static NSString * const dbName = @"location.db";
static NSString * const ProvincesTableName = @"ProvincesTabbleName";
static NSString * const CitiesTableName = @"CitiesTabbleName";
static NSString * const AreasTableName = @"AreasTabbleName";
static NSString * const StreetsTableName = @"StreetsTabbleName";

typedef NS_ENUM(NSUInteger, LocationDataType) {
    LocationTypeProvince,
    LocationTypeCity,
    LocationTypeArea,
    LocationTypeStreet,
};

@interface CitiesDataTool ()

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) NSMutableArray *provinceDatas;
//@property (nonatomic, strong) NSMutableArray *cityDatas;
//@property (nonatomic, strong) NSMutableArray *areaDatas;
//@property (nonatomic, strong) NSMutableArray *streetDatas;
@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation CitiesDataTool

static CitiesDataTool *shareInstance = nil;

#pragma mark - Singleton
+ (instancetype)sharedManager {
    static CitiesDataTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[CitiesDataTool alloc] init];
    });
    return tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
        }
    }
    return shareInstance;
}

- (instancetype)copy {
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatDB];
    }
    return self;
}

- (void)creatDB {
    
    NSString *dbPath = [self pathForName:dbName];
    self.fmdb = [FMDatabase databaseWithPath:dbPath];
}

- (void)deleteDB {
    NSString *dbPath = [self pathForName:dbName];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
}

- (NSString *)pathForName:(NSString *)name {
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"db"];
    return dbPath;
}

/**
 表示否创建成功

 @param tableName 表名
 @return 返回状态
 */
- (BOOL)isTableOK:(NSString *)tableName {
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        FMResultSet *rs = [self.fmdb executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count)
            {
                [self.fmdb close];
                return NO;
            }
            else
            {
                [self.fmdb close];
                return YES;
            }
        }
    }
    [self.fmdb close];
    return NO;
}

/**
 缓存全部数据,(建库,建表,读\存数据)
 */
- (void)requestAllData {
    [self requestDataWithType:LocationTypeProvince];
    [self requestDataWithType:LocationTypeCity];
    [self requestDataWithType:LocationTypeArea];
    [self requestDataWithType:LocationTypeStreet];
}

/**
 请求地址数据

 @param type 类型
 */
- (void)requestDataWithType:(LocationDataType)type {
    
    NSString *tableName = @"";
    NSString *jsonName = @"";
    switch (type) {
        case LocationTypeProvince:
            tableName = ProvincesTableName;
            jsonName = @"provinces";
            break;
        case LocationTypeCity:
            tableName = CitiesTableName;
            jsonName = @"cities";
            break;
        case LocationTypeArea:
            tableName = AreasTableName;
            jsonName = @"areas";
            break;
        case LocationTypeStreet:
            tableName = StreetsTableName;
            jsonName = @"streets";
            break;
            
        default:
            break;
    }
    if ([self isTableOK:tableName]) {
        return;
    }
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSArray * jsonObjectArray =[NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:&error];
    NSMutableArray *datas = [NSMutableArray array];
    for (NSDictionary *dic in jsonObjectArray) {
        switch (type) {
            case LocationTypeProvince: {
                ProvinceModel *model = [ProvinceModel mj_objectWithKeyValues:dic];
                [datas addObject:model];
            }
                break;
            case LocationTypeCity: {
                CityModel *model = [CityModel mj_objectWithKeyValues:dic];
                [datas addObject:model];
            }
                break;
            case LocationTypeArea: {
                AreaModel *model = [AreaModel mj_objectWithKeyValues:dic];
                [datas addObject:model];
            }
                break;
            case LocationTypeStreet: {
                StreetModel *model = [StreetModel mj_objectWithKeyValues:dic];
                [datas addObject:model];
            }
                break;
                
            default:
                break;
        }
    }
    if (datas.count > 0  && [self createTableWithType:type]) {
        _dataArray = [NSMutableArray arrayWithArray:datas];
        [self insertRecordsWithType:type];
    }
}

/**
 往表中插入数据
 
 @param type 类型
 */
- (void)insertRecordsWithType:(LocationDataType)type {
    
    // 开启事务
    if ([self.fmdb open] && [self.fmdb beginTransaction]) {
        
        BOOL isRollBack = NO;
        @try {
            switch (type) {
                case LocationTypeProvince: {
                    
                    for (ProvinceModel *item in self.dataArray) {
                        
                        NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO %@ ('code','name','level') VALUES ('%@','%@','1')",
                                              ProvincesTableName, item.code, item.name];
                        BOOL success = [self.fmdb executeUpdate:insertSql];
                        if (!success) {
                            NSLog(@"插入地址信息数据失败");
                        } else {
                            NSLog(@"批量插入地址信息数据成功！");
                        }
                    }
                }
                    break;
                case LocationTypeCity: {
                    
                    for (CityModel *item in self.dataArray) {
                        
                        NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO %@ ('code','name','provinceCode','level') VALUES ('%@','%@','%@','2')",
                                              CitiesTableName, item.code, item.name, item.provinceCode];
                        BOOL success = [self.fmdb executeUpdate:insertSql];
                        if (!success) {
                            NSLog(@"插入地址信息数据失败");
                        } else {
                            NSLog(@"批量插入地址信息数据成功！");
                            
                        }
                    }
                }
                    break;
                case LocationTypeArea:{
                    
                    for (AreaModel *item in self.dataArray) {
                        
                        NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO %@ ('code','name','provinceCode','cityCode','level') VALUES ('%@','%@','%@','%@','3')",
                                              AreasTableName, item.code, item.name, item.provinceCode, item.cityCode];
                        BOOL success = [self.fmdb executeUpdate:insertSql];
                        if (!success) {
                            NSLog(@"插入地址信息数据失败");
                        } else {
                            NSLog(@"批量插入地址信息数据成功！");
                            
                        }
                    }
                }
                    break;
                case LocationTypeStreet:{
                    
                    for (StreetModel *item in self.dataArray) {
                        
                        NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO %@ ('code','name','provinceCode','cityCode','areaCode','level') VALUES ('%@','%@','%@','%@','%@','4')",
                                              StreetsTableName, item.code, item.name, item.provinceCode, item.cityCode, item.areaCode];
                        BOOL success = [self.fmdb executeUpdate:insertSql];
                        if (!success) {
                            NSLog(@"插入地址信息数据失败");
                        } else {
                            NSLog(@"批量插入地址信息数据成功！");
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [self.fmdb rollback];
        }
        @finally {
            if (!isRollBack) {
                [self.fmdb commit];
            }
        }
        [self.fmdb close];
        
    } else {
        [self insertRecordsWithType:type];
    }
}

/**
 删除表

 @param string 表名
 @return 删除是否成功
 */
- (BOOL)deleteTable:(NSString *)string {
    if (![self isTableOK:string]) {
        return YES;
    }
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", string];
        
        if (![self.fmdb executeUpdate:sqlstr]) {
            [self.fmdb close];
            return NO;
        }
    }
    [self.fmdb close];
    return YES;
}

/**
 建表

 @param type 表类型
 @return 是否成功
 */
- (BOOL)createTableWithType:(LocationDataType)type {
    
    BOOL result = NO;
    NSString *sql = @"";
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        /*
         [{"code":"65","name":"新疆维吾尔自治区"},
         {"code":"1201","name":"市辖区","provinceCode":"12"},
         {"code":"659006","name":"铁门关市","cityCode":"6590","provinceCode":"65"},
         {"code":"110101001","name":"东华门街道办事处","areaCode":"110101","cityCode":"1101","provinceCode":"11"}]
         */
        switch (type) {
            case LocationTypeProvince: {
                sql = [NSString stringWithFormat:@"create table if not exists %@ (code text primary key,name text,level text);", ProvincesTableName];
            }
                break;
            case LocationTypeCity: {
                sql = [NSString stringWithFormat:@"create table if not exists %@ (code text primary key,name text,provinceCode text,level text);", CitiesTableName];
            }
                break;
            case LocationTypeArea: {
                sql = [NSString stringWithFormat:@"create table if not exists %@ (code text primary key,name text,provinceCode text, cityCode text,level text);", AreasTableName];
            }
                break;
            case LocationTypeStreet: {
                sql = [NSString stringWithFormat:@"create table if not exists %@ (code text primary key,name text,provinceCode text, cityCode text,areaCode text,level text);", StreetsTableName];
            }
                break;
                
            default:
                break;
        }
        result = [self.fmdb executeUpdate:sql];
        if (!result) {
            NSLog(@"创建地址表失败");
            
        } else {
            NSLog(@"创建地址表成功");
        }
    }
    [self.fmdb close];
    return result;
}

/**
 查询所有省

 @return 省
 */
- (NSMutableArray *)queryAllProvince {
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = '1'", ProvincesTableName];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            ProvinceModel *model = [[ProvinceModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (ProvinceModel *)queryProvinceWithCode:(NSString *)code {
    if (code.length != 2) {
        return nil;
    }
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = '1' AND `code` = '%@'", ProvincesTableName, code];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        ProvinceModel *model = [[ProvinceModel alloc] init];
        if ([result next]) {
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
        }
        [self.fmdb close];
        return model;
    }
    return nil;
}

/**
 根据省查询市

 @param province 省code
 @return 市
 */
- (NSMutableArray *)queryAllCitiesWithProvinceID:(NSString *)province {
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `provinceCode` = '%@' AND `level` = '2'"  , CitiesTableName, province];
        FMResultSet *result = [self.fmdb executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            CityModel *model = [[CityModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            model.provinceCode = [result stringForColumn:@"provinceCode"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (CityModel *)queryCityWithCode:(NSString *)code {
    if (code.length != 4) {
        return nil;
    }
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = '2' AND `code` = '%@'"  , CitiesTableName, code];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        CityModel *model = [[CityModel alloc] init];
        while ([result next]) {
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            model.provinceCode = [result stringForColumn:@"provinceCode"];
        }
        [self.fmdb close];
        return model;
    }
    return nil;
}

/**
 根据省\市 查询县区

 @param province 省
 @param city 市
 @return 县区
 */
- (NSMutableArray *)queryAllAreasWithProvinceID:(NSString *)province cityID:(NSString *)city {
    
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `provinceCode` = %@ AND `cityCode` = %@ AND `level` = 3", AreasTableName, province, city];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            AreaModel *model = [[AreaModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            model.cityCode = [result stringForColumn:@"cityCode"];
            model.provinceCode = [result stringForColumn:@"provinceCode"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (AreaModel *)queryAreaWithCode:(NSString *)code {
    if (code.length != 6) {
        return nil;
    }
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = '3' AND `code` = '%@'"  , AreasTableName, code];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        AreaModel *model = [[AreaModel alloc] init];
        if ([result next]) {
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            model.cityCode = [result stringForColumn:@"cityCode"];
            model.provinceCode = [result stringForColumn:@"provinceCode"];
        }
        [self.fmdb close];
        return model;
    }
    return nil;
}

/**
 根据省\市\县区 查询镇

 @param province 省
 @param city 市
 @param area 区
 @return 镇
 */
- (NSMutableArray *)queryAllStreetsWithProvinceID:(NSString *)province cityID:(NSString *)city areaID:(NSString *)area {
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `provinceCode` = %@ AND `cityCode` = %@ AND `areaCode` = %@ AND `level` = 4", StreetsTableName, province, city, area];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            StreetModel *model = [[StreetModel alloc] init];
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            model.areaCode = [result stringForColumn:@"areaCode"];
            model.cityCode = [result stringForColumn:@"cityCode"];
            model.provinceCode = [result stringForColumn:@"provinceCode"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (StreetModel *)queryStreetWithCode:(NSString *)code {
    if (code.length != 9) {
        return nil;
    }
    if ([self.fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `level` = '4' AND `code` = '%@'"  , StreetsTableName, code];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        StreetModel *model = [[StreetModel alloc] init];
        if ([result next]) {
            model.code = [result stringForColumn:@"code"];
            model.name = [result stringForColumn:@"name"];
            model.areaCode = [result stringForColumn:@"areaCode"];
            model.cityCode = [result stringForColumn:@"cityCode"];
            model.provinceCode = [result stringForColumn:@"provinceCode"];
        }
        [self.fmdb close];
        return model;
    }
    return nil;
}

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
