//
//  MHDataWaterPurifyRecord.m
//  MiHome
//
//  Created by wayne on 15/6/26.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHDataWaterPurifyRecord.h"

@implementation MHDataWaterPurifyRecord

+ (instancetype)dataWithJSONObject:(id)object
{
    MHDataWaterPurifyRecord* record = [super dataWithJSONObject:object];
    record.did = [object objectForKey:@"did" class:[NSString class]];
    record.uid = [object objectForKey:@"uid" class:[NSString class]];
    record.time = [NSDate dateWithTimeIntervalSince1970:[[object objectForKey:@"time" class:[NSNumber class]] doubleValue]];
    NSString* key = [object objectForKey:@"key" class:[NSString class]];
    NSString* value = [object objectForKey:@"value" class:[NSString class]];
    value = [value substringWithRange:NSMakeRange(1, [value length]-2)]; //去掉[]
    NSArray* valueList = [value componentsSeparatedByString:@","];
    if ([key isEqualToString:@"once_record"] && [valueList count] == 7)
    {
        record.inVolumn = ABS([[valueList objectAtIndex:0] integerValue]);
        record.outVolumn = ABS([[valueList objectAtIndex:1] integerValue]);
        record.costTime = ABS([[valueList objectAtIndex:2] integerValue]);
        record.inTDS = ABS([[valueList objectAtIndex:3] integerValue]);
        record.outTDS = ABS([[valueList objectAtIndex:4] integerValue]);
        NSString* stateString = [valueList objectAtIndex:5];
        NSString* state = [stateString substringWithRange:NSMakeRange(1, stateString.length-2)]; //去掉""
        if ([state isEqualToString:@"idle"]) {
            record.state = MHWaterPurifyRecordStateIdle;
        } else if ([state isEqualToString:@"purifying"]) {
            NSInteger timePassed = [[NSDate date] timeIntervalSince1970] - [record.time timeIntervalSince1970];
            if (timePassed - record.costTime > 15) { //还需要通过时间，检查实际上是否已经停止制水
                record.state = MHWaterPurifyRecordStateIdle;
            } else {
                record.state = MHWaterPurifyRecordStatePurifying;
            }
        }
        NSString* outTDSData = [valueList objectAtIndex:6];
        outTDSData = [outTDSData substringWithRange:NSMakeRange(1, outTDSData.length-2)]; //去掉""
        record.outTDSList = [outTDSData componentsSeparatedByString:@"-"];
        record.type = MHWaterPurifyOnceRecord;
    }
    else if ([key isEqualToString:@"daily_record"] && ([valueList count] == 3))
    {
        record.inVolumn = ABS([[valueList objectAtIndex:0] integerValue]);
        record.outVolumn = ABS([[valueList objectAtIndex:1] integerValue]);
        record.costTime = ABS([[valueList objectAtIndex:2] integerValue]);
        record.type = MHWaterPurifyDailyRecord;
    }
    else if ([key isEqualToString:@"weekly_record"] && ([valueList count] == 3))
    {
        record.inVolumn = ABS([[valueList objectAtIndex:0] integerValue]);
        record.outVolumn = ABS([[valueList objectAtIndex:1] integerValue]);
        record.costTime = ABS([[valueList objectAtIndex:2] integerValue]);
        record.type = MHWaterPurifyWeeklyRecord;
    }
    else if ([key isEqualToString:@"monthly_record"] && ([valueList count] == 3))
    {
        record.inVolumn = ABS([[valueList objectAtIndex:0] integerValue]);
        record.outVolumn = ABS([[valueList objectAtIndex:1] integerValue]);
        record.costTime = ABS([[valueList objectAtIndex:2] integerValue]);
        record.type = MHWaterPurifyMonthlyRecord;
    }
    return record;
}

@end
