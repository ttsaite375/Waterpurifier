//
//  MHWaterpurifierViewController.m
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

//Controllers
#import "MHWebViewController.h"
#import "MHWashViewController.h"
#import "MHDeviceSettingViewController.h"
#import "MHWaterpurifierViewController.h"
#import "MHWaterpurifierTDSViewController.h"

#import "MHWaterDeviceOffLineViewController.h"
#import "MHWaterpurifierExceptionViewController.h"
#import "MHWaterpurifierFilterStatusViewController.h"

//Views
#import "MHTdsWaveContainer.h"
#import "MHDeviceWaterpurifier.h"
#import "MHWaterFilterStatusView.h"
#import "MHWaterPurifyStatisticView.h"
#import "YMNumberPickerView.h"
#import "MBProgressHUD.h"

//Ohters
#import "MHPromptKit.h"
#import "MHLocalizedTool.h"
#import "MHWaterpurifierDefine.h"
#import "MHWaterpurifierDeviceHelp.h"

//define
#define kOrangeValueKey @"kOrangeValueKey"
#define kUrlForInstallTips @"https://viomi-faq.mi-ae.com.cn/misetup/index.html"
#define kUrlForUsageTips   @"https://viomi-faq.mi-ae.com.cn/faqs/watercleaner.html"
//#define kUrlForInstallTips @"http://viomi-api.mi-ae.com.cn/static/doc/manual/mini.html"
//#define kUrlForUsageTips   @"http://viomi-api.mi-ae.com.cn/static/doc/science_pop/mini.html"

@interface MHWaterpurifierViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) MHDeviceWaterpurifier* device;

@property (nonatomic, assign) BOOL deviceOnline;

@end

@implementation MHWaterpurifierViewController
{
    BOOL _shouldShowUpArrow;                            //是否要显示上拉箭头
    CGFloat _tdsContainerInsetBottom;                   //TDS容器UIEdgeInsets.bottom
    
    UIView* _scrollContainer;
    
    UIScrollView* _scrollView;
    
    MHTdsWaveContainer* _tdsContainer;                  //TDS值
    
    MHWaterFilterStatusView* _filterStatus;             //滤芯状态
    
    MHWaterPurifyStatisticView* _purifyStatistics;      //净水统计
}

- (instancetype)initWithDevice:(MHDevice *)device {
    self = [super initWithDevice:device];
    if (self) {
        self.isHasSetting = YES;
    }
    return self;
}

+ (NSInteger)getResourcePluginAssetLevel{
    return 2;                                           //该数值需与packageInfo.json 中的 asset_level 值相同
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldShowUpArrow = YES;                           // zcm 默认显示向上箭头
    
    self.isNavBarTranslucent = YES;
    
    [self.device getExcNotifySetting];                  //获取异常提醒设置
    
    UIPanGestureRecognizer* panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [self.view addGestureRecognizer:panGR];
    
    //获取净水记录，并取第一条记录的tds值
    //lsl tds 不从这里取～ 2017-1-13
//    XM_WS(weakself);
//    [self.device getOncePurifyRecordsForTime:[NSDate date] completion:^(NSArray *records) {
//        if ([records count] > 0) {
//            MHDataWaterPurifyRecord* record = [records objectAtIndex:0];
//            weakself.device.tTds = record.inTDS;
//            weakself.device.pTds = record.outTDS;
//            
////            double sum = 0;
////            for (MHDataWaterPurifyRecord* r in records) {
////                NSLog(@"tds:%d",r.inTDS);
////                sum += r.inTDS;
////            }
////            NSLog(@"tds 111:%f",sum/records.count);
//        }
//    }];
}

