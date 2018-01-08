//
//  MHWaterpurifierTDSViewController.m
//  MiHome
//
//  Created by wayne on 15/7/2.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterpurifierTDSViewController.h"
#import "MHWaterTDSCurveDiagram.h"
#import "MHWaterTdsRecordCell.h"
#import <MiHomeInternal/MHTicker.h>
//#import "MHTicker.h"
#import "MHWaterpurifierDefine.h"

//#import "MHDeviceWaterPurifierLX.h"

@interface MHWaterpurifierTDSViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MHWaterpurifierTDSViewController
{
    MHWaterTDSCurveDiagram* _diagram;   //曲线图
    UITableView* _onceRecordsTable;     //净水记录列表
    NSArray* _onceRecords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WaterpurifierString(@"water.tds.curve", @"水质（TDS值）曲线");
    self.isTabBarHidden = YES;
    self.isNavBarTranslucent = YES;
    
    XM_WS(weakself);
    [self.waterpurifier getOncePurifyRecordsForTime:[NSDate date] completion:^(NSArray *records) {
        XM_SS(strongself, weakself);
        if ([records count] > 0) {
            strongself->_onceRecords = records;
            [strongself->_onceRecordsTable reloadData];
            [strongself->_onceRecordsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            strongself->_diagram.record = [records objectAtIndex:0];
            [strongself->_diagram animationCurveFadeIn];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startPollPurifyingRecord];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopPollPurifyingRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define kRecordCellId @"RecordCellId"
- (void)buildSubviews {
    _diagram = [MHWaterTDSCurveDiagram new];
    _diagram.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_diagram];
    
    //ZCM add 米二代将不显示自来水水质，添加flag
    if([_waterpurifier.model isEqualToString:DeviceModelWaterPuriLX5]) {
        _diagram.isWaterPurifyLX5 = YES;
    }else {
        _diagram.isWaterPurifyLX5 = NO;
    }
    
    _onceRecordsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _onceRecordsTable.backgroundColor = [UIColor clearColor];
    _onceRecordsTable.dataSource = self;
    _onceRecordsTable.delegate = self;
    _onceRecordsTable.rowHeight = 68.0;
    [_onceRecordsTable registerClass:[MHWaterTdsRecordCell class] forCellReuseIdentifier:kRecordCellId];
    _onceRecordsTable.tableFooterView = [UIView new];
    [self.view addSubview:_onceRecordsTable];
}

- (void)buildConstraints {
    XM_WS(weakself);
    [_diagram mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, CGRectGetHeight(weakself.view.bounds)*0.3, 0));
    }];
    
    [_onceRecordsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(CGRectGetHeight(weakself.view.bounds)*0.7, 0, 0, 0));
    }];
}

// 只处理并反映正在净水的记录的变化，不关心其他净水记录
#define kPollPurifyingRecordTaskID @"PollPurifyingRecordTask"
- (void)startPollPurifyingRecord
{
    XM_WS(weakself);
    [[MHTicker sharedInstance] addTaskWithIdentifier:kPollPurifyingRecordTaskID delay:3 repeat:YES onMainThread:YES block:^{
        [weakself.waterpurifier getOncePurifyRecordsForTime:[NSDate date] completion:^(NSArray *records) {
            NSLog(@"...poll once record");
            XM_SS(strongself, weakself);
            if ([records count] > 0) {
//                strongself->_onceRecords = records;
//                [strongself->_onceRecordsTable reloadData];
                
                MHDataWaterPurifyRecord* record = [records objectAtIndex:0];
                if (record.state == MHWaterPurifyRecordStatePurifying &&
                    [strongself->_onceRecordsTable indexPathForSelectedRow].row == 0)
                {
                    strongself->_diagram.record = record;
                }
            }
        }];
    }];
}

- (void)stopPollPurifyingRecord
{
    [[MHTicker sharedInstance] removeTaskWithIdentifier:kPollPurifyingRecordTaskID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_onceRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHWaterTdsRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:kRecordCellId forIndexPath:indexPath];
    
    cell.isWaterPurifyLX5 = [_waterpurifier.model isEqualToString: DeviceModelWaterPuriLX5];
    
    [cell configureWithDataObject:[_onceRecords objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _diagram.record = [_onceRecords objectAtIndex:indexPath.row];
    [_diagram animationCurveFadeIn];
}

@end
