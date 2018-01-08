//
//  MHWaterUsageChart.m
//  MiHome
//
//  Created by wayne on 15/6/30.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterUsageChart.h"
#import "MHDataWaterPurifyRecord.h"
#import <MiHomeInternal/MHTimeUtils.h>
#import "MHWaterpurifierDefine.h"
#import "YMScreenAdapter.h"

@interface MHWaterUsageChart () <UIScrollViewDelegate>

@end

@implementation MHWaterUsageChart
{
    UILabel* _usageTitle;
    
    UILabel* _inWaterVolumn;
    UILabel* _inWaterLabel;
    UILabel* _outWaterVolumn;
    UILabel* _outWaterLabel;
    
    UISegmentedControl* _intervalSelector;
    UIScrollView* _chartScrollView;
    UIView* _chartContainer;
    UIImageView* _chartBg;
    UIImageView* _selectedIndicator; //选中指示箭头
    
    NSArray* _purifyRecords;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildSubviews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    draw1PxStroke(ctx, CGPointMake(0, CGRectGetMaxY(rect)-0.5), CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)-0.5), [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor);
}

- (void)buildSubviews
{
    //zcm 修改 多处约束优化
    XM_WS(ws);
    _usageTitle = [UILabel new];
    _usageTitle.font = [UIFont systemFontOfSize:12.f];
    _usageTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    _usageTitle.text = WaterpurifierString(@"daily.water.usage", @"日用水详情");
    [self addSubview:_usageTitle];
    
    [_usageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(24.0);
        //zcm 修改
        make.left.mas_equalTo([YMScreenAdapter sizeBy750:24]);
        make.top.equalTo(ws).offset(28.0);
        make.height.mas_equalTo(20.0);
    }];
    
    _inWaterVolumn = [UILabel new];
    _inWaterVolumn.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:31.f];
    _inWaterVolumn.textColor = [UIColor whiteColor];
    _inWaterVolumn.text = @"--";
    [self addSubview:_inWaterVolumn];
    
    [_inWaterVolumn mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.top.equalTo(ss->_usageTitle.mas_bottom).offset(6.0);
        make.left.equalTo(ss->_usageTitle);
        make.height.mas_equalTo(40.0);
    }];
    
    _inWaterLabel = [UILabel new];
    _inWaterLabel.font = [UIFont systemFontOfSize:9.f];
    _inWaterLabel.textColor = [UIColor whiteColor];
    _inWaterLabel.text = WaterpurifierString(@"tap.water.input", @"自来水\n用量(L)");
    _inWaterLabel.numberOfLines = 0;
    [self addSubview:_inWaterLabel];
    
    [_inWaterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.left.equalTo(ss->_inWaterVolumn.mas_right);
        make.centerY.equalTo(ss->_inWaterVolumn);
    }];
    
    _outWaterVolumn = [UILabel new];
    _outWaterVolumn.font = [UIFont fontWithName:@"DINOffc-CondMedi" size:31.f];
    _outWaterVolumn.textColor = [UIColor whiteColor];
    _outWaterVolumn.text = @"--";
    [self addSubview:_outWaterVolumn];
    
    [_outWaterVolumn mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
//        make.left.equalTo(ss->_inWaterLabel.mas_right).offset(24.0);
        //zcm 修改
        make.left.equalTo(ss->_inWaterLabel.mas_right).offset([YMScreenAdapter sizeBy750:24]);
        make.centerY.equalTo(ss->_inWaterVolumn);
    }];
    
    _outWaterLabel = [UILabel new];
    _outWaterLabel.font = [UIFont systemFontOfSize:9.f];
    _outWaterLabel.textColor = [UIColor whiteColor];
    _outWaterLabel.text = WaterpurifierString(@"pure.water.output", @"纯净水\n生成量(L)");
    _outWaterLabel.numberOfLines = 0;
    [self addSubview:_outWaterLabel];
    
    [_outWaterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.left.equalTo(ss->_outWaterVolumn.mas_right);
        make.centerY.equalTo(ss->_outWaterVolumn);
    }];
    
    NSArray* intervalItems = @[WaterpurifierString(@"month", @"月"), WaterpurifierString(@"week", @"周"), WaterpurifierString(@"day", @"日")];
    _intervalSelector = [[UISegmentedControl alloc] initWithItems:intervalItems];
    _intervalSelector.selectedSegmentIndex = [intervalItems count] - 1;
    _intervalSelector.tintColor = [UIColor whiteColor];
    [intervalItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XM_SS(ss, ws);
        [ss->_intervalSelector setWidth:35.0 forSegmentAtIndex:idx];
    }];
    [_intervalSelector addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_intervalSelector];
    [_intervalSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
//        make.right.equalTo(self.mas_right).offset(-24.0);
        //zcm 修改
        make.right.equalTo(self.mas_right).with.offset(-[YMScreenAdapter sizeBy750:24]);
        make.centerY.equalTo(ss->_inWaterVolumn);
    }];
    
    _chartScrollView = [UIScrollView new];
    _chartScrollView.showsHorizontalScrollIndicator = NO;
    _chartScrollView.directionalLockEnabled = YES;
    _chartScrollView.delegate = self;
    [self addSubview:_chartScrollView];
    
    [_chartScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.top.equalTo(ss->_intervalSelector.mas_bottom).offset(25.0);
        make.left.right.bottom.equalTo(ws);
    }];
    
    UIImage* bgBlock = [UIImage imageNamed:@"waterpurifier_chart_bg"];
    bgBlock = [bgBlock resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    _chartBg = [[UIImageView alloc] initWithImage:bgBlock];
    [self addSubview:_chartBg];
    
    [_chartBg mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.left.right.top.equalTo(ss->_chartScrollView);
        make.bottom.equalTo(ws).offset(-30.0);
    }];
    
    _chartContainer = [UIView new];
    [_chartScrollView addSubview:_chartContainer];
    [_chartContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(ss, ws);
        make.edges.equalTo(ss->_chartScrollView);
        make.height.equalTo(ss->_chartScrollView);
    }];
    
    _selectedIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waterpurifier_usage_selected"]];
    [_chartContainer addSubview:_selectedIndicator];
}