/** zcm
    @bug描述：当push到了另一个Controller，然后再次返回时会出现“不管_tdsContainer是否展开都会有 “↑” 箭头”
    @bug修改：_tdsContainer 的 “↑” 箭头将始终依据 _shouldShowUpArrow 来判断行为。
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tdsContainer startWaveAnimation];
    
    //    [_tdsContainer startUpIndicatorAnimation];
    
    if(_shouldShowUpArrow) {
        
       [_tdsContainer startUpIndicatorAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_tdsContainer stopWaveAnimation];
    
//    [_tdsContainer stopUpIndicatorAnimation];
    
    if(_shouldShowUpArrow) {
        
        [_tdsContainer stopUpIndicatorAnimation];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)buildSubviews {
    [super buildSubviews];
    
    XM_WS(weakself);
    _tdsContainer = [MHTdsWaveContainer new];
    _tdsContainer.device = self.device;
    _tdsContainer.digitalScale = 1;
    _tdsContainer.tdsDetailHandler = ^{
        MHWaterpurifierTDSViewController* tdsVC = [MHWaterpurifierTDSViewController new];
        tdsVC.waterpurifier = weakself.device;
        [weakself.navigationController pushViewController:tdsVC animated:YES];
    };
    _tdsContainer.exceptionHandler = ^{
        [weakself onShowExceptions];
    };

    [self.view addSubview:_tdsContainer];
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [MHColorUtils colorWithRGB:0x7a98b3];//[MHColorUtils colorWithRGB:0x00caed];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollContainer = [UIView new];
    [_scrollView addSubview:_scrollContainer];
    
    if (@available(iOS 11.0, *)){
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _filterStatus = [MHWaterFilterStatusView new];
    _filterStatus.device = self.device;
    _filterStatus.filterSelectedHandler = ^(MHWaterFilterObject *object) {
        XM_SS(ss, weakself);
        MHWaterpurifierFilterStatusViewController* filterVC = [MHWaterpurifierFilterStatusViewController new];
        filterVC.filterObject = object;
        filterVC.deviceModel = ss.device.model;
        [weakself.navigationController pushViewController:filterVC animated:YES];
    };
    [_scrollContainer addSubview:_filterStatus];
    
    _purifyStatistics = [MHWaterPurifyStatisticView new];
    _purifyStatistics.device = self.device;
    [_purifyStatistics refreshPurifyStatisticData];
    [_scrollContainer addSubview:_purifyStatistics];
}

- (void)buildConstraints {
    [super buildConstraints];
    
    XM_WS(ws);
    if (_tdsContainerInsetBottom == 0) {
        [_tdsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.view);
        }];
    }
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.top.equalTo(ss->_tdsContainer.mas_bottom);
        make.left.right.bottom.equalTo(ws.view);
    }];
    
    [_scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.edges.equalTo(ss->_scrollView);
        make.width.equalTo(ss->_scrollView);
    }];
    
    [_filterStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.top.equalTo(ss->_scrollContainer);
        make.left.right.equalTo(ss->_scrollContainer);
    }];
    
    [_purifyStatistics mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.top.equalTo(ss->_filterStatus.mas_bottom);
        make.left.right.equalTo(ss->_scrollContainer);
    }];
    
    [_scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.bottom.equalTo(ss->_purifyStatistics.mas_bottom);
    }];
    
}

- (void)onShowExceptions {
    
    if (self.deviceOnline) {
        if ([self.device.exceptions count] == 1) {
            NSArray* excNos = [self.device.exceptions allKeys];
            MHDeviceWaterpurifierExceptionType type = [[excNos objectAtIndex:0] integerValue];
            if (type == MHDeviceWaterpurifierWash) {
                NSNumber *days = [self.device.exceptions objectForKey:@(MHDeviceWaterpurifierWash)];
                MHWashViewController *controller = [[MHWashViewController alloc] init];
                controller.days = days;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                MHWaterpurifierExceptionViewController* exceptionVC = [MHWaterpurifierExceptionViewController new];
                exceptionVC.device = self.device;
                NSArray* allKeys = [self.device.exceptions allKeys];
                if ([allKeys count]) {
                    exceptionVC.exceptionSerialNo = [[allKeys objectAtIndex:0] integerValue];
                }
                [self.navigationController pushViewController:exceptionVC animated:YES];
            }
        }
        else if ([self.device.exceptions count] > 1) {
            __block NSMutableArray* excTitles = [NSMutableArray array];
            NSArray* excNos = [self.device.exceptions allKeys];
            [excNos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSInteger excNo = [obj integerValue];
                NSString *title = @"";
                if (excNo == MHDeviceWaterpurifierWash) {
                    NSNumber *days = [self.device.exceptions objectForKey:@(MHDeviceWaterpurifierWash)];
//                    title = [NSString stringWithFormat:[MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:excNo],days];
                    
                    //zcm 修改了MHWaterpurifierExceptionViewController类方法，添加model
                    title = [NSString stringWithFormat:[MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:excNo ofDeviceModel:self.device.model],days];
                }else{
//                    title = [MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:excNo];
                    title = [MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:excNo ofDeviceModel:self.device.model];
                }
                [excTitles addObject:title];
            }];
            XM_WS(ws);
            [[MHPromptKit shareInstance] showPromptInView:self.view withHandler:^(NSInteger index) {
                if (index == 0) { //取消
                    return;
                }
                MHDeviceWaterpurifierExceptionType type = [[excNos objectAtIndex:index-1] integerValue];
                if (type == MHDeviceWaterpurifierWash) {
                    NSNumber *days = [self.device.exceptions objectForKey:@(MHDeviceWaterpurifierWash)];
                    MHWashViewController *controller = [[MHWashViewController alloc] init];
                    controller.days = days;
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    MHWaterpurifierExceptionViewController* exceptionVC = [MHWaterpurifierExceptionViewController new];
                    exceptionVC.device = ws.device;
                    exceptionVC.exceptionSerialNo = type;
                    [ws.navigationController pushViewController:exceptionVC animated:YES];
                }
            } withTitle:WaterpurifierString(@"um_string_problem_process", @"问题处理") cancelButtonTitle:WaterpurifierString(@"cancel", @"取消") destructiveButtonTitle:nil otherButtonTitlesArray:excTitles];
        }
    }else{
        MHWaterDeviceOffLineViewController *controller = [[MHWaterDeviceOffLineViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)onGetStatusSucceed:(id)response {
    NSLog(@"onGetStatusSucceed");
    
    self.deviceOnline = YES;
    [self fillValue];
}

- (void)onGetStatusFailed:(NSError*)error
{
    NSLog(@"onGetStatusFailed");
    //获取设备数据失败，取上一次缓存数据
    self.deviceOnline = NO;
    
    NSString *deviceId = self.device.did;
    NSString *statuskey = [NSString stringWithFormat:@"ym_filterStatus_%@",deviceId];
    NSArray *statusList = [[NSUserDefaults standardUserDefaults] objectForKey:statuskey];
    [self.device changeStatus:statusList];
    
    [self fillValue];
}



- (void)fillValue {
    
    [_filterStatus reloadFilterStatus:self.deviceOnline];
    
    [_tdsContainer reloadTdsValue:self.deviceOnline];
    
    /** zcm
     @bug描述：波浪颜色只根据TDS变化，滤芯状态Table却依据TDS、是否online变化。将造成两部分颜色不同。
     @bug修改：去掉设备在线的判断，背景色的变化只依据TDS。
     */
    
    NSInteger criticalValue = [self.device.model isEqualToString:DeviceModelWaterPuriLX5] ? self.device.tdsWarnVal : 200;
    
    if (self.device.pTds <= criticalValue ) {
        [UIView animateWithDuration:2.5 animations:^{
            
            self->_scrollView.backgroundColor = [MHColorUtils colorWithRGB:0x00caed];
        }];
    } else {
        
        _scrollView.backgroundColor = [MHColorUtils colorWithRGB:0x7a98b3];
    }
    
    //    if (self.deviceOnline) {
    //        if (self.device.pTds < 100) {
    //            [UIView animateWithDuration:2.5 animations:^{
    //                _scrollView.backgroundColor = [MHColorUtils colorWithRGB:0x00caed];
    //            }];
    //        } else {
    //            _scrollView.backgroundColor = [MHColorUtils colorWithRGB:0x7a98b3];
    //        }
    //    }else{
    //        _scrollView.backgroundColor = [MHColorUtils colorWithRGB:0x7a98b3];
    //    }
}

