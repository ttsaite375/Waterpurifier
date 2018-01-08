//
//  MHFilterTipsview.m
//  MiHome
//
//  Created by liushilou on 16/8/2.
//  Copyright © 2016年 小米移动软件. All rights reserved.
//

#import "MHFilterTipsview.h"
#import "YMScreenAdapter.h"
#import "MHWaterFilterObject.h"
#import "MHWaterpurifierDefine.h"

@implementation MHFilterTipsview


- (void)showWidthData:(NSArray *)datas
{
    self.hidden = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    UIColor *textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1];
    
    
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:[YMScreenAdapter sizeBy1080:50]];
    tiplabel.textColor = textColor;
    tiplabel.numberOfLines = 0;
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.text = WaterpurifierString(@"filter.status.tips",  @"请及时更换滤芯\n保证饮水品质");
    tiplabel.layer.borderColor = textColor.CGColor;
    tiplabel.layer.borderWidth = 1;
    tiplabel.layer.cornerRadius = [YMScreenAdapter sizeBy1080:20];
    [self addSubview:tiplabel];
    [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy1080:600], [YMScreenAdapter sizeBy1080:240]));
    }];
    
    
    
    
    UILabel *statuslabel = [[UILabel alloc] init];
    statuslabel.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:[YMScreenAdapter sizeBy1080:50]];
    statuslabel.textColor = textColor;
    statuslabel.numberOfLines = 0;
    statuslabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:statuslabel];
    [statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(tiplabel.mas_top).with.offset(-[YMScreenAdapter sizeBy1080:30]);
    }];
    
    NSMutableString *statusStr = [NSMutableString new];
    for (MHWaterFilterObject *obj in datas) {
        [statusStr appendString:obj.name];
        
        NSInteger days = (NSInteger)((obj.totalTime * obj.lifePercentage)/24);
        if (days == 0) {
            [statusStr appendString:WaterpurifierString(@"filter.status.expire",  @" 已经到期\n")];
        }else{
            
            [statusStr appendString:WaterpurifierString(@"filter.status.willexpire",  @" 即将到期\n")];
        }
    }
    
    statuslabel.text = statusStr;
    
    
    
    
    
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:hideBtn];
    [hideBtn setTitle:WaterpurifierString(@"filter.status.know",  @"知道了") forState:UIControlStateNormal];
    [hideBtn setTitleColor:textColor forState:UIControlStateNormal];
    [hideBtn.titleLabel setFont:[UIFont fontWithName:@"DINOffc-CondMedi" size:[YMScreenAdapter sizeBy1080:50]]];
    hideBtn.layer.borderColor = textColor.CGColor;
    hideBtn.layer.borderWidth = 1;
    hideBtn.layer.cornerRadius = [YMScreenAdapter sizeBy1080:60];
    [hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-[YMScreenAdapter sizeBy1080:100]);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy1080:300], [YMScreenAdapter sizeBy1080:120]));
    }];
    [hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 6*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide
{
    self.hidden = YES;
//    [self removeFromSuperview];
}


@end
