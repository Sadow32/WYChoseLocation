//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"
#import "AddressTableViewCell.h"
//#import "AddressItem.h"
#import "CitiesDataTool.h"
#import "AddressButton.h"

#define HYScreenW [UIScreen mainScreen].bounds.size.width

static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度s

@interface ChooseLocationView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) AddressView *topTabbar;
@property (nonatomic, weak) UIScrollView *contentView;
//@property (nonatomic, strong) UIView *underLine;
@property (nonatomic, strong) NSArray *provinceDatas;
@property (nonatomic, strong) NSArray *cityDatas;
@property (nonatomic, strong) NSArray *areaDatas;
@property (nonatomic, strong) NSArray *streetDatas;
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) NSMutableArray *topTabbarItems;
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - setUp UI

- (void)setUp {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topView];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height *0.5;
    titleLabel.centerX = topView.width *0.5;
    UIView *separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];
    
    _topTabbar = [[AddressView alloc] initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kHYTopViewHeight)];
    _topTabbar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topTabbar];
    [self addTopBarItem];
    [_topTabbar layoutIfNeeded];
    
//    _underLine = [[UIView alloc] initWithFrame:CGRectZero];
//    _underLine.frame = CGRectMake(0, kHYTopViewHeight-2, 0, 2);
//    _underLine.backgroundColor = [UIColor orangeColor];
//    [_topTabbar addSubview:_underLine];
    UIButton *btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    _contentView.delegate = self;
}

- (void)addTableView {

    UITableView *tabbleView = [[UITableView alloc] initWithFrame:CGRectMake(self.tableViews.count *HYScreenW, 0, HYScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.rowHeight = 44;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)addTopBarItem {
    
    AddressButton *topBarItem = [AddressButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [topBarItem sizeToFit];
    topBarItem.centerY = _topTabbar.height *0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addButton:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.tableViews indexOfObject:tableView] == 0) {
        return self.provinceDatas.count;
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        return self.cityDatas.count;
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        return self.areaDatas.count;
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
        return self.streetDatas.count;
    }
    return self.provinceDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddressBaseModel *item;
    if ([self.tableViews indexOfObject:tableView] == 0) {
        item = self.provinceDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        item = self.cityDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        item = self.areaDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
        item = self.streetDatas[indexPath.row];
    }
    cell.item = item;
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableViews indexOfObject:tableView] == 0) {
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        ProvinceModel *provinceItem = self.provinceDatas[indexPath.row];
        self.cityDatas = [[CitiesDataTool sharedManager] queryAllCitiesWithProvinceID:provinceItem.code];
        if (self.cityDatas.count == 0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self setUpAddress:provinceItem.name];
            return indexPath;
        }
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath *indexPath0 = [tableView indexPathForSelectedRow];
        
        if (indexPath0) {
            NSInteger tableCounts = self.tableViews.count;
            for (int i = 0; i < tableCounts - 1; i++) {
                [self removeLastItem];
            }
            [self setButtonTitle:provinceItem.name];
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem];
            return indexPath;
        }
        //之前未选中省，第一次选择省
        ProvinceModel *item = self.provinceDatas[indexPath.row];
        [self setButtonTitle:item.name];
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem];
        
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        
        CityModel *cityItem = self.cityDatas[indexPath.row];
        self.areaDatas = [[CitiesDataTool sharedManager] queryAllAreasWithProvinceID:cityItem.provinceCode cityID:cityItem.code];
        NSIndexPath *indexPath0 = [tableView indexPathForSelectedRow];
        
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            NSInteger tableCounts = self.tableViews.count;
            for (int i = 0; i < tableCounts - 2; i++) {
                [self removeLastItem];
            }
            [self setButtonTitle:cityItem.name];
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem];
            return indexPath;
            
        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            
            [self scrollToNextItem];
            return indexPath;
        }
        CityModel *item = self.cityDatas[indexPath.row];
        [self setButtonTitle:item.name];
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem];
        
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        
        AreaModel *areaItem = self.areaDatas[indexPath.row];
        self.streetDatas = [[CitiesDataTool sharedManager] queryAllStreetsWithProvinceID:areaItem.provinceCode cityID:areaItem.cityCode areaID:areaItem.code];
        NSIndexPath *indexPath0 = [tableView indexPathForSelectedRow];
        
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            NSInteger tableCounts = self.tableViews.count;
            for (int i = 0; i < tableCounts - 3; i++) {
                [self removeLastItem];
            }
            [self setButtonTitle:areaItem.name];
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem];
            return indexPath;
        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            [self scrollToNextItem];
            return indexPath;
        }
        AreaModel *item = self.areaDatas[indexPath.row];
        [self setButtonTitle:item.name];
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem];
        
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
        
        StreetModel *item = self.streetDatas[indexPath.row];
        [self setUpAddress:item.name];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressBaseModel *item;
    if ([self.tableViews indexOfObject:tableView] == 0) {
       item = self.provinceDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
       item = self.cityDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
       item = self.areaDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
        item = self.streetDatas[indexPath.row];
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressBaseModel *item;
    if ([self.tableViews indexOfObject:tableView] == 0) {
        item = self.provinceDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        item = self.cityDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        item = self.areaDatas[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
        item = self.streetDatas[indexPath.row];
    }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}
#pragma mark - private
//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn {
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake(index *HYScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}
//调整指示条位置
- (void)changeUnderLineFrame:(UIButton *)btn {
    
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
//    _underLine.left = btn.left;
//    _underLine.width = btn.width;
}
//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address {

    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton *btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    [self settingAddress];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}
