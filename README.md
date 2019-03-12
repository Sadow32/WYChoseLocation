# ChooseLocation
京东选择收货地址

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

## 待实现

1. 设置地址code自动选择相应地址【完成】
2. 地址展示栏改为 scrollView，显示超过屏幕长度的地址【完成】
3. scrollView 设置地址code后第一次显示末尾地址有一个显示不全的bug 【完成】
4. 统一控件各项颜色、字体的配置
5. 优化控件弹出的流程
6. 添加弹出动画

## 导读

目前大多数APP的地址选择是用系统的picker View,也不乏用tableview自定义的.
这里分享一个高仿京东的地址选择给大家.
源码地址:https://github.com/HelloYeah/ChooseLocation
欢迎大家checkout,Star...

##### 下面是京东收货地址的一些交互以及代码思路分析

>1. 刚打开选择地址视图时,底部ScrollView的滚动范围只有一屏宽.
>
>2. 点击某个省时,增加对应的市级列表,底部ScrollView横向滚动区域增加一屏宽.

![1.gif](http://upload-images.jianshu.io/upload_images/1338042-16ffa01913c5ccf6.gif?imageMogr2/auto-orient/strip)

>1. 当重新选择省的时候,移除后面的市级别列表,区级别列表
>
>2. 移除顶部的市按钮,区按钮.
>
>3. 并且底部ScrollView的滚动范围减少至两屏宽.

![2.gif](http://upload-images.jianshu.io/upload_images/1338042-7bc0307bf43ebf45.gif?imageMogr2/auto-orient/strip)



>1. 当重新选择省市的时候,对应顶部按钮的宽度跟着改变,对应下级的按钮的x值要相应调整
>
>2. 按钮底部的指示条的长度和位置跟着相应变化

![tmp5deefbb7.png](http://upload-images.jianshu.io/upload_images/1338042-78137181ccaaad4e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 其他注意点

>1. 点击灰色区域,取消地址选择,回到主界面
>
>2. 京东用的是网络请求获取省市区信息,每点击一个cell,向服务器发送请求,获取下级信息.这里用的是本地json数据





源码地址:https://github.com/HelloYeah/ChooseLocation
欢迎大家checkout,Star...
