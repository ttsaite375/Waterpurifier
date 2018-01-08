//
//  MHWaterTdsRecordCell.m
//  MiHome
//
//  Created by Wayne Qiao on 15/7/14.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterTdsRecordCell.h"
#import "MHDataWaterPurifyRecord.h"
#import <MiHomeInternal/MHTimeUtils.h>
#import "MHWaterpurifierDefine.h"

@implementation MHWaterTdsRecordCell
{
    UILabel* _recordTime;
    UILabel* _recordDetail;
    UIImageView* _purifyingMark;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configureWithDataObject:(MHDataWaterPurifyRecord *)record
{
    XM_WS(ws);
    if (_recordTime == nil) {
        _recordTime = [UILabel new];
        _recordTime.font = [UIFont systemFontOfSize:14.f];
        _recordTime.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        [self.contentView addSubview:_recordTime];
        [_recordTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(20.0);
            make.bottom.equalTo(ws.contentView.mas_centerY).offset(-2.0);
        }];
    }
    if (_recordDetail == nil) {
        _recordDetail = [UILabel new];
        _recordDetail.numberOfLines = 0;
        _recordDetail.font = [UIFont systemFontOfSize:12.f];
        _recordDetail.textColor = [MHColorUtils colorWithRGB:0x999999];
        [self.contentView addSubview:_recordDetail];
        [_recordDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(15.0);
            make.right.equalTo(ws.contentView).offset(0.0);
            make.top.equalTo(ws.contentView.mas_centerY).offset(2.0);
        }];
    }
    if (_purifyingMark == nil) {
        _purifyingMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waterpurifier_record_selected"]];
        [self.contentView addSubview:_purifyingMark];
        [_purifyingMark mas_makeConstraints:^(MASConstraintMaker *make) {
            XM_SS(ss, ws);
            make.right.equalTo(ss->_recordTime.mas_left).offset(-2.0);
            make.centerY.equalTo(ss->_recordTime);
        }];
    }
    
    _recordTime.text = [NSString stringWithFormat:@"开启时间:%@",[self dateStringForRecord:record]];
    
    if (record.state == MHWaterPurifyRecordStatePurifying) {
        _recordDetail.text = WaterpurifierString(@"water.purifying", @"正在制造纯水...");
    } else {
        //zcm add 修改成时/分/秒
        NSString *costTime = [self getMMSSFromSS:(int)record.costTime];
        
        if(self.isWaterPurifyLX5) {
             _recordDetail.text = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.LX5", @"用水时长%@，生成纯水%.3fL"), costTime, record.outVolumn/1000.f];
        }else {
           _recordDetail.text = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc", @"用水时长%@，生成纯水%.3fL,，消耗自来水%.3fL"), costTime, record.outVolumn/1000.f, record.inVolumn/1000.f];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _recordTime.textColor = selected ? [MHColorUtils colorWithRGB:0x00CAED] : [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _purifyingMark.hidden = !selected;
}

//- (NSString *)dateStringForRecord:(MHDataWaterPurifyRecord *)record
//{
//    return [MHTimeUtils localFormattedStringForDate:record.time dateFormat:WaterpurifierString(@"record.start.time", @"开启时间 yyyy-MM-dd HH:mm:ss")];
//}

- (NSString *)dateStringForRecord:(MHDataWaterPurifyRecord *)record
{
    NSString* dateString = nil;
    if (record.type == MHWaterPurifyOnceRecord) {
        dateString = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else if (record.type == MHWaterPurifyDailyRecord) {
        dateString = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d[EEE]"];
    }
    else if (record.type == MHWaterPurifyWeeklyRecord) {
        //        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        //        NSDate* nextSunday = [calendar dateByAddingUnit:NSCalendarUnitDay value:6 toDate:record.time options:0];
        NSDate* nextSunday = [NSDate dateWithTimeIntervalSince1970:[record.time timeIntervalSince1970] + 3600*24*6];
        dateString = [NSString stringWithFormat:@"%@-%@",
                      [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d[EEE]"],
                      [MHTimeUtils localFormattedStringForDate:nextSunday dateFormat:@"M/d"]];
    }
    else if (record.type == MHWaterPurifyMonthlyRecord) {
        // not in use
    }
    
    return dateString;
}

//zcm add :传入 秒  得到  xx分xx秒
- (NSString *)getMMSSFromSS:(NSInteger )seconds
{
    if(seconds < 60) {
        NSString *format_time = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.sec", @"%i秒"),seconds];
        return format_time;
    }else if(seconds <3600 ){
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.min", @"%i分"),seconds/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.sec", @"%i秒"),seconds%60];
        //format of time
        NSString *format_time = [NSString stringWithFormat:@"%@%@",str_minute,str_second];
        return format_time;
    }else {
        //format of hour
        NSString *str_hour = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.h", @"%i时"), seconds/3600];
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.min", @"%i分"),(seconds%3600)/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.sec", @"%i秒"),seconds%60];
        NSString *format_time = [NSString stringWithFormat:@"%@%@%@",str_hour,str_minute,str_second];
        return format_time;
    }
}

@end
