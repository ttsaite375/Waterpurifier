//
//  MHWaterUsagePole.m
//  MiHome
//
//  Created by wayne on 15/6/30.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterUsagePole.h"
#import "MHNotificationCenter.h"

#define kNotificationWaterUsagePoleSelected @"NotificationWaterUsagePoleSelected"

@implementation MHWaterUsageObject

@end

@implementation MHWaterUsagePole
{
    UILabel* _barLabel;
    UIButton* _selectBtn;
    UIView *_outWaterUsageBar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildSubviews];
        
        XM_WS(weakself);
        [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationWaterUsagePoleSelected
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          if (note.object != weakself) {
                                                              weakself.selected = NO;
                                                          } else {
                                                              NSLog(@"self notification received!");
                                                          }
                                                      }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildSubviews
{
    XM_WS(weakself);
    _inWaterUsageBar = [UIView new];
    _inWaterUsageBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self addSubview:_inWaterUsageBar];
    
    _outWaterUsageBar = [UIView new];
    _outWaterUsageBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    [self addSubview:_outWaterUsageBar];
    
    _barLabel = [UILabel new];
    _barLabel.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:17.f];
    _barLabel.textColor = [UIColor whiteColor];
    _barLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_barLabel];
    [_barLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
        make.bottom.equalTo(weakself);
    }];
    
    _selectBtn = [UIButton new];
    [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
}

- (void)selectBtnClicked:(id)sender
{
    self.selected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWaterUsagePoleSelected object:self];
    if (self.selectedHandler) {
        self.selectedHandler(self.usage);
    }
}

- (void)setUsage:(MHWaterUsageObject *)usage
{
    _usage = usage;
    _barLabel.text = usage.label;
    if (usage.type == MHWaterPurifyDailyRecord) {
        _barLabel.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:17.f];
    }
    else if (usage.type == MHWaterPurifyWeeklyRecord || usage.type == MHWaterPurifyMonthlyRecord) {
        _barLabel.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:14.f];
    }
    
    XM_WS(ws);
    [_inWaterUsageBar mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.centerX.equalTo(self);
        make.bottom.equalTo(ss->_barLabel.mas_top).offset(-10.0);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(self).multipliedBy((CGFloat)usage.inWaterVolume / usage.maxVolumn * 0.8);
    }];
    
    [_outWaterUsageBar mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.centerX.equalTo(self);
        make.bottom.equalTo(ss->_barLabel.mas_top).offset(-10.0);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(self).multipliedBy((CGFloat)usage.outWaterVolume / usage.maxVolumn * 0.8);
    }];
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        _inWaterUsageBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _outWaterUsageBar.backgroundColor = [UIColor whiteColor];
        _barLabel.text = _usage.selectedLabel;
    } else {
        _inWaterUsageBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        _outWaterUsageBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _barLabel.text = _usage.label;
    }
}

@end
