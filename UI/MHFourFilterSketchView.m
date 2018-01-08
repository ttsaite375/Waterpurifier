//
//  MHFilterStatusSketchView.m
//  MiHome
//
//  Created by wayne on 15/7/6.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHFourFilterSketchView.h"
#import "MHFilterLifetimeView.h"

@implementation MHFourFilterSketchView
{
    MHFilterLifetimeView* _filter1;
    MHFilterLifetimeView* _filter2;
    MHFilterLifetimeView* _filter3;
    MHFilterLifetimeView* _filter4;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    CGFloat cornerRadius = CGRectGetWidth([UIScreen mainScreen].bounds) / 10.0;
    CGFloat radius = CGRectGetWidth([UIScreen mainScreen].bounds) / 13.0;
    CGFloat margin = radius * 0.7;
    CGFloat diameter = radius * 2.0;
    CGFloat diameter2 = radius * 2.0 * 0.85;
    //border
    self.layer.borderColor = [MHColorUtils colorWithRGB:0xC6C6C6].CGColor;
    self.layer.borderWidth = 3.0;
    self.layer.cornerRadius = cornerRadius;
    
    XM_WS(weakself);
    _filter3 = [MHFilterLifetimeView new];
    _filter3.index = 3;
    [self addSubview:_filter3];
    [_filter3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(margin);
        make.size.mas_equalTo(CGSizeMake(diameter, diameter));
    }];
    
    _filter1 = [MHFilterLifetimeView new];
    _filter1.index = 1;
    [self addSubview:_filter1];
    [_filter1 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.bottom.equalTo(self).offset(-margin);
        make.centerX.equalTo(strongself->_filter3);
        make.size.mas_equalTo(CGSizeMake(diameter2, diameter2));
    }];
    
    _filter2 = [MHFilterLifetimeView new];
    _filter2.index = 2;
    [self addSubview:_filter2];
    [_filter2 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.centerX.equalTo(strongself->_filter3);
//        make.centerY.mas_equalTo(weakself);
        make.size.mas_equalTo(CGSizeMake(diameter2, diameter2));
    }];
    
    // 竖直等间隔
    UIView* vSpaceView1 = [UIView new];
    [self addSubview:vSpaceView1];
    [vSpaceView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.top.equalTo(strongself->_filter3.mas_bottom);
        make.bottom.equalTo(strongself->_filter2.mas_top);
    }];
    
    UIView* vSpaceView2 = [UIView new];
    [self addSubview:vSpaceView2];
    [vSpaceView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.top.equalTo(strongself->_filter2.mas_bottom);
        make.bottom.equalTo(strongself->_filter1.mas_top);
        make.height.equalTo(vSpaceView1.mas_height);
    }];
    
    _filter4 = [MHFilterLifetimeView new];
    _filter4.index = 4;
    [self addSubview:_filter4];
    [_filter4 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.centerY.equalTo(strongself->_filter3);
        make.trailing.equalTo(self).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(diameter2, diameter2));
    }];
}

- (void)setFilterObject:(MHWaterFilterObject *)filterObject
{
    switch (filterObject.index) {
        case 1:
            _filter1.filterObject = filterObject;
            break;
        case 2:
            _filter2.filterObject = filterObject;
            break;
        case 3:
            _filter3.filterObject = filterObject;
            break;
        case 4:
            _filter4.filterObject = filterObject;
            break;
        default:
            break;
    }
}

@end
