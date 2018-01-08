//
//  MHTwoFilterSketchView.m
//  MiHome
//
//  Created by ChengMinZhang on 2017/8/11.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHTwoFilterSketchView.h"
#import "MHFilterLifetimeView.h"
#import "YMScreenAdapter.h"

@implementation MHTwoFilterSketchView
{
    MHFilterLifetimeView* _filter1;
    MHFilterLifetimeView* _filter2;
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
    
    CGFloat diameter = [YMScreenAdapter sizeBy750:124];
    
    self.layer.borderColor = [MHColorUtils colorWithRGB:0xC6C6C6].CGColor;
    self.layer.borderWidth = [YMScreenAdapter sizeBy750:4];
    self.layer.cornerRadius = [YMScreenAdapter sizeBy750:96];
    
    
    _filter1 = [MHFilterLifetimeView new];
    _filter1.index = 1;
    [self addSubview:_filter1];
    
    [_filter1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset([YMScreenAdapter sizeBy750:33]);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(diameter,diameter));
    }];
    
    _filter2 = [MHFilterLifetimeView new];
    _filter2.index = 2;
    [self addSubview:_filter2];
    
    [_filter2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-[YMScreenAdapter sizeBy750:33]);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(diameter,diameter));
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
        default:
            break;
    }
}

@end
