//
//  MHWaterpurifierExceptionViewController.m
//  MiHome
//
//  Created by wayne on 15/7/17.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterpurifierExceptionViewController.h"
#import "MHWebViewController.h"
#import "MHWaterpurifierDefine.h"
#define kUrlForUsageTips   @"https://viomi-api.mi-ae.net/static/doc/science_pop/mini.html"

#import "YMScreenAdapter.h"

#import "MHWaterpurifierDeviceHelp.h"

@interface MHWaterpurifierExceptionViewController ()

@end

@implementation MHWaterpurifierExceptionViewController
{
    UIImageView* _exceptionImage;
    UILabel* _exceptionTitle;
    UILabel* _exceptionIntro;
    UIScrollView* _introScroll;
    UIView* _scrollContainer;
    UIButton* _handleBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.device.name;
    self.isTabBarHidden = YES;
    self.isNavBarTranslucent = YES;
    if (self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro) {
        [self.device setTapLedUsageIntroduced];
    }
}

///**zcm 修改
// *  描述：拨打电话时，状态栏会消失，视图会整体上移。需要立即更新约束
// *  修复：立即更新约束
// */
//- (void)viewWillAppear:(BOOL)animated {
//    [self.view layoutIfNeeded];
//}

- (void)buildSubviews {
    _exceptionImage = [UIImageView new];
    _exceptionImage.image = [self exceptionImageForSerialNo:self.exceptionSerialNo];
    _exceptionImage.contentMode = UIViewContentModeScaleAspectFill;
    _exceptionImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_exceptionImage];
    
    _exceptionTitle = [UILabel new];
    _exceptionTitle.numberOfLines = 0;
    _exceptionTitle.textAlignment = NSTextAlignmentCenter;
    _exceptionTitle.font = [UIFont boldSystemFontOfSize:20.f];
    _exceptionTitle.textColor = [MHColorUtils colorWithRGB:0xfd9727];
    _exceptionTitle.text = [[self class] exceptionTitleForSerialNo:self.exceptionSerialNo ofDeviceModel:self.device.model];
    [self.view addSubview:_exceptionTitle];
    
    _introScroll = [UIScrollView new];
    _introScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_introScroll];
    _scrollContainer = [UIView new];
    [_introScroll addSubview:_scrollContainer];
    
    if (@available(iOS 11.0, *)){
        _introScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _exceptionIntro = [UILabel new];
    _exceptionIntro.font = [UIFont systemFontOfSize:14.f];
    _exceptionIntro.textColor = [MHColorUtils colorWithRGB:0x9e9e9e];
    _exceptionIntro.numberOfLines = 0;
    _exceptionIntro.text = [[self class] exceptionIntroForSerialNo:self.exceptionSerialNo ofDeviceModel:self.device.model];
    [_scrollContainer addSubview:_exceptionIntro];
    
    //zcm 删除 改用 craeteHandleButton 减少判断，
//    if ([self isButtonVisible]) {
//        _handleBtn = [UIButton new];
//        _handleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        [_handleBtn setTitle:[self handleEntryTitle] forState:UIControlStateNormal];
//        [_handleBtn setTitleColor:[MHColorUtils colorWithRGB:0x636363] forState:UIControlStateNormal];
//        
    //        UIImage* btnBgImage = [[UIImage imageNamed:@"waterpurifier_handle_btn_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    //        [_handleBtn setBackgroundImage:btnBgImage forState:UIControlStateNormal];
//
//        [_handleBtn addTarget:self action:@selector(handleException:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_handleBtn];
//    }
    
    _handleBtn = [self createHandleButton];
    
    [_handleBtn addTarget:self action:@selector(handleException:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_handleBtn];
}

- (void)buildConstraints {
    XM_WS(ws);
//    [_exceptionImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(ws.view).offset(15.0);
//        make.right.equalTo(ws.view).offset(-15.0);
//        make.centerX.equalTo(ws.view);
//        make.centerY.equalTo(ws.view).multipliedBy(0.6);
//        make.height.mas_equalTo(CGRectGetHeight([UIScreen mainScreen].bounds) * 0.4);
//    }];
    
    //zcm 修改约束，之前的都跑到顶上去了
    [_exceptionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset([YMScreenAdapter sizeBy1080:264]);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.height.mas_equalTo([YMScreenAdapter sizeBy1080:560]);
        make.width.mas_equalTo([YMScreenAdapter sizeBy1080:560]);
    }];
    
    [_exceptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.centerX.equalTo(ws.view);
        make.top.equalTo(ss->_exceptionImage.mas_bottom).offset(40.0);
        make.left.equalTo(ws.view).offset(15.0);
        make.right.equalTo(ws.view).offset(-15.0);
    }];
    
    [_handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(25.0);
        make.right.equalTo(ws.view).offset(-25.0);
        if([MHWaterpurifierDeviceHelp isPhoneX]) {
            make.bottom.equalTo(ws.view).offset(-25.0 - MHW_iPhoneX_Bottom / 2);
        }else {
            make.bottom.equalTo(ws.view).offset(-25.0);
        }
    }];
    
    [_introScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.centerX.equalTo(ws.view);
        make.top.equalTo(ss->_exceptionTitle.mas_bottom).offset(10.0);
        make.width.equalTo(ws.view).multipliedBy(0.8);
        if (ss->_handleBtn) {
            make.bottom.equalTo(ss->_handleBtn.mas_top).offset(-10.0);
        } else {
            make.bottom.equalTo(ws.view).offset(-25.0);
        }
        
    }];
    [_scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.edges.equalTo(ss->_introScroll);
        make.width.equalTo(ss->_introScroll);
    }];
    
    [_exceptionIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.top.left.right.equalTo(ss->_scrollContainer);
        make.width.equalTo(ss->_scrollContainer);
    }];
    
    [_scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.bottom.equalTo(ss->_exceptionIntro.mas_bottom);
    }];
    
}


