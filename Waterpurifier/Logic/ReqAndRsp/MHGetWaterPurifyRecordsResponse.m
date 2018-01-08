//
//  MHGetWaterPurifyRecordsResponse.m
//  MiHome
//
//  Created by wayne on 15/6/26.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHGetWaterPurifyRecordsResponse.h"

@implementation MHGetWaterPurifyRecordsResponse

+ (instancetype)responseWithJSONObject:(id)object
{
    MHGetWaterPurifyRecordsResponse* response = [super responseWithJSONObject:object];
    
    NSArray* result = [object objectForKey:@"result" class:[NSArray class]];
    response.records = [MHDataWaterPurifyRecord dataListWithJSONObjectList:result];
    NSMutableArray* filterRecords = [NSMutableArray array];
    for (MHDataWaterPurifyRecord* record in response.records) {
        if (record.state == MHWaterPurifyRecordStateIdle) {
            [filterRecords addObject:record];
        }
    }
    response.filterRecords = filterRecords;
    
    return response;
}

@end