//zcm add自定义设置页
- (NSArray<MHDeviceSettingItem *> *)customSettingItems
{

    NSArray<MHDeviceSettingItem *> *defaultSeetingItems = [super customSettingItems];
    
    if(![self.device.model isEqualToString:DeviceModelWaterPuriLX5]) {
        return defaultSeetingItems;
    }
    
    NSMutableArray<MHDeviceSettingItem *> *customSettingItems = defaultSeetingItems ? [NSMutableArray arrayWithArray:defaultSeetingItems] : [NSMutableArray array];
    
    //处理一下数据
    NSUInteger minValue = self.device.tdsOutAvg - 50;
    NSUInteger maxValue = self.device.tdsOutAvg + 50;
    NSInteger orangeValue = self.device.tdsWarnVal;
    
    //如果不在这个范围内 warn < avg - 50  就按照 [warn, avg + 50]这个范围，
    if(orangeValue < minValue ) {
        minValue = orangeValue;
    }
    
    if(orangeValue > maxValue + 50) {
        maxValue = orangeValue;
    }
    
    MHDeviceSettingItem *orangeValueItem = [[MHDeviceSettingItem alloc] init];
    
    orangeValueItem.caption = WaterpurifierString(@"mydevice.orange.value", @"龙头灯橙色阈值");
    
    orangeValueItem.comment = @(orangeValue).stringValue;
    
    orangeValueItem.type = MHDeviceSettingItemTypeStandard;
    
    XM_WS(ws);
    
    orangeValueItem.callbackBlock = ^(MHDeviceSettingCell *cell) {
    
        YMNumberPickerView *pickerView = [[YMNumberPickerView alloc] init];
        
        pickerView.minValue = minValue;
        pickerView.maxValue = maxValue;
        pickerView.interval = 1;
        pickerView.defaultValue = orangeValue;
        pickerView.title = WaterpurifierString(@"mydevice.orange.tips", @"龙头灯显示为橙色的最低TDS值");
        pickerView.didPickNumber = ^(NSInteger value) {
            
            ws.device.tdsWarnVal = value;  //立即显示，随后post设置到服务器
            
            [ws.device postTdsWarningOrangeValue:value completion:^(BOOL succeed) {
                
                if(!succeed) {
                    
                    ws.device.tdsWarnVal = orangeValue;
                    [ws reloadDeviceSetting];
                }else {
                    [ws fillValue];  //重置值
                }
            }];
            
            [ws reloadDeviceSetting];
        };
        
        [pickerView show];
    };
    
    [customSettingItems addObject:orangeValueItem];
    
    return customSettingItems;
}


