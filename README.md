# 概况

仿京东地址选择的控件

在这个 [ChooseLocation](https://github.com/HelloYeah/ChooseLocation) 项目的基础上更改了数据库的结构，优化了逻辑和展示效果。

地址数据来自 [Administrative-divisions-of-China](https://github.com/modood/Administrative-divisions-of-China)



# 更新日志 

## 修改 2019年03月12日

1. 修改了 scrollView 设置地址code后第一次显示末尾地址显示不全的bug
2. 优化了选择地之后的逻辑，选择地址如果超出屏幕，会滚动到最后一个选项。

## 修改 2019年03月11日

1. 实现根据设置code自动选择相应地址
2. 实现地址展示栏改为 scrollView，显示超过屏幕长度的地址
3. 读取本地已经创建完毕的db，不再在程序运行时创建新的db，解决第一次使用时因为创建db卡顿的问题。

## 修改 2019年01月29日

1. 增加第四级地址选择
2. 优化一些逻辑代码
3. 加入了MJExtension库
4. 统一代码格式
5. 添加注释
6. 测试

## 待实现

- [x] 设置地址code自动选择相应地址

- [x] 地址展示栏改为 scrollView，显示超过屏幕长度的地址

- [x] scrollView 设置地址code后第一次显示末尾地址有一个显示不全的bug

- [ ] 统一控件各项颜色、字体的配置

- [ ] 优化控件弹出的流程

- [ ] 添加弹出动画
