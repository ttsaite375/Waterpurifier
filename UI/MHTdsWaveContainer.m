//
//  MHTdsWaveContainer.m
//  MiHome
//
//  Created by wayne on 15/7/8.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHTdsWaveContainer.h"
#import "MHTdsDigitalView.h"
#import "MHWaterWaveView.h"
#import "MHSerialAnimation.h"
#import <MiHomeInternal/MHTicker.h>
#import "YMScreenAdapter.h"
#import "MHWaterpurifierDeviceHelp.h"
#import "MHWaterpurifierDefine.h"
#import "MHWaterpurifierExceptionViewController.h"

//TODO: use EaseInAndOut animation for Digital flip
CGFloat exponentialEaseInAndOut(CGFloat t)
{
    if (t == 0) {
        return 0;
    }
    if (t == 1) {
        return 1;
    }
    
    t *= 2;
    if (t < 1) {
        return 0.5f * (float) pow(2, 10 * (t - 1));
    }
    
    --t;
    return 0.5f * (float) (-pow(2, -10 * t) + 2);
}

@implementation MHTdsWaveContainer
{
    UILabel* _inSubheadLabel;           //自来水TDS or 水温
    
    MHTdsDigitalView* _tdsDigital;  //过滤后纯水TDS
    UILabel* _offLineLabel;
    //UIButton *_washBtn;
    UIButton* _exceptionBtn;        //异常按钮
    MHWaterWaveView* _waveUp;
    MHWaterWaveView* _waveMid;
    MHWaterWaveView* _waveDown;
    UIImageView* _upIndicator;
    BOOL _isUpAnimationStopped;     //是否停止向上动画
    
    MHTicker* _animTicker;          //动画时钟
    NSInteger _animCounter;
    
    UILabel *_tipsLabel;
    
    BOOL _deviceOnline;
    BOOL _dataloaded;
    
    BOOL _drinkAbled;
    BOOL _firstShow;      //第一次进入页面
//    NSInteger _tdsAnimValue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _firstShow = YES;
        
        [self buildSubviews];
        [self buildConstraints];
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)buildSubviews
{
    _inSubheadLabel = [UILabel new];
    [self addSubview:_inSubheadLabel];
    
    _tdsDigital = [MHTdsDigitalView new];
    [self addSubview:_tdsDigital];
    
    _waveUp = [MHWaterWaveView new];
    _waveUp.amplitude = 5.0;
    _waveUp.frequency = 150.0;
    _waveUp.velocity = 2.0;
    _waveUp.color = [MHColorUtils colorWithRGB:0x7a98b3 alpha:0.4];
    [self addSubview:_waveUp];
    
    _waveMid = [MHWaterWaveView new];
    _waveMid.amplitude = 5.0;
    _waveMid.frequency = 50.0;
    _waveMid.velocity = 2.0;
    _waveMid.color = [MHColorUtils colorWithRGB:0x7a98b3 alpha:0.6];
    [self addSubview:_waveMid];
    
    _waveDown = [MHWaterWaveView new];
    _waveDown.amplitude = 5.0;
    _waveDown.frequency = 100.0;
    _waveDown.velocity = 2.0;
    _waveDown.color = [MHColorUtils colorWithRGB:0x7a98b3 alpha:1.0];
    [self addSubview:_waveDown];
    
    _upIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waterpurifier_up_indicator"]];
    _upIndicator.alpha = 0;
    [self addSubview:_upIndicator];
    
    
    _offLineLabel = [[UILabel alloc] init];
    _offLineLabel.font = [UIFont systemFontOfSize:15.f];
    _offLineLabel.textColor = [MHColorUtils colorWithRGB:0xff9900];
    [self addSubview:_offLineLabel];
    _offLineLabel.hidden = YES;
    
//    _washBtn = [[UIButton alloc] init];
//    _washBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    _washBtn.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
//    _washBtn.layer.cornerRadius = 13.5;
//    [_washBtn setTitleColor:[MHColorUtils colorWithRGB:0x00caed] forState:UIControlStateNormal];
//    [_washBtn addTarget:self action:@selector(washAction) forControlEvents:UIControlEventTouchUpInside];
//    _washBtn.hidden = YES;
//    [self addSubview:_washBtn];
    
    
    UIImage* excBgImage = [[UIImage imageNamed:@"waterpurifier_exception_btn_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 30, 2, 30)];
    _exceptionBtn = [UIButton new];
    _exceptionBtn.hidden = YES;
    _exceptionBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_exceptionBtn setBackgroundImage:excBgImage forState:UIControlStateNormal];
    [_exceptionBtn setBackgroundImage:excBgImage forState:UIControlStateHighlighted];
    [_exceptionBtn setTitleColor:[MHColorUtils colorWithRGB:0xff9900] forState:UIControlStateNormal];

    [_exceptionBtn addTarget:self action:@selector(exceptionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exceptionBtn];
    
    //zcm 小提示
    _tipsLabel = [UILabel new];
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [_tipsLabel sizeToFit];
    [self addSubview:_tipsLabel];
}

- (void)buildConstraints
{
    XM_WS(weakself);
    [_inSubheadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        if([MHWaterpurifierDeviceHelp isPhoneX]) {
            make.top.equalTo(weakself).offset(77);
        }else {
            make.top.equalTo(weakself).offset(53);
        }
    }];
    
    [_tdsDigital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.centerY.equalTo(weakself.mas_centerY).multipliedBy(0.8);
        make.width.height.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)*0.4);
    }];
    
    [_waveUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself);
        make.height.equalTo(weakself).multipliedBy(0.25).offset(30.0);
    }];
    
    [_waveMid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself);
        make.height.equalTo(weakself).multipliedBy(0.25).offset(15.0);
    }];
    
    [_waveDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself);
        make.height.equalTo(weakself).multipliedBy(0.25);
    }];
    
    [_upIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.top.equalTo(weakself.mas_bottom);
    }];
    
    [_offLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, weakself);
        make.centerX.equalTo(ss);
        make.top.equalTo(ss->_tdsDigital.mas_bottom).offset(20.0);
    }];
