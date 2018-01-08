//
//  MHGetWaterPurifyRecordsRequest.m
//  MiHome
//
//  Created by wayne on 15/6/26.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHGetWaterPurifyRecordsRequest.h"

@implementation MHGetWaterPurifyRecordsRequest

- (NSString *)api
{
    return @"/user/get_user_device_data";
}

- (id)jsonObject
{
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    if (self.did) {
        [json setObject:self.did forKey:@"did"];
    }
    [json setObject:@(self.timeStart) forKey:@"time_start"];
    [json setObject:@(self.timeEnd) forKey:@"time_end"];
    [json setObject:@"event" forKey:@"type"];
    switch (self.type) {
        case MHWaterPurifyOnceRecord:
            [json setObject:@"once_record" forKey:@"key"];
            break;
        case MHWaterPurifyDailyRecord:
            [json setObject:@"daily_record" forKey:@"key"];
            break;
        case MHWaterPurifyWeeklyRecord:
            [json setObject:@"weekly_record" forKey:@"key"];
            break;
        case MHWaterPurifyMonthlyRecord:
            [json setObject:@"monthly_record" forKey:@"key"];
            break;
        default:
            break;
    }
    
    [json setObject:@(self.limit) forKey:@"limit"];
    return json;
}

@end
