//
//  MHWaterPurifyRecordCell.m
//  MiHome
//
//  Created by wayne on 15/6/29.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterPurifyRecordCell.h"
#import "MHDataWaterPurifyRecord.h"
#import <MiHomeInternal/MHTimeUtils.h>
#import "MHWaterpurifierDefine.h"


@implementation MHWaterPurifyRecordCell
{
    UILabel* _recordTime;
    UILabel* _recordDetail;
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
        _recordTime.textColor = [UIColor whiteColor];
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
        _recordDetail.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self.contentView addSubview:_recordDetail];
        [_recordDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(10.0);
            make.right.equalTo(ws.contentView).offset(0.0);
            make.top.equalTo(ws.contentView.mas_centerY).offset(2.0);
        }];
    }
    
    //ZCM add 修改成时分秒
    NSString *costTime = [self getMMSSFromSS:(int)record.costTime];
    
    if(self.isWaterPurifyLX5) {
        _recordTime.text = [self dateStringForRecord:record];
        _recordDetail.text = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc.LX5", @"用水时长%@，生成纯水%.1fL"), costTime, record.outVolumn/1000.f];
    }else {
        _recordTime.text = [self dateStringForRecord:record];
        _recordDetail.text = [NSString stringWithFormat:WaterpurifierString(@"purify.record.desc", @"用水时长%@，生成纯水%.1fL，消耗自来水%.1fL"), costTime, record.outVolumn/1000.f, record.inVolumn/1000.f];
    }
}

- (NSString *)dateStringForRecord:(MHDataWaterPurifyRecord *)record
{
    NSString* dateString = nil;
    if (record.type == MHWaterPurifyOnceRecord) {
        dateString = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"HH:mm:ss"];
    }
    else if (record.type == MHWaterPurifyDailyRecord) {
        dateString = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d[EEE]"];
    }
    else if (record.type == MHWaterPurifyWeeklyRecord) {
////        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
////        NSDate* nextSunday = [calendar dateByAddingUnit:NSCalendarUnitDay value:6 toDate:record.time options:0];
        
//        NSDate* nextSunday = [NSDate dateWithTimeIntervalSince1970:[record.time timeIntervalSince1970] + 3600*24*6];
        
//        dateString = [NSString stringWithFormat:@"%@-%@",
//                      [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d[EEE]"],
//                      [MHTimeUtils localFormattedStringForDate:nextSunday dateFormat:@"M/d"]];
        
        NSDate *sunday = [self nextSundayWhichContainsDate:record.time];
        
        if(sunday) {
            dateString = [NSString stringWithFormat:@"%@-%@",
                          [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d[EEE]"],
                          [MHTimeUtils localFormattedStringForDate:sunday dateFormat:@"M/d"]];
        }else {
            dateString = [MHTimeUtils localFormattedStringForDate:record.time dateFormat:@"M/d[EEE]"];
        }
    }
    else if (record.type == MHWaterPurifyMonthlyRecord) {
        // not in use
    }
    
    return dateString;
}

- (NSDate *)nextSundayWhichContainsDate:(NSDate *)date
{
    NSDate *sunday = [NSDate dateWithTimeInterval:3600 * 24
                                            sinceDate:[MHTimeUtils lastDayOfWeekWhichContainsDate:[MHTimeUtils yesterdayForDate:date]]];
    
    NSDate *today = [NSDate dateWithTimeInterval: - 3600 * 8 sinceDate:[NSDate date]]; //UTC的today

    NSDate *lastDayOfMonth = [MHTimeUtils lastDayOfMonthWhichContainsDate:date];
    
    if([sunday timeIntervalSince1970] > [today timeIntervalSince1970]) {
        sunday = today;
    }
    
    if([sunday timeIntervalSince1970] > [lastDayOfMonth timeIntervalSince1970]) {
        sunday = lastDayOfMonth;
    }
    
    if([date timeIntervalSince1970] == [sunday timeIntervalSince1970]) {
        sunday = nil; //显示 eg：10/1
    }
    
    return sunday;
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