//    [_washBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        XM_SS(ss, weakself);
//        make.centerX.equalTo(ss);
//        make.top.equalTo(ss->_tdsDigital.mas_bottom).offset(20.0);
//        make.size.mas_equalTo(CGSizeMake(140.0, 27.0));
//    }];
    
    [_exceptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, weakself);
        make.centerX.equalTo(ss);
        make.top.equalTo(ss->_offLineLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(27.0);
        make.width.mas_equalTo(140);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, weakself);
        make.centerX.equalTo(ss);
        make.left.equalTo(ss.mas_left).offset([YMScreenAdapter sizeBy750:30]);
        make.right.equalTo(ss.mas_right).offset(-[YMScreenAdapter sizeBy750:30]);
        make.bottom.equalTo(ss.mas_bottom).offset(-[YMScreenAdapter sizeBy750:140]);
    }];
}

- (void)setDevice:(MHDeviceWaterpurifier *)device
{
    _device = device;
    
    _inSubheadLabel.attributedText = [self inSubheadAttributedString:device];
    
    //zcm 小提示
//    _tipsLabel.hidden = [device.model isEqualToString:DeviceModelWaterPuriLX5] ? NO:YES;
    _tipsLabel.attributedText = [self randomTipsAttributedString];
    
    [self setColorAndDigitalWithProgress:0];
    [self switchToWaterDrinkable:NO];
}


/** zcm add
 *  @brief 随机小贴士
 *  @return 小贴士字符串
 */
