//
//  MHDataWaterPurifyRecord.h
//  MiHome
//
//  Created by wayne on 15/6/26.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <MiHomeInternal/MiHomeKit.h>

typedef enum : NSUInteger {
    MHWaterPurifyOnceRecord = 0,
    MHWaterPurifyDailyRecord,
    MHWaterPurifyWeeklyRecord,
    MHWaterPurifyMonthlyRecord
} MHWaterPurifyRecordType;

typedef enum : NSUInteger {
    MHWaterPurifyRecordStateIdle = 0,
    MHWaterPurifyRecordStatePurifying
} MHWaterPurifyRecordState;

@interface MHDataWaterPurifyRecord : MHDataBase

@property (nonatomic, copy) NSString* did;
@property (nonatomic, copy) NSString* uid;
@property (nonatomic, retain) NSDate* time;         //记录时间
@property (nonatomic, assign) NSInteger inVolumn;   //消耗自来水(ml)
@property (nonatomic, assign) NSInteger outVolumn;  //生成纯净水(ml)
@property (nonatomic, assign) NSInteger costTime;   //消耗时间(s)
@property (nonatomic, assign) NSInteger inTDS;      //自来水TDS
@property (nonatomic, assign) NSInteger outTDS;     //纯净水TDS
@property (nonatomic, assign) MHWaterPurifyRecordType type; //记录类型
@property (nonatomic, retain) NSArray* outTDSList;  //纯净水TDS实时变化
@property (nonatomic, assign) MHWaterPurifyRecordState state; //净水状态

@end
