//
//  MHGetWaterPurifyRecordsRequest.h
//  MiHome
//
//  Created by wayne on 15/6/26.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <MiHomeInternal/MiHomeKit.h>
#import "MHDeviceWaterpurifier.h"

@interface MHGetWaterPurifyRecordsRequest : MHBaseRequest

@property (nonatomic, copy) NSString* did;
@property (nonatomic, assign) MHWaterPurifyRecordType type;
@property (nonatomic, assign) NSTimeInterval timeStart;
@property (nonatomic, assign) NSTimeInterval timeEnd;
@property (nonatomic, assign) NSInteger limit;

@end