- (NSAttributedString *)randomTipsAttributedString {
    
    NSString *tip1 = WaterpurifierString(@"water_tips_1", @"小贴士：多喝水可以促进肠胃消化呢");
    NSString *tip2 = WaterpurifierString(@"water_tips_2", @"小贴士：细嫩光滑的皮肤需要水的滋润哟");
    NSString *tip3 = WaterpurifierString(@"water_tips_3", @"小贴士：多喝水是保持红润脸色的关键哦");
    NSString *tip4 = WaterpurifierString(@"water_tips_4", @"小贴士：喝水有助于保持曼妙身材哦");
    NSString *tip5 = WaterpurifierString(@"water_tips_5", @"小贴士：起床后一定要喝水，因为它是一天身体开始运作的关键呢~");
    NSString *tip6 = WaterpurifierString(@"water_tips_6", @"小贴士：早晨空腹喝水要以小口小口缓慢地喝，喝完后缓步走最好啦~");
    NSString *tip7 = WaterpurifierString(@"water_tips_7", @"小贴士：喝水要讲究水质哦，过滤后的良质水是健康的重要保证~");
    NSString *tip8 = WaterpurifierString(@"water_tips_8", @"小贴士：喝水也要讲究，应该匀着喝，不要一下子大量灌水哟~");
    NSString *tip9 = WaterpurifierString(@"water_tips_9", @"小贴士：空调会夺走我们很多的水分，要多多补充水分哦~");
    NSString *tip10 = WaterpurifierString(@"water_tips_10", @"小贴士：睡前不要喝太多水啦，频繁起夜会影响睡眠质量呢");
    NSString *tip11 = WaterpurifierString(@"water_tips_11", @"小贴士：老年人睡前床边常备一杯水，口渴适量喝几口，降低脑血栓风险哦~");
    NSString *tip12 = WaterpurifierString(@"water_tips_12", @"小贴士：饭后半小时不要立刻喝水哦，半小时后慢慢喝~");
    NSString *tip13 = WaterpurifierString(@"water_tips_13", @"小贴士：喝水时温度不要太热也不要太冷哦，适宜人体温度的温水就可以啦~");
    
    NSArray *tips = @[tip1,tip2,tip3,tip4,tip5,tip6,tip7,tip8,tip9,tip10,tip11,tip12,tip13];
    
    int random = arc4random() % tips.count;
    
    NSString *tip = [tips objectAtIndex:random];
    
    NSDictionary* attr = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
    
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:tip attributes:attr];
    
    return attrString;
}

/** zcm 修改
 *  @brief 计算副标题“自来水水质”or“进水温度”的NSAttributedString
 *  @param device 设备类
 *  @return 副标题字符
 */
- (NSAttributedString *)inSubheadAttributedString:(MHDeviceWaterpurifier *)device
{
    NSDictionary* prefixAttr = @{NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x999999],
                                 NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
    NSDictionary* valueAttr =  @{NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x999999],
                                 NSFontAttributeName : [UIFont fontWithName:@"DINOffc-CondMedi" size:16.f]};

//    NSAttributedString* prefixString;
//    NSString* value;
//    prefixString = [[NSAttributedString alloc] initWithString:WaterpurifierString(@"tap.water.quality",  @"自来水水质: ") attributes:prefixAttr];
//    value = [NSString stringWithFormat:@"%d TDS", (int)device.tTds];
    
    NSAttributedString* prefixString;
    NSAttributedString* valueString;
    
    //zcm 米二代水温
    if([device.model isEqualToString:DeviceModelWaterPuriLX5]) {
        prefixString = [[NSAttributedString alloc] initWithString:WaterpurifierString(@"tap.water.temperature", @"进水温度: ")
                                                       attributes:prefixAttr];
        NSString *temValue = [NSString stringWithFormat:@"%d℃", (int)device.inTemperature];
        
        valueString = [[NSAttributedString alloc] initWithString:temValue attributes:valueAttr];
        
    }else {//zcm 米一代TDS
        prefixString = [[NSAttributedString alloc] initWithString:WaterpurifierString(@"tap.water.quality",  @"自来水水质: ") attributes:prefixAttr];
        
        NSString *tdsValue = [NSString stringWithFormat:@"%d TDS", (int)device.tTds];
        
        valueString = [[NSAttributedString alloc] initWithString:tdsValue attributes:valueAttr];
    }
    
    NSMutableAttributedString* attrText = [NSMutableAttributedString new];
    [attrText appendAttributedString:prefixString];
    [attrText appendAttributedString:valueString];
    
    return attrText;
}

