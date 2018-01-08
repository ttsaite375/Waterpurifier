//
//  MHWaterPurifyStatisticView.m
//  MiHome
//
//  Created by wayne on 15/6/29.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterPurifyStatisticView.h"
#import "MHWaterPurifyRecordCell.h"
#import "MHWaterUsageChart.h"

#define kRecordCellId @"RecordCellId"

@interface MHWaterPurifyStatisticView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MHWaterPurifyStatisticView
{
    MHWaterUsageChart* _usageChart; //用水统计图
    UITableView* _purifyList;   //净水记录列表
    
    NSArray* _purifyRecords;    //净水记录
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildSubviews];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)buildSubviews
{
    XM_WS(weakself);
    _usageChart = [MHWaterUsageChart new];
    _usageChart.recordSelectedHandler = ^(MHWaterUsageObject *object) {
    
        XM_SS(strongself, weakself);
        
//        if (object.type == MHWaterPurifyDailyRecord ||
//            object.type == MHWaterPurifyWeeklyRecord ||
//            object.type == MHWaterPurifyMonthlyRecord) {
//            [weakself.device getSubPurifyRecordsForRecord:object.record completion:^(NSArray *records) {
//                strongself->_purifyRecords = records;
//                [strongself->_purifyList reloadData];
//                [weakself invalidateIntrinsicContentSize];
//                [weakself setNeedsLayout];
//            }];
//        }
        
        if (object.type == MHWaterPurifyDailyRecord ||
            object.type == MHWaterPurifyWeeklyRecord ||
            object.type == MHWaterPurifyMonthlyRecord) {
            
            //zcm 米二代 不展示日详情
            if([weakself.device.model isEqualToString:DeviceModelWaterPuriLX5] &&
               object.type == MHWaterPurifyDailyRecord ) {
                
                strongself->_purifyRecords = [NSArray array];
                [strongself->_purifyList reloadData];
                [weakself invalidateIntrinsicContentSize];
                [weakself setNeedsLayout];
            }else {
                [weakself.device getSubPurifyRecordsForRecord:object.record completion:^(NSArray *records) {
                    strongself->_purifyRecords = records;
                    [strongself->_purifyList reloadData];
                    [weakself invalidateIntrinsicContentSize];
                    [weakself setNeedsLayout];
                }];
            }
        }
    };
    
    [self addSubview:_usageChart];
    
    [_usageChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(313.0);
    }];
    
    _purifyList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _purifyList.backgroundColor = [UIColor clearColor];
    _purifyList.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    _purifyList.scrollEnabled = NO;
    _purifyList.dataSource = self;
    _purifyList.delegate = self;
    _purifyList.rowHeight = 64.0;
    _purifyList.tableFooterView = [UIView new];
    [_purifyList registerClass:[MHWaterPurifyRecordCell class] forCellReuseIdentifier:kRecordCellId];
    [self addSubview:_purifyList];
    
    [_purifyList mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.top.equalTo(strongself->_usageChart.mas_bottom);
        make.left.right.bottom.equalTo(weakself);
    }];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(CGRectGetWidth(_purifyList.frame), 64.0*[_purifyRecords count] + 313.0);
}

- (void)refreshPurifyStatisticData
{
    _usageChart.device = self.device;
    [_usageChart refreshPurifyRecords];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_purifyRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHWaterPurifyRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:kRecordCellId forIndexPath:indexPath];
    
    cell.isWaterPurifyLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
    
    if (indexPath.row < [_purifyRecords count]) {
        [cell configureWithDataObject:[_purifyRecords objectAtIndex:indexPath.row]];
    }
    return cell;
}

@end
