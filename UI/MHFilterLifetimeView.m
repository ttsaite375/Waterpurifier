//
//  MHFilterLifetimeView.m
//  MiHome
//
//  Created by wayne on 15/7/7.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHFilterLifetimeView.h"
#import "MHCircularProgressView.h"
#import "MHWaterFilterStatusColor.h"

@implementation MHFilterLifetimeView
{
    MHCircularProgressView* _lifetime;
    UILabel* _indexLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildSubviews];
    }
    return self;
}




- (void)buildSubviews
{
    XM_WS(weakself);
    _lifetime = [MHCircularProgressView new];
    
    //_lifetime.progressTintColor = [MHColorUtils colorWithRGB:0x00D3E8];
    _lifetime.unfillTintColor = [MHColorUtils colorWithRGB:0xDFDFDF];
//    _lifetime.progressTintColor = [MHWaterFilterStatusColor statusColor:_filterObject];
    [self addSubview:_lifetime];
    [_lifetime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
    
    _indexLabel = [UILabel new];
    _indexLabel.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:30.f];
    _indexLabel.textColor = [MHColorUtils colorWithRGB:0xD7D7D7];
    [self addSubview:_indexLabel];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself);
    }];
}

- (void)setFilterObject:(MHWaterFilterObject *)object
{
    _lifetime.progressTintColor = [MHWaterFilterStatusColor statusColor:object];
    _lifetime.progress = object.lifePercentage;
    
    NSInteger days = (NSInteger)((object.totalTime * object.lifePercentage)/24);
    NSLog(@"days:%d",days);
    
    if (days == 0 || isnan(days)) {
        //l滤芯到期，显示红色
        _lifetime.progress = 1;
    }
    _indexLabel.textColor = [MHWaterFilterStatusColor statusColor:object];

}

- (void)setIndex:(NSInteger)index
{
    _indexLabel.text = [@(index) stringValue];
}

@end