#define kWaveAnimID @"WaveAnim"
#define kWaveAnimCount 50
- (void)easeInAndOutAnimation
{
//    NSInteger value = 0;
//    
//    if (!_firstShow) {
//        //第一次，动画从过滤前的值跳转到过滤后的值
//        _firstShow = YES;
//        value = _device.tTds - _device.pTds;
//    }else{
//        //之后，直接从上一次的值跳转到新的过滤后的值
//        value = _device.pTds - _tdsDigital.tdsValue;
//    }
//    if (value == 0) {
//        return;
//    }
//    _tdsAnimValue = value;
    
    //zcm add tds变化的动画
    
    if(_firstShow) {
        //第一次，动画从过滤前的值跳转到过滤后的值
        _firstShow = NO;
    }else {
        //第一次，不设置动画，直接跳转到目标TDS值
        [self setColorAndDigitalWithProgress:1];
        return;
    }

    XM_WS(ws);
    _animCounter = 0;
    _animTicker = [MHTicker new];
    _animTicker.interval = 0.05;
    [_animTicker addTaskWithIdentifier:kWaveAnimID delay:0 repeat:YES onMainThread:YES block:^{
        XM_SS(ss, ws);

        //lsl 2017.4.24,按原来的方法，progress就达不到1.
        //需要把progress与ss->_animTicker = nil;这2部分顺序调换。
        CGFloat progress = exponentialEaseInAndOut((CGFloat)ss->_animCounter / kWaveAnimCount);
        [ws setColorAndDigitalWithProgress:progress];
        
        if (ss->_animCounter >= kWaveAnimCount) {
            [ss->_animTicker removeTaskWithIdentifier:kWaveAnimID];
            ss->_animTicker = nil;
            return;
        }
        ss->_animCounter++;
    }];
}

- (void)deviceOfflineAnimation
{
    XM_WS(ws);
    _animCounter = 0;
    _animTicker = [MHTicker new];
    _animTicker.interval = 0.05;
    [_animTicker addTaskWithIdentifier:kWaveAnimID delay:0 repeat:YES onMainThread:YES block:^{
        XM_SS(ss, ws);

        CGFloat progress = exponentialEaseInAndOut((CGFloat)ss->_animCounter / kWaveAnimCount);
        [ws setDeviceOfflineProgress:progress];
        
        if (ss->_animCounter >= kWaveAnimCount) {
            [ss->_animTicker removeTaskWithIdentifier:kWaveAnimID];
            ss->_animTicker = nil;
            return;
        }
        
        ss->_animCounter++;
    }];
}

- (void)setDeviceOfflineProgress:(CGFloat)progress
{
    
    NSInteger value = round((_device.pTds - _device.tTds) * progress + _device.tTds);
    //NSLog(@"setDeviceOfflineProgress:%d",value);
    _tdsDigital.tdsValue = value;
    //_tdsDigital.tdsValue = (_device.pTds - _device.tTds) * progress + _device.tTds;
}

- (void)setColorAndDigitalWithProgress:(CGFloat)progress
{
    _tdsDigital.zeroColor = [MHColorUtils colorWithProgress:progress
                                                  fromColor:[MHColorUtils colorWithRGB:0xccd5de]
                                                    toColor:[MHColorUtils colorWithRGB:0xc0e6ec]];
    _tdsDigital.nonzeroColor = [MHColorUtils colorWithProgress:progress
                                                     fromColor:[MHColorUtils colorWithRGB:0x7a98b3]
                                                       toColor:[MHColorUtils colorWithRGB:0x00caed]];
    
    NSInteger value = (_device.pTds - _device.tTds) * progress + _device.tTds;
    //NSLog(@"pTds:%d,tTds:%d,progress:%f,value:%d",_device.pTds,_device.tTds,progress,value);
    
    _tdsDigital.tdsValue = value;
    //_tdsDigital.tdsValue = (_device.pTds - _device.tTds) * progress + _device.tTds;
    
    _waveUp.color = [MHColorUtils colorWithProgress:progress
                                          fromColor:[MHColorUtils colorWithRGB:0x7a98b3 alpha:0.4]
                                            toColor:[MHColorUtils colorWithRGB:0x00c1ec alpha:0.4]];
    _waveMid.color = [MHColorUtils colorWithProgress:progress
                                           fromColor:[MHColorUtils colorWithRGB:0x7a98b3 alpha:0.6]
                                             toColor:[MHColorUtils colorWithRGB:0x00d9ff alpha:0.6]];
    _waveDown.color = [MHColorUtils colorWithProgress:progress
                                            fromColor:[MHColorUtils colorWithRGB:0x7a98b3 alpha:1.0]
                                              toColor:[MHColorUtils colorWithRGB:0x00caed alpha:1.0]];
}