- (void)onSetting {
    
    XM_WS(ws);
    
    NSString *language = [[MHLocalizedTool shareInstance] appCurrentLanguage];
    if (!language) {
        language = @"zh-Hans";
    }
    
    MHDeviceSettingGroup* group = [MHDeviceSettingGroup new];
    
    group.items = [NSMutableArray array];
    
    //1. 厨上版才有净水器安装贴士
    if([MHWaterpurifierDeviceHelp isOnDevice:self.device.model]) {
        MHDeviceSettingItem *installTip = [MHDeviceSettingItem new];
        installTip.type = MHDeviceSettingItemTypeDefault;
        installTip.caption = WaterpurifierString(@"install.tips", @"安装贴士");
        installTip.callbackBlock = ^(MHDeviceSettingCell *cell) {
            
            MHWebViewController* webVC = [MHWebViewController new];
            webVC.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?language=%@",kUrlForInstallTips,language]];
            [ws.navigationController pushViewController:webVC animated:YES];
        };
        
        [group.items addObject:installTip];
    }
    
    //2. 滤芯安装贴士
    MHDeviceSettingItem *filterInstallTip = [MHDeviceSettingItem new];
    filterInstallTip.type = MHDeviceSettingItemTypeDefault;
    filterInstallTip.caption = WaterpurifierString(@"filtrt.usage.tips", @"滤芯安装贴士");
    filterInstallTip.callbackBlock = ^(MHDeviceSettingCell *cell) {
      
        NSString *filterInstallTipsUrl;
        
        if([MHWaterpurifierDeviceHelp isOnDevice:self.device.model]) {
            //厨上
             filterInstallTipsUrl = [NSString stringWithFormat:@"https://viomi-faq.mi-ae.net/misetup/filtersetup.html?language=%@",language];
        }else if([self.device.model isEqualToString:DeviceModelWaterPuriLX5]){
           //厨下二代
            filterInstallTipsUrl = @"https://viomi-resource.mi-ae.net/filtersetup.html?type=mi2&lang=zh-Hans";
        }else {
            //厨下一代
            filterInstallTipsUrl = [NSString stringWithFormat:@"https://viomi-faq.mi-ae.net/misetup/filtersetup_under.html?language=%@",language];
        }
        MHWebViewController* webVC = [MHWebViewController new];
        webVC.URL = [NSURL URLWithString:filterInstallTipsUrl];
        [ws.navigationController pushViewController:webVC animated:YES];
    };
    
    [group.items addObject:filterInstallTip];
    
    //使用贴士取消，换成米家后台配置
    
    
//    MHDeviceSettingItem* tips = [MHDeviceSettingItem new];
//    tips.type = MHDeviceSettingItemTypeDefault;
//    tips.caption = WaterpurifierString(@"helps", @"使用帮助");
//    tips.callbackBlock = ^(MHDeviceSettingCell *cell) {
//
//        MHDeviceSettingGroup* tipsGroup = [MHDeviceSettingGroup new];
//
//        tipsGroup.title = group.title;
//
//        tipsGroup.items = [NSMutableArray array];
//
//        //if ([self.device.model isEqualToString:@"yunmi.waterpurifier.v2"]) {
//        if ([MHWaterpurifierDeviceHelp isOnDevice:self.device.model]) {
//            MHDeviceSettingItem* installTips = [MHDeviceSettingItem new];
//            installTips.type = MHDeviceSettingItemTypeDefault;
//            installTips.caption = WaterpurifierString(@"install.tips", @"安装贴士");
//            installTips.callbackBlock = ^(MHDeviceSettingCell *cell) {
//                MHWebViewController* webVC = [MHWebViewController new];
//                webVC.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?language=%@",kUrlForInstallTips,language]];
//                //
//                [ws.navigationController pushViewController:webVC animated:YES];
//            };
//            [tipsGroup.items addObject:installTips];
//        }
//
//        MHDeviceSettingItem* filterInstallTips = [MHDeviceSettingItem new];
//        filterInstallTips.type = MHDeviceSettingItemTypeDefault;
//        filterInstallTips.caption = WaterpurifierString(@"filtrt.usage.tips", @"滤芯安装贴士");
//        filterInstallTips.callbackBlock = ^(MHDeviceSettingCell *cell) {
//
//            //NSLog(@"langusge:%@",[[MHLocalizedTool shareInstance] appCurrentLanguage]);
//
//            NSString *filterInstallTipsUrl = @"";
//            if ([MHWaterpurifierDeviceHelp isOnDevice:self.device.model]) {
//                filterInstallTipsUrl = [NSString stringWithFormat:@"http://viomi-faq.mi-ae.net/misetup/filtersetup.html?language=%@",language];
//            }else{
//
//                //zcm 添加 米二代滤芯安装贴士 只有中文
//                if([self.device.model isEqualToString:DeviceModelWaterPuriLX5]) {
//
//                    filterInstallTipsUrl = @"http://viomi-resource.mi-ae.net/filtersetup.html?type=mi2&lang=zh-Hans";
//                }else {
//                    filterInstallTipsUrl = [NSString stringWithFormat:@"http://viomi-faq.mi-ae.net/misetup/filtersetup_under.html?language=%@",language];
//                }
//
////                filterInstallTipsUrl = [NSString stringWithFormat:@"http://viomi-faq.mi-ae.net/misetup/filtersetup_under.html?language=%@",language];
//            }
//            MHWebViewController* webVC = [MHWebViewController new];
////            webVC.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?language=%@",kUrlForUsageTips,language]];
//            //
//            //zcm 修改 之前的根本没用到 filterInstallTipsUrl ？
//            webVC.URL = [NSURL URLWithString:filterInstallTipsUrl];
//            [ws.navigationController pushViewController:webVC animated:YES];
//        };
//        [tipsGroup.items addObject:filterInstallTips];
//
//        MHDeviceSettingItem* usage = [MHDeviceSettingItem new];
//        usage.type = MHDeviceSettingItemTypeDefault;
//        usage.caption = WaterpurifierString(@"usage.tips", @"使用贴士");
//        usage.callbackBlock = ^(MHDeviceSettingCell *cell) {
//            MHWebViewController* webVC = [MHWebViewController new];
//            webVC.URL = [NSURL URLWithString:kUrlForUsageTips];
//            [ws.navigationController pushViewController:webVC animated:YES];
//        };
//        [tipsGroup.items addObject:usage];
//
//        MHDeviceSettingViewController* tipsVC = [MHDeviceSettingViewController new];
//        tipsVC.settingGroups = @[tipsGroup];
//        [ws.navigationController pushViewController:tipsVC animated:YES];
//    };
//    [group.items addObject:tips];
    
    /*
    MHDeviceSettingItem* reminder = [MHDeviceSettingItem new];
    reminder.type = MHDeviceSettingItemTypeDefault;
    reminder.caption = @"提醒";
    reminder.callbackBlock = ^(MHDeviceSettingCell *cell) {
        MHDeviceSettingGroup* reminderGroup = [MHDeviceSettingGroup new];
        reminderGroup.items = [NSMutableArray array];
        
        MHDeviceSettingItem* runException = [MHDeviceSettingItem new];
        runException.type = MHDeviceSettingItemTypeSwitch;
        runException.caption = @"运行异常提醒";
        runException.comment = @"当发现净水器运行异常时，将通知提醒您";
        runException.isOn = ws.device.runExceptionNotifyEnabled;
        runException.callbackBlock = ^(MHDeviceSettingCell *cell) {
            ws.device.runExceptionNotifyEnabled = cell.item.isOn;
            [ws.device syncExcNotifySetting:^(BOOL result) {
                if (!result) {
                    cell.item.isOn = !cell.item.isOn;
                    [cell fillWithItem:cell.item];
                }
                [cell finish];
            }];
        };
        [reminderGroup.items addObject:runException];
        
        MHDeviceSettingItem* tdsException = [MHDeviceSettingItem new];
        tdsException.type = MHDeviceSettingItemTypeSwitch;
        tdsException.caption = @"水质异常提醒";
        tdsException.comment = @"当发现所处地区水质异常时，将通知提醒您";
        tdsException.isOn = ws.device.tdsExceptionNotifyEnabled;
        tdsException.callbackBlock = ^(MHDeviceSettingCell *cell) {
            ws.device.tdsExceptionNotifyEnabled = cell.item.isOn;
            [ws.device syncExcNotifySetting:^(BOOL result) {
                if (!result) {
                    cell.item.isOn = !cell.item.isOn;
                    [cell fillWithItem:cell.item];
                }
                [cell finish];
            }];
        };
        [reminderGroup.items addObject:tdsException];
        
        MHDeviceSettingViewController* settings = [MHDeviceSettingViewController new];
        settings.settingGroups = @[reminderGroup];
        [ws.navigationController pushViewController:settings animated:YES];
    };
    [group.items addObject:reminder];
    */
    
    MHDeviceSettingViewController* settings = [MHDeviceSettingViewController new];
    settings.settingGroups = @[group];
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll:%f", scrollView.contentOffset.y);
    
    // 下拉scrollView时并且offset.y <= -70之后，将tdsContainer复位
    if (scrollView.contentOffset.y <= -70.0) {
        XM_WS(weakself);
        _tdsContainerInsetBottom = 0;
        [_tdsContainer stopWaveAnimation];
        [UIView animateWithDuration:0.5 animations:^{
            XM_SS(strongself, weakself);
            [strongself->_tdsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakself.view);
            }];
            strongself->_tdsContainer.digitalScale = 1.0;
            [weakself.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            XM_SS(strongself, weakself);
            [strongself->_tdsContainer startWaveAnimation];
            
            [strongself->_tdsContainer startUpIndicatorAnimation];
        }];
    }
}