//zcm 定制handle button
- (UIButton *)createHandleButton {
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    if(self.exceptionSerialNo >=MHDeviceWaterpurifierException1 &&
       self.exceptionSerialNo <= MHDeviceWaterpurifierException16 ) {
        //净水器故障 0~16
        [button setTitle:WaterpurifierString(@"exception.feedback.question", @"各区电话") forState:UIControlStateNormal];
        UIImage* btnBgImage = [[UIImage imageNamed:@"waterpurifier_handle_btn_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        
        [button setTitleColor:[MHColorUtils colorWithRGB:0x636363] forState:UIControlStateNormal];
        
        [button setBackgroundImage:btnBgImage forState:UIControlStateNormal];
        
    }else if (self.exceptionSerialNo >= MHDeviceWaterpurifierFilterOneExhausted &&
              self.exceptionSerialNo <= MHDeviceWaterpurifierFilterFourExhausteWill) {
        
        //滤芯寿命耗尽 17 ~
        
        if([self.device.model isEqualToString:DeviceModelWaterPuriLX5]) {
            [button setTitle:@"尚未开启，敬请期待" forState:UIControlStateNormal];;   //zcm add 二代隐藏button,到时候打开
            button.userInteractionEnabled = NO;
        }else {
            [button setTitle:WaterpurifierString(@"filter.purchase", @"直接购买滤芯") forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
        
        UIImage* bgImage = [[UIImage imageNamed:@"waterpurifier_filter_buy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 45.0, 5.0, 45.0)];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIImage* bgImagehl = [[UIImage imageNamed:@"waterpurifier_filter_buy_button_hl"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 45.0, 5.0, 45.0)];
        
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
        
        [button setBackgroundImage:bgImagehl forState:UIControlStateHighlighted];
    }else if(self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro) {
        //使用帮助
        [button setTitle:WaterpurifierString(@"filter.help", @"详情可查看使用帮助") forState:UIControlStateNormal];
        
        [button setTitleColor:[MHColorUtils colorWithRGB:0x636363] forState:UIControlStateNormal];
        
        UIImage* btnBgImage = [[UIImage imageNamed:@"waterpurifier_handle_btn_bg"] resizableImageWithCapInsets:
                               UIEdgeInsetsMake(0, 20, 0, 20)];
        
        [button setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    }else {
        button.hidden = YES;
    }
    
//    if([self.device.model isEqualToString:DeviceModelWaterPuriLX5]) {
//        button.hidden = YES;   //zcm add 二代隐藏button,到时候打开
//    }
    
    return button;
}

//- (BOOL)isButtonVisible
//{
////    if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterFourExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterFourExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro)
////    {
////        return YES;
////    }
////    return NO;
//    
//    //zcm add：除了冲洗提示，其他都将显示按钮
//    return self.exceptionSerialNo <= MHDeviceWaterpurifierTapLEDIntro ? YES : NO;
//}
//
//- (NSString *)handleEntryTitle
//{
//    NSString* title = nil;
////    if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterFourExhausted ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausteWill ||
////        self.exceptionSerialNo == MHDeviceWaterpurifierFilterFourExhausteWill)
////    {
////        title = WaterpurifierString(@"filter.purchase", @"直接购买滤芯");
////    }
////    else if (self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro)
////    {
////        title = WaterpurifierString(@"filter.help", @"详情可查看使用帮助");
////    }else if (self.exceptionSerialNo <= MHDeviceWaterpurifierException16) {
////        //故障电话
////        title = @"400-100-5678";
////    }
//    
//    //zcm add：0~16故障电话，17~24购买滤芯，25帮助详情
//    if(self.exceptionSerialNo <= MHDeviceWaterpurifierException16) {
//        //故障电话
//        title = WaterpurifierString(@"exception.feedback.question", @"各区电话");
//    }else if (self.exceptionSerialNo <= MHDeviceWaterpurifierFilterFourExhausteWill) {
//        title = WaterpurifierString(@"filter.purchase", @"直接购买滤芯");
//    }else if (self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro) {
//        title = WaterpurifierString(@"filter.help", @"详情可查看使用帮助");
//    }
//    return title;
//    
//}

- (void)handleException:(id)sender
{
//    if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausted ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausted ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausted ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterFourExhausted ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausteWill ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausteWill ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausteWill ||
//        self.exceptionSerialNo == MHDeviceWaterpurifierFilterFourExhausteWill)
//    {
//        //        [[MHOpenInMiHomeManager sharedInstance] handleOpenURLString:@"mihome://searchstore?keyword=净水器滤芯"];
//        //        [[MHOpenInMiHomeManager sharedInstance] handleOpenURLString:@"mihome://purchase?gid=71"];
//        
//        //        NSString *name = @"";
//        //        if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausted || self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausteWill) {
//        //            name = @"PP棉";
//        //        }else if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausted || self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausteWill){
//        //            name = @"前置活性炭";
//        //        }else if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausted || self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausteWill){
//        //            name = @"反渗透";//RO滤芯，搜索不到
//        //        }else{
//        //            name = @"后置活性炭";
//        //        }
//        //                    NSLog(@"name:%@",name);
//        //                    NSString *keyword = [NSString stringWithFormat:@"小米净水器滤芯 %@",name];
//        //                    NSString *message = [NSString stringWithFormat:@"http://home.mi.com/shop/search?keyword=%@&source=com.water.controller",keyword];
//        //                    NSLog(@"message:%@",message);
//        
//#ifdef SDK
//#else
//        NSString *name = @"";
//        
//        BOOL isWaterPuriLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
//        
//        if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausted || self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausteWill) {
//            
//            name = isWaterPuriLX5 ? @"3合1复合滤芯" : @"PP棉";
//            
//        }else if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausted || self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausteWill){
//            
//            name = isWaterPuriLX5 ? @"反渗透" : @"前置活性炭";
//            
//        }else if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausted || self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausteWill){
//            
//            name = @"反渗透";//RO滤芯，搜索不到
//            
//        }else{
//            name = @"后置活性炭";
//        }
//        
//        
//        NSString *keyword = [NSString stringWithFormat:@"小米净水器滤芯 %@",name];
//        NSString *url = [NSString stringWithFormat:@"http://home.mi.com/shop/search?keyword=%@&source=com.water.controller&action=check",keyword];
//        [[MiotStoreSDK sharedInstance] simulateJSOpenUrl:url withNaviController:self.navigationController withOpenNewView:YES];
//#endif
//    }else if (self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro)
//    {
//        // "详情可查看使用帮助"
//        MHWebViewController* webVC = [MHWebViewController new];
//        webVC.URL = [NSURL URLWithString:kUrlForUsageTips];
//        [self.navigationController pushViewController:webVC animated:YES];
//        
//    }else if (self.exceptionSerialNo <= MHDeviceWaterpurifierException16) {
//        //故障电话
//        NSURL *url = [NSURL URLWithString:@"tel://400-100-5678"];
//        [[UIApplication sharedApplication] openURL:url];
//    }
    
    //zcm add：0~16故障电话，17~24购买滤芯，25帮助详情
    if(self.exceptionSerialNo <= MHDeviceWaterpurifierException16) {
        //故障电话
        NSURL *url = [NSURL URLWithString:WaterpurifierString(@"exception.feedback.question.link", @"问题反馈URL")];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if(self.exceptionSerialNo <= MHDeviceWaterpurifierFilterFourExhausteWill) {
        
//        //初始化警告框
//        UIAlertController*alert = [UIAlertController
//                                   alertControllerWithTitle: @"温馨提示"
//                                   message: @"尚未开启，敬请期待"
//                                   preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction
//                          actionWithTitle:@"确定"
//                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                              [alert dismissViewControllerAnimated:YES completion:^{
//
//                              }];
//                          }]];
//        //弹出提示框
//        [self presentViewController:alert animated:YES completion:nil];
//
//        return;
        
        //购买滤芯
        
#ifdef SDK
#else
        NSString *name = @"";
        
        BOOL isWaterPuriLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
        
        if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausted ||
            self.exceptionSerialNo == MHDeviceWaterpurifierFilterOneExhausteWill) {
            
            name = isWaterPuriLX5 ? @"米二代3合1复合滤芯" : @"PP棉";
        }else if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausted||
                  self.exceptionSerialNo == MHDeviceWaterpurifierFilterTwoExhausteWill){
            
            name = isWaterPuriLX5 ? @"米二代RO反渗透滤芯" : @"前置活性炭";
            
        }else if (self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausted ||
                  self.exceptionSerialNo == MHDeviceWaterpurifierFilterThreeExhausteWill){
            
            name = @"反渗透";//RO滤芯，搜索不到
        }else{
            name = @"后置活性炭";
        }
        
        NSString *keyword = isWaterPuriLX5 ? name : [NSString stringWithFormat:@"小米净水器滤芯 %@",name];
        
        NSString *url = [NSString stringWithFormat:@"https://home.mi.com/shop/search?keyword=%@&source=com.water.controller&action=check",keyword];
        
//        [[MiotStoreSDK sharedInstance] simulateJSOpenUrl:url withNaviController:self.navigationController withOpenNewView:YES];
        [[MHMediator sharedInstance] MJYPStoreSystemManager_openPageWithURLString:url parentViewController:self.navigationController closeCallback:nil];
//        [[MJYPStoreSystemManager shareManager] openPageWithURLString:url parentViewController:self.navigationController closeCallback:nil];
#endif
    }else if (self.exceptionSerialNo == MHDeviceWaterpurifierTapLEDIntro) {
        // "详情可查看使用帮助"
        MHWebViewController* webVC = [MHWebViewController new];
        webVC.URL = [NSURL URLWithString:kUrlForUsageTips];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}

+ (NSString *)exceptionTitleForSerialNo:(NSInteger)sNo ofDeviceModel:(NSString *)model  {
    //    static NSArray* exceptionTitles = nil;
    //    if (exceptionTitles == nil) {
    //        exceptionTitles = [NSArray arrayWithObjects:
//                                WaterpurifierString(@"exception.title1", @"水温异常"),
//                                WaterpurifierString(@"exception.title2", @"进水流量计损坏"),
//                                WaterpurifierString(@"exception.title3", @"流量传感器异常"),
//                                WaterpurifierString(@"exception.title4", @"滤芯寿命到期"),
//                                WaterpurifierString(@"exception.title5", @"Wifi通讯异常"),
//                                WaterpurifierString(@"exception.title6", @"eeprom通讯异常"),
//                                WaterpurifierString(@"exception.title7", @"rfid通讯异常"),
//                                WaterpurifierString(@"exception.title8", @"龙头通讯异常"),
//                                WaterpurifierString(@"exception.title9", @"纯水流量异常"),
//                                WaterpurifierString(@"exception.title10", @"漏水故障"),
//                                WaterpurifierString(@"exception.title11", @"浮子异常"),
//                                WaterpurifierString(@"exception.title12", @"TDS异常"),
//                                WaterpurifierString(@"exception.title13", @"水温超高故障"),
//                                WaterpurifierString(@"exception.title14", @"回收率异常"),
//                                WaterpurifierString(@"exception.title15", @"出水水质异常"),
//                                WaterpurifierString(@"exception.title16", @"泵热保护"),
//                               //
//                                WaterpurifierString(@"exception.title17", @"PP滤芯寿命到期"),
//                                WaterpurifierString(@"exception.title18", @"前置滤芯寿命到期"),
//                                WaterpurifierString(@"exception.title19", @"RO滤芯寿命到期"),
//                                WaterpurifierString(@"exception.title20", @"后置滤芯寿命到期"),
//                                WaterpurifierString(@"um_string_error23", @"PP滤芯寿命快到期"),
//                                WaterpurifierString(@"um_string_error24", @"前置滤芯寿命快到期"),
//                                WaterpurifierString(@"um_string_error25", @"RO滤芯寿命快到期"),
//                                WaterpurifierString(@"um_string_error26", @"后置滤芯寿命快到期"),
//                                WaterpurifierString(@"exception.title21", @"龙头纯水灯说明"),
//                                WaterpurifierString(@"wash_tips_mainpage", @"%@天没有保养了"),
    //                            nil];
    //    }
    //
    //    if (sNo > 0 && sNo-1 < [exceptionTitles count]) {
    //
    //        return [exceptionTitles objectAtIndex:sNo-1];
    //    }
    
    //zcm add：用switch case模式
    NSString * exceptionTitle = [NSString string];
    
    switch (sNo) {
            
        case MHDeviceWaterpurifierException1:
            exceptionTitle = WaterpurifierString(@"exception.title1", @"水温异常");
            break;
        case MHDeviceWaterpurifierException2:
            exceptionTitle = WaterpurifierString(@"exception.title2", @"进水流量计损坏");
            break;
        case MHDeviceWaterpurifierException3:
            exceptionTitle = WaterpurifierString(@"exception.title3", @"流量传感器异常");
            break;
        case MHDeviceWaterpurifierException4:
            exceptionTitle = WaterpurifierString(@"exception.title4", @"滤芯寿命到期");
            break;
        case MHDeviceWaterpurifierException5:
            exceptionTitle = WaterpurifierString(@"exception.title5", @"Wifi通讯异常");
            break;
        case MHDeviceWaterpurifierException6:
            exceptionTitle = WaterpurifierString(@"exception.title6", @"eeprom通讯异常");
            break;
        case MHDeviceWaterpurifierException7:
            exceptionTitle = WaterpurifierString(@"exception.title7", @"rfid通讯异常");
            break;
        case MHDeviceWaterpurifierException8:
            exceptionTitle = WaterpurifierString(@"exception.title8", @"龙头通讯异常");
            break;
        case MHDeviceWaterpurifierException9:
            exceptionTitle = WaterpurifierString(@"exception.title9", @"纯水流量异常");
            break;
        case MHDeviceWaterpurifierException10:
            exceptionTitle =  WaterpurifierString(@"exception.title10", @"漏水故障");
            break;
        case MHDeviceWaterpurifierException11:
            exceptionTitle =  WaterpurifierString(@"exception.title11", @"浮子异常");
            break;
        case MHDeviceWaterpurifierException12:
            exceptionTitle = WaterpurifierString(@"exception.title12", @"TDS异常");
            break;
        case MHDeviceWaterpurifierException13:
            exceptionTitle = WaterpurifierString(@"exception.title13", @"水温超高故障");
            break;
        case MHDeviceWaterpurifierException14:
            exceptionTitle = WaterpurifierString(@"exception.title14", @"回收率异常");
            break;
        case MHDeviceWaterpurifierException15:
            exceptionTitle = WaterpurifierString(@"exception.title15", @"出水水质异常");
            break;
        case MHDeviceWaterpurifierException16:
            exceptionTitle = WaterpurifierString(@"exception.title16", @"泵热保护");
            break;
            
        case MHDeviceWaterpurifierFilterOneExhausted:
            if ([model isEqualToString:DeviceModelWaterPuriLX5]) {
                exceptionTitle = WaterpurifierString(@"exception.title17.LX5", @"3合1复合滤芯寿命到期");
            }else {
                exceptionTitle = WaterpurifierString(@"exception.title17", @"PP滤芯寿命到期");
            }
            break;
        case MHDeviceWaterpurifierFilterTwoExhausted:
            if([model isEqualToString:DeviceModelWaterPuriLX5]) {
                exceptionTitle = WaterpurifierString(@"exception.title18.LX5", @"RO滤芯寿命到期");
            }else {
                exceptionTitle = WaterpurifierString(@"exception.title18", @"前置滤芯寿命到期");
            }
            break;
        case MHDeviceWaterpurifierFilterThreeExhausted:
            exceptionTitle = WaterpurifierString(@"exception.title19", @"RO滤芯寿命到期");
            break;
        case MHDeviceWaterpurifierFilterFourExhausted:
            exceptionTitle = WaterpurifierString(@"exception.title20", @"后置滤芯寿命到期");
            break;
            
        case MHDeviceWaterpurifierFilterOneExhausteWill:
            if([model isEqualToString:DeviceModelWaterPuriLX5]) {
                exceptionTitle = WaterpurifierString(@"um_string_error23_LX5", @"3合1复合滤芯寿命快到期");
            }else {
                exceptionTitle = WaterpurifierString(@"um_string_error23", @"PP滤芯寿命快到期");
            }
            break;
        case MHDeviceWaterpurifierFilterTwoExhausteWill:
            if([model isEqualToString:DeviceModelWaterPuriLX5]) {
                exceptionTitle =  WaterpurifierString(@"um_string_error24_LX5", @"RO滤芯寿命快到期");
            }else {
                exceptionTitle =  WaterpurifierString(@"um_string_error24", @"前置滤芯寿命快到期");
            }
            break;
        case MHDeviceWaterpurifierFilterThreeExhausteWill:
            exceptionTitle = WaterpurifierString(@"um_string_error25", @"RO滤芯寿命快到期");
            break;
        case MHDeviceWaterpurifierFilterFourExhausteWill:
            exceptionTitle = WaterpurifierString(@"um_string_error26", @"后置滤芯寿命快到期");
            break;
            
        case MHDeviceWaterpurifierTapLEDIntro:
            exceptionTitle = WaterpurifierString(@"exception.title21", @"龙头纯水灯说明");
            break;
        case MHDeviceWaterpurifierWash:
            exceptionTitle = WaterpurifierString(@"wash_tips_mainpage", @"%@天没有保养了");
            break;
        case MHDeviceWaterpurifierRinsing:
            exceptionTitle = WaterpurifierString(@"exception.title22", @"清洗中");
            break;
        default:
            exceptionTitle = [NSString string];
            break;
    }
    
    return exceptionTitle;
}

+ (NSString *)exceptionIntroForSerialNo:(NSInteger)sNo ofDeviceModel:(NSString *)model {
    
    //    static NSArray* exceptionIntros = nil;
    //    if (exceptionIntros == nil) {
    //        exceptionIntros = [NSArray arrayWithObjects:
    //                            WaterpurifierString(@"exception.desc1", @"1.请检查进水温度是否在5~38℃之间，如果不在，请您将水温调整到此范围内后，重新尝试几次开机制纯水，看故障是否消除;\n\n2.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。 "),
    //                            WaterpurifierString(@"exception.desc2", @"1.请您依次拆装几次滤芯后，重新尝试制纯水，看故障是否可消除;\n\n2.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc3", @"1.请按说明书拆掉触控龙头打开自来水水阀，检查水流是否比较小； \n\n2.请按说明书将与水龙头连接的转接头拆掉，看是否有杂质堵塞转接头滤网，将滤网冲洗干净； \n3.请检查您家的水压是否正常，楼顶二次供水、用水高峰期水压也会太低，可以请物业调高水压；\n4.水压低水流就低造成报故障，按以上步骤分别排查后，重新开机制纯水尝试故障是否排除；\n5.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc4", @"1.滤芯寿命建议更换滤芯"),
    //                            WaterpurifierString(@"exception.desc5", @"1.原因可能为WIFI模块损坏或与主板连接异常，请您拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc6", @"1.原因可能为EEPROM芯片损坏或与主板连接异常，请您拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc7", @"rfid通讯异常"),
    //                            WaterpurifierString(@"exception.desc8", @"1.水龙头内部电路板进水可能会引起此故障，请重新接插电源观察龙头指示灯是否点亮，尝试龙头按键操作是否正常;\n\n2. 如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc9", @"1.检查4支滤芯是否安装到位,滤芯是否过期,如果过期需更换滤芯;\n\n2.按说明书拆掉触控龙头打开自来水水阀，检查水流是否比较小； \n\n3.将与水龙头连接的转接头拆掉，看是否有杂质堵塞转接头滤网，将滤网冲洗干净； \n\n4.请检查您家的水压是否过低，楼顶二次供水、用水高峰期水压也会太低，可以请物业调高水压；\n\n5.水压低水流就低造成报故障，按以上步骤分别排查后，重新开机制纯水尝试故障是否排除；\n\n6.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决"),
    //                            WaterpurifierString(@"exception.desc10", @"漏水故障"),
    //                            WaterpurifierString(@"exception.desc11", @"浮子异常"),
    //                            WaterpurifierString(@"exception.desc12", @"1.检查RO滤芯是否过期，如过期请更换滤芯后尝试;\n\n2.进水需为市政自来水，如果不是请更换进水水源后尝试；\n\n3.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc13", @"1.检查进水是否调到温水,水温是否≥40℃，请如果≥40℃，请调节到冷水挡并等水管内水温＜40℃后，再尝试几次制纯水;\n\n2.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决"),
    //                            WaterpurifierString(@"exception.desc14", @"1.检查浓缩水排水管是否弯折、压扁或堵塞,排水是否正常;\n\n2.RO滤芯是否过期,如过期，请更换RO滤芯后尝试；\n\n3.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc15", @"1.检查浓缩水排水管是否弯折、压扁或堵塞,排水是否正常;\n\n2.RO滤芯是否过期,如过期，请更换RO滤芯后尝试；\n\n3.如按照以上步骤排查后故障未消除，请拨打小米客服热线400-100-5678，请专业人员为您排查解决。"),
    //                            WaterpurifierString(@"exception.desc16", @"泵热保护"),
    //                            WaterpurifierString(@"exception.desc17", @"PP棉滤芯寿命到期后如果不及时更换，根据当地水质情况，可能会造成PP棉污堵或者穿透。前者会造成净水器出水流量小，影响使用体验，后者会使前期过滤的污染物又迁移到反渗透膜表面，进而污堵反渗透膜，减少反渗透膜的使用寿命，反而增加使用成本。"),
    //                            WaterpurifierString(@"exception.desc18", @"前置活性炭滤芯到期后如果不及时更换，对自来水中的余氯几乎无吸附作用或者作用变小。余氯透过前置活性炭滤芯到达反渗透膜表面，使反渗透膜氧化损伤，从而使净水器的去除率下降，即净水器对有机物、重金属、细菌等的去除能力下降，进而会影响出水水质。"),
    //                            WaterpurifierString(@"exception.desc19", @"反渗透滤芯为反渗透净水器的核心过滤元件。由于其精密的过滤精度，对水中的水垢、细菌、农药、重金属等污染物有较强的过滤能力。反渗透滤芯寿命到期后如果不及时更换，可能会造成反渗透膜污堵或者处理能力下降。前期会使净水器的纯水流量偏小，影响用户体验，后者会使反渗透膜对污染物的去除能力减小，无法保障出水水质。"),
    //                            WaterpurifierString(@"exception.desc20", @"后置活性炭滤芯到期后如果不及时更换，无法去除水中的小分子有机物、异味等，或者去除能力下降，会造成净水器纯水口感下降，清凉甘甜的感觉也随之消失。另外，还可能会造成净水器的纯水的细菌总数超标。"),
    //                           WaterpurifierString(@"exception.desc17", @"PP棉滤芯寿命到期后如果不及时更换，根据当地水质情况，可能会造成PP棉污堵或者穿透。前者会造成净水器出水流量小，影响使用体验，后者会使前期过滤的污染物又迁移到反渗透膜表面，进而污堵反渗透膜，减少反渗透膜的使用寿命，反而增加使用成本。"),
    //                           WaterpurifierString(@"exception.desc18", @"前置活性炭滤芯到期后如果不及时更换，对自来水中的余氯几乎无吸附作用或者作用变小。余氯透过前置活性炭滤芯到达反渗透膜表面，使反渗透膜氧化损伤，从而使净水器的去除率下降，即净水器对有机物、重金属、细菌等的去除能力下降，进而会影响出水水质。"),
    //                           WaterpurifierString(@"exception.desc19", @"反渗透滤芯为反渗透净水器的核心过滤元件。由于其精密的过滤精度，对水中的水垢、细菌、农药、重金属等污染物有较强的过滤能力。反渗透滤芯寿命到期后如果不及时更换，可能会造成反渗透膜污堵或者处理能力下降。前期会使净水器的纯水流量偏小，影响用户体验，后者会使反渗透膜对污染物的去除能力减小，无法保障出水水质。"),
    //                           WaterpurifierString(@"exception.desc20", @"后置活性炭滤芯到期后如果不及时更换，无法去除水中的小分子有机物、异味等，或者去除能力下降，会造成净水器纯水口感下降，清凉甘甜的感觉也随之消失。另外，还可能会造成净水器的纯水的细菌总数超标。"),
    //                            WaterpurifierString(@"exception.desc21", @"蓝色长亮：正常使用中，表示纯水TDS较低，可放心饮用。\n\n橙色闪烁：制纯水进水温度高于38度 \n\n橙色长亮:\n（1）表示纯水TDS较高，机器进入冲洗状态，继续制纯水至指示灯变蓝色即可;\n（2）同时主机指示灯和顶部滤芯寿命指示灯也橙色长亮，表示滤芯寿命已到"), nil];
    //    }
    //
    //    if (sNo > 0 && sNo-1 < [exceptionIntros count]) {
    //        return [exceptionIntros objectAtIndex:sNo-1];
    //    }
    
    //zcm 修改：使用switch case模式
    NSString *exceptionIntro = [NSString string];
    
    switch (sNo) {
            
        case MHDeviceWaterpurifierException1:
            exceptionIntro = WaterpurifierString(@"exception.desc1", @"水温异常，故障排除方法描述");
            break;
        case MHDeviceWaterpurifierException2:
            exceptionIntro = WaterpurifierString(@"exception.desc2", @"进水流量异常，故障排除方法描述");
            break;
        case MHDeviceWaterpurifierException3:
            exceptionIntro = WaterpurifierString(@"exception.desc3", @"流量传感器异常，故障排除方法描述");
            break;
        case MHDeviceWaterpurifierException4:
            exceptionIntro = WaterpurifierString(@"exception.desc4", @"滤芯寿命建议更换滤芯");
            break;
        case MHDeviceWaterpurifierException5:
            exceptionIntro = WaterpurifierString(@"exception.desc5", @"WIFI异常，故障排除方法描述");
            break;
        case MHDeviceWaterpurifierException6:
            exceptionIntro = WaterpurifierString(@"exception.desc6", @"eeprom通讯异常，故障排除方法");
            break;
        case MHDeviceWaterpurifierException7:
            exceptionIntro =  WaterpurifierString(@"exception.desc7", @"rfid通讯异常");
            break;
        case MHDeviceWaterpurifierException8:
            exceptionIntro = WaterpurifierString(@"exception.desc8", @"龙头通讯异常，排除方法描述");
            break;
        case MHDeviceWaterpurifierException9:
            exceptionIntro = WaterpurifierString(@"exception.desc9", @"纯水流量异常，故障排除方法描述");
            break;
        case MHDeviceWaterpurifierException10:
            exceptionIntro =   WaterpurifierString(@"exception.desc10", @"漏水故障");
            break;
        case MHDeviceWaterpurifierException11:
            exceptionIntro =   WaterpurifierString(@"exception.desc11", @"浮子异常");
            break;
        case MHDeviceWaterpurifierException12:
            exceptionIntro = WaterpurifierString(@"exception.desc12", @"TDS异常故障，排除方法描述");
            break;
        case MHDeviceWaterpurifierException13:
            exceptionIntro =  WaterpurifierString(@"exception.desc13", @"水温超高故障，排除方法描述");
            break;
        case MHDeviceWaterpurifierException14:
            exceptionIntro = WaterpurifierString(@"exception.desc14", @"回收率异常，排除方法描述");
            break;
        case MHDeviceWaterpurifierException15:
            exceptionIntro = WaterpurifierString(@"exception.desc15", @"出水水质异常，排除方法描述");
            break;
        case MHDeviceWaterpurifierException16:
            exceptionIntro = WaterpurifierString(@"exception.desc16", @"泵热保护");
            break;
            
        case MHDeviceWaterpurifierFilterOneExhausted:
            if([model isEqualToString:DeviceModelWaterPuriLX5]) {
                exceptionIntro = WaterpurifierString(@"exception.desc17.LX5", @"3合1滤芯到期危害描述");
            }else {
                exceptionIntro = WaterpurifierString(@"exception.desc17", @"PP棉滤芯寿命到期后危害描述");
            }
            break;
        case MHDeviceWaterpurifierFilterTwoExhausted:
            if([model isEqualToString:DeviceModelWaterPuriLX5]){
                exceptionIntro = WaterpurifierString(@"exception.desc18.LX5", @"前置活性炭滤芯到期危害描述");
            }else {
                exceptionIntro = WaterpurifierString(@"exception.desc18", @"前置活性炭滤芯到期危害描述");
            }
            break;
        case MHDeviceWaterpurifierFilterThreeExhausted:
            exceptionIntro = WaterpurifierString(@"exception.desc19", @"反渗透滤芯到期危害描述");
            break;
        case MHDeviceWaterpurifierFilterFourExhausted:
            exceptionIntro = WaterpurifierString(@"exception.desc20", @"后置活性炭滤芯到期危害描述");
            break;
            
        case MHDeviceWaterpurifierFilterOneExhausteWill:
            if([model isEqualToString:DeviceModelWaterPuriLX5]) {
                exceptionIntro = WaterpurifierString(@"exception.desc17.LX5", @"3合1滤芯到期危害描述");
            }else {
                exceptionIntro = WaterpurifierString(@"exception.desc17", @"PP棉滤芯寿命到期后危害描述");
            }
            break;
        case MHDeviceWaterpurifierFilterTwoExhausteWill:
            if([model isEqualToString:DeviceModelWaterPuriLX5]){
                exceptionIntro = WaterpurifierString(@"exception.desc18.LX5", @"前置活性炭滤芯到期危害描述");
            }else {
                exceptionIntro = WaterpurifierString(@"exception.desc18", @"前置活性炭滤芯到期危害描述");
            }
            break;
        case MHDeviceWaterpurifierFilterThreeExhausteWill:
            exceptionIntro = WaterpurifierString(@"exception.desc19", @"反渗透滤芯到期危害描述");
            break;
        case MHDeviceWaterpurifierFilterFourExhausteWill:
            exceptionIntro = WaterpurifierString(@"exception.desc20", @"后置活性炭滤芯到期危害描述");
            break;
            
        case MHDeviceWaterpurifierTapLEDIntro:
            exceptionIntro = WaterpurifierString(@"exception.desc21", @"龙头纯水灯描述");
            break;
        case  MHDeviceWaterpurifierRinsing:
            exceptionIntro = WaterpurifierString(@"exception.desc22", @"清洗中介绍");
            break;
        default:
            exceptionIntro = [NSString string];
            break;
    }
    
    return exceptionIntro;
}

- (UIImage *)exceptionImageForSerialNo:(NSInteger)sNo {
    UIImage* exceptionImage = nil;
    
    BOOL isWaterPuriLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
    
    if (sNo > 0 && sNo < MHDeviceWaterpurifierFilterOneExhausted) {
        
//        exceptionImage = [UIImage imageNamed:@"waterpurifier_exception_warning"];
        
        exceptionImage = isWaterPuriLX5 ?
                        [UIImage imageNamed:@"waterpurifierLX5_exception_warning"] : //米二代 提醒
                        [UIImage imageNamed:@"waterpurifier_exception_warning"];     //米一代 提醒
    }
    else if (sNo == MHDeviceWaterpurifierFilterOneExhausted || sNo == MHDeviceWaterpurifierFilterOneExhausteWill) {
        
//        exceptionImage = [UIImage imageNamed:@"waterpurifier_filter1_exhausted"];
        
        exceptionImage = isWaterPuriLX5 ?
                        [UIImage imageNamed:@"waterpurifierLX5_filter1_exhausted"] :  //米二代 滤芯1到期
                        [UIImage imageNamed:@"waterpurifier_filter1_exhausted"] ;  //米一代 滤芯1到期
    }
    else if (sNo == MHDeviceWaterpurifierFilterTwoExhausted || sNo == MHDeviceWaterpurifierFilterTwoExhausteWill) {
        
//        exceptionImage = [UIImage imageNamed:@"waterpurifier_filter2_exhausted"];
        
        exceptionImage = isWaterPuriLX5 ?
                        [UIImage imageNamed:@"waterpurifierLX5_filter2_exhausted"] :  //米二代 滤芯2到期
                        [UIImage imageNamed:@"waterpurifier_filter2_exhausted"] ;  //米一代 滤芯2到期
    }
    else if (sNo == MHDeviceWaterpurifierFilterThreeExhausted || sNo == MHDeviceWaterpurifierFilterThreeExhausteWill) { //滤芯3过期
        exceptionImage = [UIImage imageNamed:@"waterpurifier_filter3_exhausted"];
    }
    else if (sNo == MHDeviceWaterpurifierFilterFourExhausted || sNo == MHDeviceWaterpurifierFilterFourExhausteWill) { //滤芯4过期
        exceptionImage = [UIImage imageNamed:@"waterpurifier_filter4_exhausted"];
    }
    else if (sNo == MHDeviceWaterpurifierTapLEDIntro) { //龙头指示灯提醒
//        if ([self.device.model isEqualToString:@"yunmi.waterpurifier.v2"]) {
//            exceptionImage = [UIImage imageNamed:@"waterpurifier_tap_led_v2"];
//        } else if ([self.device.model isEqualToString:@"yunmi.waterpurifier.v3"]) {
//            exceptionImage = [UIImage imageNamed:@"waterpurifier_tap_led_v3"];
//        } else {
//            if(mhwate )
//            exceptionImage = [UIImage imageNamed:@"waterpurifier_tap_led_v2"];
//        }
        
        //zcm 修改更具厨上 厨下来判断
        if([MHWaterpurifierDeviceHelp isOnDevice:self.device.model]) {
            exceptionImage = [UIImage imageNamed:@"waterpurifier_tap_led_v2"];
        }else {
            exceptionImage = [UIImage imageNamed:@"waterpurifier_tap_led_v3"];
        }
    }
    else {
        exceptionImage = [UIImage imageNamed:@"waterpurifier_exception_warning"];
    }
    return exceptionImage;
}

@end
