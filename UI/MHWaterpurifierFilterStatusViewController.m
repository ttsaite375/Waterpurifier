//
//  MHWaterpurifierFilterStatusViewController.m
//  MiHome
//
//  Created by wayne on 15/7/6.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterpurifierFilterStatusViewController.h"
#import "MHFourFilterSketchView.h"
#import "MHWebViewController.h"
#import "MHWaterpurifierDefine.h"
#import "MHWaterpurifierDeviceHelp.h"

//zcm 两个滤芯的Sketch
//#import "MHDeviceWaterPurifierLX.h"
#import "MHTwoFilterSketchView.h"
#import "YMScreenAdapter.h"


@interface MHWaterpurifierFilterStatusViewController ()

@end

@implementation MHWaterpurifierFilterStatusViewController
{
    //zcm 改变sketch类型，适应两种模板
//    MHFilterStatusSketchView * _sketchView;
    UIView* _sketchView;
    UILabel* _filterTitle;
    UITextView* _filterDesc;
    UIButton* _buyFilter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WaterpurifierString(@"filter.status", @"滤芯状态");
    self.view.backgroundColor = [MHColorUtils colorWithRGB:0xF8F8F8];
    self.isTabBarHidden = YES;
    self.isNavBarTranslucent = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildSubviews {
    //滤芯安装帮助按钮
    UIImage* imageFilterHelp = [[UIImage imageNamed:@"waterpurifier_filter_help"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *filterHelpButton = [[UIBarButtonItem alloc] initWithImage:imageFilterHelp style:UIBarButtonItemStyleDone target:self action:@selector(helpAction)];
    self.navigationItem.rightBarButtonItem = filterHelpButton;
    
    XM_WS(weakself);
    
    //离线设备，由于之前的版本没有缓存数据，所以要针对获取不到数据时处理一下
    BOOL noData = YES;
    if (self.filterObject.totalTime > 0) {
        noData = NO;
    }
    
    
    //lsl修改 修改到期、快到期颜色
    UIColor *color = nil;
    
    if (!noData) {
        NSInteger days = (NSInteger)((self.filterObject.totalTime * self.filterObject.lifePercentage)/24);
        if (days > 0 && days <=15) {
            color = [MHColorUtils colorWithRGB:0xffff9800];
        }else if (days <= 0){
            color = [MHColorUtils colorWithRGB:0xffff4500];
        }else{
            color = [MHColorUtils colorWithRGB:0xff00caed];
        }
    }else{
        color = [UIColor grayColor];
    }
    
    
//    _sketchView = [MHFilterStatusSketchView new];
//    _sketchView.filterObject = self.filterObject;
//
//    [self.view addSubview:_sketchView];
//    [_sketchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        XM_SS(strongself, weakself);
//        make.centerX.equalTo(weakself.view);
//        make.top.mas_equalTo(140.0);
//        make.width.mas_equalTo(CGRectGetWidth(self.view.bounds) * 0.5);
//        make.height.equalTo(strongself->_sketchView.mas_width).multipliedBy(1.15);
//    }];

    //zcm 修改滤芯Sketch
    if([self.deviceModel isEqualToString:DeviceModelWaterPuriLX5]) {
        //zcm 米二代 2芯模板
        MHTwoFilterSketchView *twoSketchView = [MHTwoFilterSketchView new];
        twoSketchView.filterObject = self.filterObject;
        _sketchView = twoSketchView;
        
        [self.view addSubview:_sketchView];
        [_sketchView mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(strongself, weakself);
            make.centerX.equalTo(weakself.view);
            make.top.equalTo(weakself.view.mas_top).offset([YMScreenAdapter sizeBy750:150+64]);
            make.width.mas_equalTo([YMScreenAdapter sizeBy750:580]);
            make.height.mas_equalTo([YMScreenAdapter sizeBy750:194]);
        }];
    }else {
        //zcm 米一代 4芯模板
        MHFourFilterSketchView *fourSketchView = [MHFourFilterSketchView new];
        _sketchView = fourSketchView;
        fourSketchView.filterObject = self.filterObject;
        [self.view addSubview:_sketchView];
        [_sketchView mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(strongself, weakself);
            make.centerX.equalTo(weakself.view);
//            make.top.mas_equalTo(140.0);
            make.top.mas_equalTo([YMScreenAdapter sizeBy750:150+64]);
            make.width.mas_equalTo(CGRectGetWidth(self.view.bounds) * 0.5);
            make.height.equalTo(strongself->_sketchView.mas_width).multipliedBy(1.15);
        }];
    }
    

    NSMutableAttributedString* filterTitleAttrString = [NSMutableAttributedString new];
    NSString* name = self.filterObject.name;
    NSDictionary* nameAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:20.f], NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.8]};
    NSAttributedString* nameAttrString = [[NSAttributedString alloc] initWithString:name attributes:nameAttr];
    
    NSString* seperator = @" | ";
    NSDictionary* seperatorAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:18.f], NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x7C7C7C]};
    NSAttributedString* seperatorAttrString = [[NSAttributedString alloc] initWithString:seperator attributes:seperatorAttr];
    
    
    if (self.filterObject.lifePercentage < 0 || isnan(self.filterObject.lifePercentage)) {
        //不知道为啥，用模拟器会出现一个很大的负数或nan，不知道真机会不会出现（真机没重现），加个步骤控制一下吧
        self.filterObject.lifePercentage = 0;
    }
    
    NSString* percentage = @"";
    if (!noData) {
        percentage = [NSString stringWithFormat:WaterpurifierString(@"filter.available.percentage", @"剩余%d%%"), (int)(self.filterObject.lifePercentage*100)];
    }else{
        percentage = @"--%";
    }
    
