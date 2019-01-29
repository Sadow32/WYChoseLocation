//
//  ViewController.m
//  iOSUITest
//
//  Created by 武月洋 on 2019/1/16.
//  Copyright © 2019 武月洋. All rights reserved.
//

#import "ViewController.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"

@interface ViewController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CitiesDataTool sharedManager] requestAllData];
    [self.view addSubview:self.cover];
    self.chooseLocationView.address = @"广东省 广州市 越秀区";
    self.chooseLocationView.areaCode = @"440104";
    self.addresslabel.text = @"广东省 广州市 越秀区";
}

- (IBAction)chooseAction:(UIButton *)sender {
    
    self.cover.hidden = !self.cover.hidden;
    self.chooseLocationView.hidden = self.cover.hidden;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}

- (ChooseLocationView *)chooseLocationView{
    
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        
    }
    return _chooseLocationView;
}

- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            weakSelf.addresslabel.text = weakSelf.chooseLocationView.address;
            weakSelf.view.transform = CGAffineTransformIdentity;
            weakSelf.cover.hidden = YES;
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

@end