- (void)updateUsageDetailWithObject:(MHWaterUsageObject *)object
{
    
//    _inWaterVolumn.text = [NSString stringWithFormat:@"%.1f", object.inWaterVolume / 1000.f];
//    _outWaterVolumn.text = [NSString stringWithFormat:@"%.1f", object.outWaterVolume / 1000.f];
    
    //zcm 米二代 隐藏进水量
    if([self.device.model isEqualToString:DeviceModelWaterPuriLX5]) {
        
        _inWaterLabel.hidden = YES;
        _inWaterVolumn.hidden = YES;
        _outWaterVolumn.text =  [NSString stringWithFormat:@"%.1f", object.outWaterVolume / 1000.f];
        
        //zcm 更新出水量的位置
        XM_WS(ws);
        [_outWaterVolumn mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, ws);
            make.top.equalTo(ss->_usageTitle.mas_bottom).offset(6.0);
            make.left.equalTo(ss->_usageTitle);
            make.height.mas_equalTo(40.0);
        }];
        
        [_outWaterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, ws);
            make.left.equalTo(ss->_outWaterVolumn.mas_right);
            make.centerY.equalTo(ss->_outWaterVolumn);
        }];
    }else {
        //zcm 米一代显示 进水量 和出水量
        _inWaterVolumn.text = [NSString stringWithFormat:@"%.1f", object.inWaterVolume / 1000.f];
        _outWaterVolumn.text = [NSString stringWithFormat:@"%.1f", object.outWaterVolume / 1000.f];
    }
}

- (void)updatePurifyUsageObjects:(NSArray *)objects
{
    for (UIView* subview in _chartContainer.subviews) {
        if (subview == _selectedIndicator) {
            continue;
        }
        [subview removeFromSuperview];
    }
    
    //zcm 米二代 是否需要显示进水量
    BOOL isWaterPuriLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
    
    XM_WS(weakself);
    MHWaterUsagePole* lastPole = nil;
    for (MHWaterUsageObject* usage in objects) {
        MHWaterUsagePole* pole = [MHWaterUsagePole new];

        pole.inWaterUsageBar.hidden = isWaterPuriLX5 ? YES : NO; //zcm add: 米二代 只显示纯水量，so隐藏进水量
        
        __weak MHWaterUsagePole* weakPole = pole;
        pole.selectedHandler = ^(MHWaterUsageObject *object) {
            XM_SS(ss, weakself);
            [weakself updateUsageDetailWithObject:object];
            if (weakself.recordSelectedHandler) {
                weakself.recordSelectedHandler(object);
            }
            [UIView animateWithDuration:0.5 animations:^{
                [ss->_selectedIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(weakPole);
                    make.bottom.equalTo(ss->_chartContainer);
                }];
                [ss->_selectedIndicator layoutIfNeeded];
            }];
        };
        [_chartContainer addSubview:pole];
        [pole mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(strongself, weakself);
            if (strongself == nil) {
                return;
            }
            make.top.equalTo(strongself->_chartContainer);
            make.bottom.equalTo(strongself->_chartContainer).offset(-15.0);
            switch (usage.type) {
                case MHWaterPurifyDailyRecord:
                    make.width.mas_equalTo(32.0);
                    break;
                case MHWaterPurifyWeeklyRecord:
                    make.width.mas_equalTo(60.0);
                    break;
                case MHWaterPurifyMonthlyRecord:
                    make.width.mas_equalTo(82.0);
                    break;
                default:
                    make.width.mas_equalTo(32.0);
                    break;
            }
            if (lastPole) {
                make.left.equalTo(lastPole.mas_right);
            } else {
                make.left.equalTo(strongself->_chartContainer.mas_left);
            }
        }];
        pole.usage = usage;
        
        lastPole = pole;
        
    }
    
    lastPole.selected = YES;
    [self updateUsageDetailWithObject:lastPole.usage];
    if (self.recordSelectedHandler) {
        self.recordSelectedHandler(lastPole.usage);
    }
    
    if (lastPole) {
        [_selectedIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, weakself);
            make.centerX.equalTo(lastPole);
            make.bottom.equalTo(ss->_chartContainer);
        }];
        [_chartContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastPole.mas_right);
        }];
    }
    
    //zcm add : 柱状图默认滚动到最右侧，显示最新的柱子。
    [self layoutIfNeeded];
    
    CGFloat offsetX = _chartScrollView.contentSize.width - _chartScrollView.bounds.size.width;
    
    CGPoint offset =  CGPointMake(offsetX, 0);
    
    if(offsetX > 0) {
      [_chartScrollView setContentOffset:offset];
    }
}