- (void)setTdsDetailHandler:(void (^)())tdsDetailHandler
{
    _tdsDigital.detailHandler = tdsDetailHandler;
}

- (void)setDigitalScale:(CGFloat)digitalScale
{
    _digitalScale = digitalScale;
    
    _inSubheadLabel.alpha = digitalScale;
    
    //zcm 添加：米二代 隐藏/显示小贴士
    _tipsLabel.alpha = digitalScale;
    
    if (_dataloaded) {
        //reloadTdsValue执行之后才执行这个部分
        if (_deviceOnline) {
            //_washBtn.hidden = digitalScale == 1.0 ? NO : YES;
            _offLineLabel.hidden = YES;
            NSInteger errorCount = [self.device.exceptions count];
            if (errorCount > 0) {
                _exceptionBtn.hidden = digitalScale == 1.0 ? NO : YES;
            }else{
                _exceptionBtn.hidden = YES;
            }
        }else{
            //_washBtn.hidden = YES;
            _offLineLabel.hidden = digitalScale == 1.0 ? NO : YES;
            _exceptionBtn.hidden = digitalScale == 1.0 ? NO : YES;
        }
    }
    
    CGFloat scale = 0.7 + 0.3 * digitalScale;
    _tdsDigital.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)reloadTdsValue:(BOOL)deviceOnline
{
    NSLog(@"deviceOnline:%@",@(deviceOnline));
    _dataloaded = YES;
    _deviceOnline = deviceOnline;
    _inSubheadLabel.attributedText = [self inSubheadAttributedString:self.device];
    
    NSInteger criticalValue = [self.device.model isEqualToString:DeviceModelWaterPuriLX5] ? self.device.tdsWarnVal : 200;

    if (deviceOnline) {
        
        //[self buildWashEntry];
        
        if ([self.device.exceptions count]) {
            [self buildExceptionEntry];
        } else {
            [self removeExceptionEntry];
        }
        //正常情况下，是不会大于100的，原先要处理这种情况，现在在固件已经处理。
        //zcm 修改：之前为100，现在一代、二代统一为200
        if (_device.pTds <= criticalValue) {
            
            if (!_drinkAbled) {
                [self easeInAndOutAnimation];
                [self switchToWaterDrinkable:YES];
                _drinkAbled = YES;
            }else{
                if (_device.pTds != _tdsDigital.tdsValue) {
                    [self easeInAndOutAnimation];
                }
            }
        }else{

            if (_drinkAbled) {
                [self setColorAndDigitalWithProgress:0];
                _tdsDigital.tdsValue = _device.pTds;
                [self switchToWaterDrinkable:NO];
                _drinkAbled = NO;
            }else{
                if (_device.pTds != _tdsDigital.tdsValue) {
                    [self setColorAndDigitalWithProgress:0];
                    _tdsDigital.tdsValue = _device.pTds;
                }
            }
        }
        
        
//        if (_device.pTds == _tdsDigital.tdsValue) {
//            // do nothing
//            if (_device.pTds == 0) {
//                [self easeInAndOutAnimation];
//                [self switchToWaterDrinkable:YES];
//            }
//        } else if (_device.pTds < 100) {
//            [self easeInAndOutAnimation];
//            [self switchToWaterDrinkable:YES];
//        } else {
//            [self setColorAndDigitalWithProgress:0];
//            [self switchToWaterDrinkable:NO];
//        }
    }else{
        [self buildOutlineEntry];
        
        if (_device.pTds <= criticalValue) {
            
            if (!_drinkAbled) {
                [self easeInAndOutAnimation];
                [self switchToWaterDrinkable:YES];
                _drinkAbled = YES;
            }
        }else{
            
            if (_drinkAbled) {
                [self setColorAndDigitalWithProgress:0];
                [self switchToWaterDrinkable:NO];
                _drinkAbled = NO;
            }
        }
        
        
//        if (_device.pTds == _tdsDigital.tdsValue) {
//            // do nothing
//        } else if (_device.pTds < 100) {
//            [self deviceOfflineAnimation];
//            [self switchToWaterDrinkable:YES];
//        } else {
//            [self setColorAndDigitalWithProgress:0];
//            [self switchToWaterDrinkable:NO];
//        }
    }
    


}