//    NSString* percentage = [NSString stringWithFormat:WaterpurifierString(@"filter.available.percentage", @"剩余%d%%"), (int)(self.filterObject.lifePercentage*100)];
    
    
    NSDictionary* percentageAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:20.f], NSForegroundColorAttributeName : color};
    //[MHColorUtils colorWithRGB:0x00CAED]
    NSAttributedString* percentageAttrString = [[NSAttributedString alloc] initWithString:percentage attributes:percentageAttr];
    
    [filterTitleAttrString appendAttributedString:nameAttrString];
    [filterTitleAttrString appendAttributedString:seperatorAttrString];
    [filterTitleAttrString appendAttributedString:percentageAttrString];
    
    _filterTitle = [UILabel new];
    _filterTitle.numberOfLines = 0;
    _filterTitle.textAlignment = NSTextAlignmentCenter;
    _filterTitle.attributedText = filterTitleAttrString;
    [self.view addSubview:_filterTitle];
    [_filterTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.left.equalTo(weakself.view).offset(CGRectGetWidth(weakself.view.bounds)*0.05);
        make.right.equalTo(weakself.view).offset(-CGRectGetWidth(weakself.view.bounds)*0.05);
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(strongself->_sketchView.mas_bottom).offset(43.0);
    }];
    
    _filterDesc = [UITextView new];
    _filterDesc.backgroundColor = [UIColor clearColor];
    [_filterDesc setShowsVerticalScrollIndicator:NO];
    _filterDesc.editable = NO;
    _filterDesc.selectable = NO; //zcm add：exception中的描述TextView也是不可选中，这边也不选选中
    _filterDesc.font = [UIFont systemFontOfSize:14.f];
    _filterDesc.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //_filterDesc.numberOfLines = 0;
    _filterDesc.text = self.filterObject.desc;
    [self.view addSubview:_filterDesc];
    [_filterDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.left.equalTo(weakself.view).offset(CGRectGetWidth(weakself.view.bounds)*0.05);
        make.right.equalTo(weakself.view).offset(-CGRectGetWidth(weakself.view.bounds)*0.05);
        make.top.equalTo(strongself->_filterTitle.mas_bottom).offset(10.0);
    }];
    
    _buyFilter = [UIButton new];
    [_buyFilter setTitle:WaterpurifierString(@"filter.purchase.now", @"立即购买") forState:UIControlStateNormal];
    [_buyFilter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage* bgImage = [[UIImage imageNamed:@"waterpurifier_filter_buy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 45.0, 5.0, 45.0)];
    UIImage* bgImagehl = [[UIImage imageNamed:@"waterpurifier_filter_buy_button_hl"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 45.0, 5.0, 45.0)];
    [_buyFilter setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_buyFilter setBackgroundImage:bgImagehl forState:UIControlStateHighlighted];
    [_buyFilter addTarget:self action:@selector(buyFilterClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buyFilter];
    [_buyFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.top.equalTo(strongself->_filterDesc.mas_bottom).offset(10);
        make.left.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)*0.05);
        make.right.equalTo(weakself.view).offset(-CGRectGetWidth([UIScreen mainScreen].bounds)*0.05);
        make.bottom.equalTo(weakself.view).offset(-CGRectGetHeight([UIScreen mainScreen].bounds)*0.05);
        make.height.mas_equalTo(42.0);
    }];
    
//    if([self.deviceModel isEqualToString:DeviceModelWaterPuriLX5]) {
//        _buyFilter.hidden = YES;
//    }
}