//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem {

    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}
- (void)setButtonTitle:(NSString *)preTitle {
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton *btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
}
//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize) {self.tableViews.count *HYScreenW,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.btnArray lastObject]];
    }];
}

- (void)settingAddress {
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    for (UIButton *btn in self.topTabbarItems) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@" "];
    }
    self.address = addressStr;
}

#pragma mark - <UIScrollView>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView != self.contentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / HYScreenW;
        UIButton *btn = weakSelf.topTabbarItems[index];
        [weakSelf changeUnderLineFrame:btn];
    }];
}

#pragma mark - 开始就有地址时.

- (void)setAddressCode:(NSString *)addressCode {
    
    _addressCode = addressCode;
    
    NSString *provinceId = [self.addressCode substringWithRange:NSMakeRange(0, 2)];
    NSString *cityId = [self.addressCode substringWithRange:NSMakeRange(0, 4)];
    NSString *areaId = [self.addressCode substringWithRange:NSMakeRange(0, 6)];
    NSString *streetId = [self.addressCode substringWithRange:NSMakeRange(0, 9)];
    
    //2.1 添加市级别,地区级别列表
    [self addTableView];
    [self addTableView];
    [self addTableView];
    
    self.provinceDatas = [[CitiesDataTool sharedManager] queryAllProvince];
    self.cityDatas = [[CitiesDataTool sharedManager] queryAllCitiesWithProvinceID:provinceId];
    self.areaDatas = [[CitiesDataTool sharedManager] queryAllAreasWithProvinceID:provinceId cityID:cityId];
    self.streetDatas = [[CitiesDataTool sharedManager] queryAllStreetsWithProvinceID:provinceId cityID:cityId areaID:areaId];
  
    //2.3 添加底部对应按钮
    [self addTopBarItem];
    [self addTopBarItem];
    [self addTopBarItem];
    
    ProvinceModel *province = [[CitiesDataTool sharedManager] queryProvinceWithCode:provinceId];
    UIButton *proBtn = self.topTabbarItems.firstObject;
    [proBtn setTitle:province.name forState:UIControlStateNormal];
    
    CityModel *city = [[CitiesDataTool sharedManager] queryCityWithCode:cityId];
    UIButton *cityBtn = self.topTabbarItems[1];
    [cityBtn setTitle:city.name forState:UIControlStateNormal];
    
    AreaModel *area = [[CitiesDataTool sharedManager] queryAreaWithCode:areaId];
    UIButton *areaBtn = self.topTabbarItems[2];
    [areaBtn setTitle:area.name forState:UIControlStateNormal];
    
    StreetModel *street = [[CitiesDataTool sharedManager] queryStreetWithCode:streetId];
    UIButton *streetBtn = self.topTabbarItems.lastObject;
    [streetBtn setTitle:street.name forState:UIControlStateNormal];
    
    [self.topTabbarItems makeObjectsPerformSelector:@selector(sizeToFit)];
    [_topTabbar layoutIfNeeded];
    
    [self changeUnderLineFrame:streetBtn];
    
    //2.4 设置偏移量
    self.contentView.contentSize = CGSizeMake(self.tableViews.count * HYScreenW, 0);
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViews.count - 1) *HYScreenW, offset.y);
    [self settingAddress];
    [self setSelectedProvince:province city:city area:area street:street];
}

//初始化选中状态
- (void)setSelectedProvince:(ProvinceModel *)province city:(CityModel *)city area:(AreaModel *)area street:(StreetModel *)street {
    
    for (int i = 0; i < self.provinceDatas.count; i++) {
        ProvinceModel *item = self.provinceDatas[i];
        if ([item.name isEqualToString:province.name]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.provinceDatas indexOfObject:item] inSection:0];
            UITableView *tableView = self.tableViews.firstObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i < self.cityDatas.count; i++) {
        CityModel *item = self.cityDatas[i];
        if ([item.name isEqualToString:city.name]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView *tableView = self.tableViews[1];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i <self.areaDatas.count; i++) {
        AreaModel *item = self.areaDatas[i];
        if ([item.name isEqualToString:area.name]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView *tableView = self.tableViews[2];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i <self.streetDatas.count; i++) {
        StreetModel *item = self.streetDatas[i];
        if ([item.name isEqualToString:street.name]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView *tableView = self.tableViews.lastObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark - getter 方法

//分割线
- (UIView *)separateLine{
    
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


//省级别数据源
- (NSArray *)provinceDatas{
    
    if (!_provinceDatas) {
       
        _provinceDatas = [[CitiesDataTool sharedManager] queryAllProvince];
    }
    return _provinceDatas;
}
@end
