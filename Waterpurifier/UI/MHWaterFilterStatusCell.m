//
//  MHWaterFilterStatusCell.m
//  MiHome
//
//  Created by wayne on 15/6/29.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterFilterStatusCell.h"
#import "MHWaterpurifierDefine.h"
#import "YMScreenAdapter.h"

@implementation MHWaterFilterStatusCell
{
    UIImageView* _filterIndexBg;
    UIImageView* _filterDisclosure;
    UILabel* _filterIndex;
    UILabel* _filterName;
    UILabel* _remainDays;
    UILabel* _remainPercentage;
    UIImageView *_tipImageview;
    BOOL _tipAnimating;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage* bgImage = [UIImage imageNamed:@"waterpurifier_filter_index_bg"];
        _filterIndexBg = [[UIImageView alloc] initWithImage:bgImage];
        [self.contentView addSubview:_filterIndexBg];
        
        XM_WS(weakself);
        [_filterIndexBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.0);
            make.centerY.equalTo(weakself.contentView);
            make.size.mas_equalTo(bgImage.size);
        }];
        
        _filterIndex = [UILabel new];
        _filterIndex.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:24.f];
        _filterIndex.textColor = [MHColorUtils colorWithRGB:0x00caed];
        _filterIndex.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_filterIndex];
        
        [_filterIndex mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(strongself, weakself);
            make.center.equalTo(strongself->_filterIndexBg);
        }];
        
        _filterName = [UILabel new];
        _filterName.textColor = [UIColor whiteColor];
        _filterName.font = [UIFont boldSystemFontOfSize:14.f];
        [self.contentView addSubview:_filterName];
        
        [_filterName mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, weakself);
            make.left.equalTo(ss->_filterIndexBg.mas_right).offset(15.0);
            make.right.equalTo(weakself.contentView).offset(-75.0);
            make.bottom.equalTo(weakself.contentView.mas_centerY).offset(-1.0);
        }];
        
        _remainDays = [UILabel new];
        _remainDays.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _remainDays.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_remainDays];
        
        [_remainDays mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, weakself);
            make.left.equalTo(ss->_filterName);
            make.top.equalTo(weakself.contentView.mas_centerY).offset(2.0);
        }];
        
        _filterDisclosure = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waterpurifier_filter_disclosure"]];
        [self.contentView addSubview:_filterDisclosure];
        
        [_filterDisclosure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.contentView);
            make.right.equalTo(weakself.contentView).offset(-15.0);
        }];
        
        _remainPercentage = [UILabel new];
        _remainPercentage.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _remainPercentage.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:20.f];
        [self.contentView addSubview:_remainPercentage];
        
        [_remainPercentage mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, weakself);
            make.right.equalTo(ss->_filterDisclosure.mas_left).offset(-16.0);
            make.centerY.equalTo(weakself.contentView);
        }];
        
        _tipImageview = [[UIImageView alloc] init];
        [self.contentView addSubview:_tipImageview];
        
        [_tipImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, weakself);
            make.right.equalTo(ss->_remainPercentage.mas_left).offset(-[YMScreenAdapter sizeBy1080:16]);
            make.centerY.equalTo(weakself.contentView);
            make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy1080:136], [YMScreenAdapter sizeBy1080:136]));
        }];
    }
    return self;
}

- (void)configureWithDataObject:(MHWaterFilterObject *)object
{
    _filterIndex.text = @(object.index).stringValue;
    
    _filterName.text = object.name;
    
    NSInteger days = (NSInteger)((object.totalTime * object.lifePercentage)/24);
    
    BOOL getDeviceDataSuccess = NO;
    if (object.totalTime > 0) {   //第一次配置单元格，设备数据还没获取到。
        getDeviceDataSuccess = YES;
    }
    
    if (getDeviceDataSuccess) {
        _remainDays.text = [NSString stringWithFormat:WaterpurifierString(@"filter.available.days", @"预计剩余天数%d天"), days];
        _remainPercentage.text = [NSString stringWithFormat:@"%d%%", (int)(object.lifePercentage * 100)];
    }else{
        _remainDays.text = [NSString stringWithFormat:WaterpurifierString(@"filter.unavailable.days", @"预计剩余天数--天"), days];
        _remainPercentage.text = @"--%";
    }

    
    
    //lsl修改
    if (!getDeviceDataSuccess) {
        return;
    }
    
    NSLog(@"days:%ld",(long)days);
    //    days = 1;
    if (days <= 15) {
        UIImage* image = nil;
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if (days <= 0 ) {
            if ([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
                image = [UIImage imageNamed:@"waterpurifier_xin_expire"];
            }else{
                image = [UIImage imageNamed:@"waterpurifier_xin_expire_e"];
            }
            
        }else{
            if ([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
                image = [UIImage imageNamed:@"waterpurifier_xin_will_expire"];
            }else{
                image = [UIImage imageNamed:@"waterpurifier_xin_will_expire_e"];
            }
        }
        _tipImageview.image = image;
        
        
        if (!_tipAnimating) {
            _tipAnimating = YES;
            [self hideTipAnimate];
        }
    }else{
        _tipImageview.image = nil;
        _tipAnimating = NO;
    }
}


//lsl修改
//闪烁效果
- (void)showTipAnimate
{
    [UIView animateWithDuration:1.0 animations:^{
        self->_tipImageview.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (self->_tipImageview.image != nil) {
            [self hideTipAnimate];
        }
        
    }];
}

- (void)hideTipAnimate
{
    [UIView animateWithDuration:1.0 animations:^{
        self->_tipImageview.alpha = 0.2;
    } completion:^(BOOL finished) {
        if (self->_tipImageview.image != nil) {
            [self showTipAnimate];
        }
    }];
}


@end