#pragma mark - UIGestureRecognizer

- (void)handlePanGesture:(UIPanGestureRecognizer*)panRecognizer
{
    NSLog(@"[translationInView]%@ state:%d", NSStringFromCGPoint([panRecognizer translationInView:self.view]), (int)panRecognizer.state);
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        _tdsContainerInsetBottom = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_tdsContainer.frame);
        
        [_tdsContainer stopWaveAnimation];
        [_tdsContainer stopUpIndicatorAnimation];
    }
    else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat deltaY = [panRecognizer translationInView:self.view].y; // < 0 when pan up; > 0 when pan down
        CGFloat maxInsetBottom = CGRectGetHeight([UIScreen mainScreen].bounds) * 0.6;
        CGFloat insetBottom = _tdsContainerInsetBottom - deltaY;
        if (insetBottom < 0) {
            insetBottom = 0;
        } else if (insetBottom > maxInsetBottom) {
            insetBottom = maxInsetBottom;
        }
        [_tdsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, insetBottom, 0));
        }];
        _tdsContainer.digitalScale = (maxInsetBottom - insetBottom) / maxInsetBottom;
    }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat insetBottom = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_tdsContainer.frame);
        CGFloat maxInsetBottom = CGRectGetHeight([UIScreen mainScreen].bounds) * 0.6;
        if (insetBottom >= maxInsetBottom * 0.5) { //超过一半后推上去
            insetBottom = maxInsetBottom;
            _shouldShowUpArrow = NO;
        } else { //没超过一半拉回来
            insetBottom = 0;
            _shouldShowUpArrow = YES;
        }
        _tdsContainerInsetBottom = insetBottom;
        
        XM_WS(weakself);
        [UIView animateWithDuration:0.5 animations:^{
            XM_SS(strongself, weakself);
            [strongself->_tdsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, insetBottom, 0));
            }];
            strongself->_tdsContainer.digitalScale = (maxInsetBottom - insetBottom) / maxInsetBottom;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            XM_SS(strongself, weakself);
            [strongself->_tdsContainer startWaveAnimation];
            if (strongself->_shouldShowUpArrow) {
                [strongself->_tdsContainer startUpIndicatorAnimation];
            }else {
                [strongself->_tdsContainer stopUpIndicatorAnimation];
            }
        }];
    }
}

#pragma mark - save value
//zcm add: 读取和保存用户设置阈值
//- (NSInteger )readOrangeValueFromLocal
//{
//    NSString *key = [NSString stringWithFormat:@"%@_%@",self.device.did,kOrangeValueKey];
//
//    NSNumber *orangeValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//
//    return orangeValue == nil || orangeValue.integerValue < 0 ? 200 : orangeValue.integerValue;
//}
//
//- (void)writeOrangeValueToLocal:(NSInteger )orangeValue
//{
//    NSString *key = [NSString stringWithFormat:@"%@_%@",self.device.did,kOrangeValueKey];
//
//    [[NSUserDefaults standardUserDefaults] setValue:@(orangeValue) forKey:key];
//
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

@end