- (void)refreshPurifyRecords
{
    MHWaterPurifyRecordType type = MHWaterPurifyOnceRecord;
    switch (_intervalSelector.selectedSegmentIndex) {
        case 0:
            type = MHWaterPurifyMonthlyRecord;
            break;
        case 1:
            type = MHWaterPurifyWeeklyRecord;
            break;
        case 2:
            type = MHWaterPurifyDailyRecord;
            break;
        default:
            type = MHWaterPurifyOnceRecord;
            break;
    }
    [self.device getPurifyRecordsForType:type completion:^(NSArray *records) {
        
//        NSInteger maxInVolumn = 0;
//        for (MHDataWaterPurifyRecord* record in records) {
//            if (record.inVolumn > maxInVolumn) {
//                maxInVolumn = record.inVolumn;
//            }
//        }
//        if (maxInVolumn == 0) {
//            maxInVolumn = 1;
//        }
        
        //zcm 添加：米二代纯水量为极限，米一代进水量为极限。
        BOOL isWaterPuriLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
        
        NSInteger maxVolumn = 0;  //柱状图高度（极限）
        
        for (MHDataWaterPurifyRecord *record in records) {
            if(isWaterPuriLX5) {
                maxVolumn = record.outVolumn > maxVolumn ? record.outVolumn : maxVolumn;  //出水量为极限
            }else {
                maxVolumn = record.inVolumn > maxVolumn ? record.inVolumn : maxVolumn;    //进水量为极限
            }
        }
        
        maxVolumn = (maxVolumn == 0) ? 1 : maxVolumn;
        
        NSMutableArray* usageObjects = [NSMutableArray array];
        for (MHDataWaterPurifyRecord* record in records) {
            MHWaterUsageObject* object = [MHWaterUsageObject new];
            object.inWaterVolume = record.inVolumn;
            object.outWaterVolume = record.outVolumn;
            object.time = record.time;
            object.type = record.type;
            object.maxVolumn = maxVolumn;      //zcm 添加：进水量or出水量作为柱状图的极限
//            object.maxInVolumn = maxInVolumn;
            object.record = record;
            switch (record.type) {
                case MHWaterPurifyDailyRecord:
                    object.label = @([MHTimeUtils dayOfMonthForDate:record.time]).stringValue;
                    object.selectedLabel = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d"];
                    break;
                case MHWaterPurifyWeeklyRecord:
                    object.label = [MHTimeUtils weekAgoForDate:record.time];
                    object.selectedLabel = object.label;
                    break;
                case MHWaterPurifyMonthlyRecord:
                    object.label = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"MMM"];
                    object.selectedLabel = object.label;
                    break;
                default:
                    break;
            }
            
            [usageObjects addObject:object];
        }
        
        [self updatePurifyUsageObjects:usageObjects];
    }];
}

#pragma mark - UISegmentControl

- (void)intervalChanged:(UISegmentedControl *)control
{
    switch (control.selectedSegmentIndex) {
        case 0:
            _usageTitle.text = WaterpurifierString(@"monthly.water.usage", @"月用水详情");
            break;
        case 1:
            _usageTitle.text = WaterpurifierString(@"weekly.water.usage", @"周用水详情");
            break;
        case 2:
            _usageTitle.text = WaterpurifierString(@"daily.water.usage", @"日用水详情");
            break;
        default:
            break;
    }
    
    [self refreshPurifyRecords];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"offset X:%f", scrollView.contentOffset.x);
}

@end