- (void)buildOutlineEntry
{
//    _washBtn.hidden = YES;
//    _washBtn.enabled = NO;
    
    _offLineLabel.hidden = self.digitalScale == 1.0 ? NO : YES;
    _offLineLabel.text = WaterpurifierString(@"um.string.lastdatas", @"自动获取上次在线数据");
    
    NSString *outlineTitle = WaterpurifierString(@"um.string.device.offline", @"设备离线");
    [_exceptionBtn setTitle:outlineTitle forState:UIControlStateNormal];
    _exceptionBtn.hidden = self.digitalScale == 1.0 ? NO : YES;
}

//- (void)buildWashEntry
//{
//    _washBtn.enabled = YES;
//    NSString *washTitle = [NSString stringWithFormat:WaterpurifierString(@"wash_tips_mainpage", @"%@天没有保养了"),@"11"];
//    [_washBtn setTitle:washTitle forState:UIControlStateNormal];
//    _washBtn.hidden = self.digitalScale == 1.0 ? NO : YES;
//}


- (void)buildExceptionEntry
{
 //   if (_exceptionBtn == nil) {
        _offLineLabel.hidden = YES;
        _offLineLabel.text = nil;
        //lsl修改
        NSInteger errorCount = [self.device.exceptions count];
        if (errorCount > 0) {
            NSString* excTitle = @"";
            if (errorCount > 1) {
                excTitle = [NSString stringWithFormat:@"%d%@",(int)errorCount,WaterpurifierString(@"um_string_qtion", @"个问题待处理")];
            }else{
                NSArray* excNos = [self.device.exceptions allKeys];
                MHDeviceWaterpurifierExceptionType type = [[excNos objectAtIndex:0] integerValue];
                //NSString *title = @"";
                
                if (type == MHDeviceWaterpurifierWash) {
                    NSNumber *days = [self.device.exceptions objectForKey:@(MHDeviceWaterpurifierWash)];
//                    excTitle = [NSString stringWithFormat:[MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:type],days];
                    
                    //zcm 修改异常提醒title
                    excTitle = [NSString stringWithFormat:[MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:type ofDeviceModel:self.device.model],days];
                }else{
//                    excTitle = [MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:type];
                    
                    //zcm 修改异常提醒title
                    excTitle = [MHWaterpurifierExceptionViewController exceptionTitleForSerialNo:type ofDeviceModel:self.device.model];
                }
//                if ( [[[self.device.exceptions allKeys] objectAtIndex:0] integerValue] == MHDeviceWaterpurifierTapLEDIntro) {
//                    
//                    
//                    
//                    
//                    excTitle = WaterpurifierString(@"waterpurifier.tap.light.tips", @"触控龙头灯指示");
//                }
                
                if([self.device.model isEqualToString:DeviceModelWaterPuriLX5] &&
                   (type == MHDeviceWaterpurifierFilterOneExhausted || type == MHDeviceWaterpurifierFilterOneExhausteWill)) {
                    
                    //zcm 米二代的一号滤芯文案太长，需要扩大长度显示
                    
                    [_exceptionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(165);
                    }];
                }
            }
            
//            NSString* excTitle = [NSString stringWithFormat:@"%d%@",(int)errorCount,WaterpurifierString(@"um_string_qtion", @"个消息待查看")];
            //WaterpurifierString(@"waterpurifier.exception", @"净水器异常");
            //NSLog(@"self.device.exceptions:%@",self.device.exceptions);
            
            //NSString* excTitle = WaterpurifierString(@"waterpurifier.exception", @"净水器异常");
//            if ([self.device.exceptions count] == 1) {
//                if ( [[[self.device.exceptions allKeys] objectAtIndex:0] integerValue] == MHDeviceWaterpurifierTapLEDIntro) {
//                    excTitle = WaterpurifierString(@"waterpurifier.tap.light.tips", @"触控龙头灯指示");
//                }
//            }
            
            [_exceptionBtn setTitle:excTitle forState:UIControlStateNormal];
            
            
            
            _exceptionBtn.hidden = self.digitalScale == 1.0 ? NO : YES;
            //_exceptionBtn.hidden = NO;
        }else{
            _exceptionBtn.hidden = YES;
        }

    

    
    