- (void)buyFilterClicked:(id)sender
{
//    //初始化警告框
//    UIAlertController*alert = [UIAlertController
//                               alertControllerWithTitle: @"温馨提示"
//                               message: @"尚未开启，敬请期待"
//                               preferredStyle:UIAlertControllerStyleAlert];
//
//    [alert addAction:[UIAlertAction
//                      actionWithTitle:@"确定"
//                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                          [alert dismissViewControllerAnimated:YES completion:^{
//
//                          }];
//    }]];
//    //弹出提示框
//    [self presentViewController:alert animated:YES completion:nil];
//
//    return;
    
    //    [[MHOpenInMiHomeManager sharedInstance] handleOpenURLString:@"mihome://purchase?gid=71"];
    
    
//        NSLog(@"name:%@",name);
//        NSString *keyword = [NSString stringWithFormat:@"小米净水器滤芯 %@",name];
//        NSString *message = [NSString stringWithFormat:@"http://home.mi.com/shop/search?keyword=%@&source=com.water.controller",keyword];
//        NSLog(@"message:%@",message);

#ifdef SDK
#else
    
//    NSString *name = @"";
//    if (self.filterObject.index == 1) {
//        name = @"PP棉";
//    }else if (self.filterObject.index == 2){
//        name = @"前置活性炭";
//    }else if (self.filterObject.index == 3){
//        name = @"反渗透";
//    }else{
//        name = @"后置活性炭";
//    }
    
    //zcm 米二代添加1、2号滤芯的关键词
    BOOL isWaterPuriLX5 = [self.deviceModel isEqualToString:DeviceModelWaterPuriLX5];
    
    NSString *name = @"";
    
    switch (self.filterObject.index) {
        case 1:
            name = isWaterPuriLX5 ? @"米二代3合1复合滤芯" : @"PP棉";
            break;
        case 2:
            name = isWaterPuriLX5 ? @"米二代RO反渗透滤芯" : @"前置活性炭";
            break;
        case 3:
            name = @"反渗透";
            break;
        case 4:
            name = @"后置活性炭";
            break;
        default:
            break;
    }
    
    NSString *keyword = isWaterPuriLX5 ? name : [NSString stringWithFormat:@"小米净水器滤芯 %@",name];
    
    NSString *url = [NSString stringWithFormat:@"https://home.mi.com/shop/search?keyword=%@&source=com.water.controller&action=check",keyword];
    
//    [[MiotStoreSDK sharedInstance] simulateJSOpenUrl:url withNaviController:self.navigationController withOpenNewView:YES];
    [[MHMediator sharedInstance] MJYPStoreSystemManager_openPageWithURLString:url parentViewController:self.navigationController closeCallback:nil];
//    [[MJYPStoreSystemManager shareManager] openPageWithURLString:url parentViewController:self.navigationController closeCallback:nil];
#endif
}

- (void)helpAction
{
    NSString *filterInstallTipsUrl = @"";
    if ([MHWaterpurifierDeviceHelp isOnDevice:self.deviceModel]) {
        filterInstallTipsUrl = @"https://viomi-faq.mi-ae.net/misetup/filtersetup.html";
    }else{
        if([self.deviceModel isEqualToString:DeviceModelWaterPuriLX5]) {
            filterInstallTipsUrl = @"https://viomi-resource.mi-ae.net/filtersetup.html?type=mi2&lang=zh-Hans";
        }else {
            filterInstallTipsUrl = @"https://viomi-faq.mi-ae.net/misetup/filtersetup_under.html";
        }
    }
    MHWebViewController* webVC = [MHWebViewController new];
    webVC.URL = [NSURL URLWithString:filterInstallTipsUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}



@end
