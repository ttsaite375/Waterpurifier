//
//  MHGetWaterPurifyRecordsResponse.h
//  MiHome
//
//  Created by wayne on 15/6/26.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <MiHomeInternal/MiHomeKit.h>
#import "MHDataWaterPurifyRecord.h"

@interface MHGetWaterPurifyRecordsResponse : MHBaseResponse

@property (nonatomic, retain) NSArray* records;
@property (nonatomic, retain) NSArray* filterRecords;

@end