//        UIImage* excBgImage = [[UIImage imageNamed:@"waterpurifier_exception_btn_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 30, 2, 30)];
//        _exceptionBtn = [UIButton new];
//        _exceptionBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        [_exceptionBtn setBackgroundImage:excBgImage forState:UIControlStateNormal];
//        [_exceptionBtn setBackgroundImage:excBgImage forState:UIControlStateHighlighted];
//        [_exceptionBtn setTitleColor:[MHColorUtils colorWithRGB:0xff9900] forState:UIControlStateNormal];
//        [_exceptionBtn setTitle:excTitle forState:UIControlStateNormal];
//        [_exceptionBtn addTarget:self action:@selector(exceptionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_exceptionBtn];
//        
//        XM_WS(ws);
//        [_exceptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            XM_SS(ss, ws);
//            make.centerX.equalTo(ws);
//            make.top.equalTo(ss->_tdsDigital.mas_bottom).offset(20.0);
//            make.height.mas_equalTo(27.0);
//            make.width.mas_equalTo(140.0);
//        }];
 //   }
}

- (void)removeExceptionEntry
{
    [_exceptionBtn removeFromSuperview];
    _exceptionBtn = nil;
}

//- (void)washAction
//{
//    if (self.washHandler) {
//        self.washHandler();
//    }
//}


- (void)exceptionBtnClicked:(id)sender
{
    if (self.exceptionHandler) {
        self.exceptionHandler();
    }
}

- (void)switchToWaterDrinkable:(BOOL)drinkable
{
    NSAttributedString* emptyDesc = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
    NSAttributedString* drinkDesc = [[NSAttributedString alloc] initWithString:WaterpurifierString(@"purified.water.drinkable", @"过滤后水质可饮用") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x00caed]}];
    NSAttributedString* undrinkDesc = [[NSAttributedString alloc] initWithString:WaterpurifierString(@"purified.water.undrinkable", @"当前水质不可直饮") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x7a98b3]}];
    if (drinkable) {
        [_tdsDigital switchFromDescription:undrinkDesc toDescription:drinkDesc];
    } else {
        [_tdsDigital switchFromDescription:emptyDesc toDescription:undrinkDesc];
    }
}

- (void)startWaveAnimation
{
    [_waveUp startWaveAnimation];
    [_waveMid startWaveAnimation];
    [_waveDown startWaveAnimation];
}

- (void)stopWaveAnimation
{
    [_waveUp stopWaveAnimation];
    [_waveMid stopWaveAnimation];
    [_waveDown stopWaveAnimation];
}

- (void)startUpIndicatorAnimation
{
    NSLog(@"%s", __FUNCTION__);
    _isUpAnimationStopped = NO;
    [self upIndicatorAnimation];
}

- (void)stopUpIndicatorAnimation
{
    NSLog(@"%s", __FUNCTION__);
    _isUpAnimationStopped = YES;
}

- (void)upIndicatorAnimation
{
    NSLog(@"%s", __FUNCTION__);
    if (_isUpAnimationStopped) {
        return;
    }
    XM_WS(weakself);
    [MHSerialAnimation addAnimationWithDuration:1.5 delay:0 options:UIViewAnimationCurveEaseOut preAnimation:NULL animations:^{
        XM_SS(ss, weakself);
        [ss->_upIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakself.mas_bottom).offset(-20.0);
            make.centerX.equalTo(weakself);
        }];
        [weakself layoutIfNeeded];
        ss->_upIndicator.alpha = 1.0;
    } completion:^{
        [MHSerialAnimation addAnimationWithDuration:1.5 delay:0 options:UIViewAnimationCurveEaseIn preAnimation:NULL animations:^{
            XM_SS(ss, weakself);
            [ss->_upIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakself.mas_bottom).offset(-50.0);
                make.centerX.equalTo(weakself);
            }];
            [weakself layoutIfNeeded];
            ss->_upIndicator.alpha = 0.0;
        } completion:^{
            XM_SS(ss, weakself);
            [ss->_upIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself.mas_bottom);
                make.centerX.equalTo(weakself);
            }];
            [weakself upIndicatorAnimation];
        }];
    }];
}


@end
