//
//  MHDeviceWaterpurifier.m
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHDeviceWaterpurifier.h"
#import "MHStrongBox.h"
#import "MHGetWaterPurifyRecordsRequest.h"
#import "MHGetWaterPurifyRecordsResponse.h"
#import <MiHomeInternal/MHGetDeviceSceneNewRequest.h>
#import <MiHomeInternal/MHGetDeviceSceneNewResponse.h>
#import <MiHomeInternal/MHEditDeviceSceneNewRequest.h>
#import <MiHomeInternal/MHEditDeviceSceneNewResponse.h>
#import <MiHomeInternal/MHTimeUtils.h>

@implementation MHDeviceWaterpurifier

+ (instancetype)deviceWithData:(MHDataDevice* )data {
    MHDeviceWaterpurifier* purifier = [[MHDeviceWaterpurifier alloc] initWithData:data];
    return purifier;
}

- (id)initWithData:(MHDataDevice* )data {
    if (self = [super initWithData:data]) {
        // martes: 2015-10-15 follow android，把所有的设备绑定都改成不需要按键确认，走mdata
        self.deviceBindPattern = /*MHDeviceBind_NeedCheck*/ MHDeviceBind_WithoutCheck;
        self.isNeedAutoBindAfterDiscovery = YES;
        if (self.prop) {
            
        }
        if (self.extra && [self.extra isKindOfClass:[NSDictionary class]]) {
            
        }
        self.deviceConnectPattern = MHDeviceConnect_Both;
        self.permissionControl = 1;
        self.wexinShare = 1;
    }
    return self;
}

//MHDevice类，子类重写，目前有（初代、2代）注册设备信息，
+ (void)load {
//    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPurifier className:NSStringFromClass([MHDeviceWaterpurifier class]) isRegisterBase:YES];
//    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPurifierV3 className:NSStringFromClass([MHDeviceWaterpurifier class]) isRegisterBase:YES];
//
//    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX2 className:NSStringFromClass([MHDeviceWaterpurifier class]) isRegisterBase:YES];
//    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX3 className:NSStringFromClass([MHDeviceWaterpurifier class]) isRegisterBase:YES];
//    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX4 className:NSStringFromClass([MHDeviceWaterpurifier class]) isRegisterBase:YES];
}

+ (NSUInteger)getDeviceType {
    return MHDeviceType_WaterPurifier;
}

+ (NSString* )largeIconNameOfStatus:(MHDeviceStatus)status {
    return @"device_icon_waterpurifier";
}

+ (NSString* )smallIconName {
    return @"waterpurifier_small_icon";
}

+ (NSString* )guideImageNameOfOnline:(BOOL)isOnline {
    return isOnline ? @"waterpurifier_guide_on" : @"waterpurifier_guide_off";
}

+ (NSString* )guideLargeImageNameOfOnline:(BOOL)isOnline {
    return isOnline ? @"waterpurifier_guide_on" : @"waterpurifier_guide_off";
}

+ (NSString* )shareImageName {
    return @"waterpurifier_share_icon";
}

//MHDevice 类，子类重写，设备发射WiFi名称
+ (NSString* )uapWifiNamePrefix:(BOOL)isNewVersion {
    if (isNewVersion) {
        return @"MI-Water Purifier";
    } else {
        return @"yunmi-waterpuri";
    }
}

+ (NSString* )defaultName {
    return NSLocalizedString(@"waterpurifier","小米净水器");
}

//MHDevice 类，子类重写，允许在设备列表展示
+ (BOOL)isDeviceAllowedToShown {
    return YES;
}

- (BOOL)isShownInQuickConnectList {
    return YES;
}

+ (NSString* )getViewControllerClassName {
    return @"MHWaterpurifierViewController";
}

+ (NSString* )quickConnectGuideVideoUrl {
    return @"http://v.youku.com/v_show/id_XODYwNTMxMjIw.html";
}

//MHDevice类，子类重写，返回请求json
- (NSDictionary *)getStatusRequestPayload {
    NSMutableDictionary* jason = [[NSMutableDictionary alloc] init];
    [jason setObject:@(1) forKey:@"id"];
    [jason setObject:@"get_prop" forKey:@"method"];
    NSMutableArray *array = [@[] mutableCopy];
    [jason setObject:array forKey:@"params"];
    
    return jason;
}

//MHDevice 类，子类重写，请求设备信息成功后会首先来到这里WTF
- (BOOL)parseGetStatusResponse:(id)response {
    MHDeviceRPCResponse* rsp = [MHDeviceRPCResponse responseWithJSONObject:response];
    if ([response isKindOfClass:[MHSafeDictionary class]])
    {
        rsp.request = [response objectForKey:@"request" class:[MHBaseRequest class]];
    }
    
    //NSLog(@"rsp.resultList:%@",rsp.resultList);
    
    
    if (rsp.code == MHNetworkErrorOk) {
        
//        MHStrongBox *strongBox = [[MHStrongBox alloc] init];
//        [rsp.resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [strongBox setValue:obj forKey:[NSString stringWithFormat:@"%lu", (unsigned long)idx]];
//        }];
//        
////        self.tTds = [[strongBox valueForKey:@"0" class:[NSNumber class]] integerValue];
////        self.pTds = [[strongBox valueForKey:@"1" class:[NSNumber class]] integerValue];
//        self.oneUsedFlow = [[strongBox valueForKey:@"2" class:[NSNumber class]] integerValue];
//        self.oneUsedTime = [[strongBox valueForKey:@"3" class:[NSNumber class]] integerValue];
//        self.twoUsedFlow = [[strongBox valueForKey:@"4" class:[NSNumber class]] integerValue];
//        self.twoUsedTime = [[strongBox valueForKey:@"5" class:[NSNumber class]] integerValue];
//        self.threeUsedFlow = [[strongBox valueForKey:@"6" class:[NSNumber class]] integerValue];
//        self.threeUsedTime = [[strongBox valueForKey:@"7" class:[NSNumber class]] integerValue];
//        self.fourUsedFlow = [[strongBox valueForKey:@"8" class:[NSNumber class]] integerValue];
//        self.fourUsedTime = [[strongBox valueForKey:@"9" class:[NSNumber class]] integerValue];
//        self.oneTotalFlow = [[strongBox valueForKey:@"10" class:[NSNumber class]] integerValue];
//        self.oneTotalTime = [[strongBox valueForKey:@"11" class:[NSNumber class]] integerValue];
//        self.twoTotalFlow = [[strongBox valueForKey:@"12" class:[NSNumber class]] integerValue];
//        self.twoTotalTime = [[strongBox valueForKey:@"13" class:[NSNumber class]] integerValue];
//        self.threeTotalFlow = [[strongBox valueForKey:@"14" class:[NSNumber class]] integerValue];
//        self.threeTotalTime = [[strongBox valueForKey:@"15" class:[NSNumber class]] integerValue];
//        self.fourTotalFlow = [[strongBox valueForKey:@"16" class:[NSNumber class]] integerValue];
//        self.fourTotalTime = [[strongBox valueForKey:@"17" class:[NSNumber class]] integerValue];
//        self.status = [[strongBox valueForKey:@"18" class:[NSNumber class]] integerValue];
//        self.isOpenDisplay = [[strongBox valueForKey:@"19" class:[NSNumber class]] integerValue];
//        
//        self.apiVersion = [[strongBox valueForKey:@"21" class:[NSNumber class]] integerValue];
//        
////        self.apiVersion = 0;
////        self.status = 0xC003;
////        self.oneUsedFlow = 3600;
////        self.twoUsedTime = 4320;
//        self.exceptions = [self parseExceptionStatus:self.status];
        
        [self changeStatus:rsp.resultList];
        
        NSString *deviceId = self.did;
        NSString *statuskey = [NSString stringWithFormat:@"ym_filterStatus_%@",deviceId];
        [[NSUserDefaults standardUserDefaults] setObject:rsp.resultList forKey:statuskey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return YES;
    }
    
    return NO;
}

//zcm 处理净水器基础数据
- (void)changeStatus:(NSArray *)list
{
    MHStrongBox *strongBox = [[MHStrongBox alloc] init];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strongBox setValue:obj forKey:[NSString stringWithFormat:@"%lu", (unsigned long)idx]];
    }];
    
    //zcm 米二代数据模型，先用着假的
    if([self.model isEqualToString:DeviceModelWaterPuriLX5]) {
        self.tTds = 192; //米二代接口没有返回自来水水质，写死297
        self.pTds = [[strongBox valueForKey:@"0" class:[NSNumber class]] integerValue];
        self.inTemperature = [[strongBox valueForKey:@"1" class:[NSNumber class]] integerValue];
        
        self.oneTotalFlow = [[strongBox valueForKey:@"2" class:[NSNumber class]] integerValue];
        self.oneTotalTime = [[strongBox valueForKey:@"3" class:[NSNumber class]] integerValue];
        self.oneUsedFlow = [[strongBox valueForKey:@"4" class:[NSNumber class]] integerValue];
        self.oneUsedTime = [[strongBox valueForKey:@"5" class:[NSNumber class]] integerValue];
        
        self.twoTotalFlow = [[strongBox valueForKey:@"6" class:[NSNumber class]] integerValue];
        self.twoTotalTime = [[strongBox valueForKey:@"7" class:[NSNumber class]] integerValue];
        self.twoUsedFlow = [[strongBox valueForKey:@"8" class:[NSNumber class]] integerValue];
        self.twoUsedTime = [[strongBox valueForKey:@"9" class:[NSNumber class]] integerValue];
        
        self.status = [[strongBox valueForKey:@"10" class:[NSNumber class]] integerValue];
        self.tdsWarnVal = [[strongBox valueForKey:@"11" class:[NSNumber class]] integerValue];
        self.tdsOutAvg = [[strongBox valueForKey:@"12" class:[NSNumber class]] integerValue];
        self.rinsing = [[strongBox valueForKey:@"13" class:[NSNumber class]] integerValue];
        
        //如果warn 在[avg -50, avr + 50]这个范围内 就按照[avg -50, avr + 50] 这个来设置，
        //如果不在这个范围内 warn < avg - 50  就按照 [warn, avg + 50]这个范围，
        //warn > avg + 50 就按照[ avg - 50, warn]这个范围
        //这个范围最终是[50, 300]
        //tdsOutAvg: (~,100)
        self.tdsOutAvg = self.tdsOutAvg < 100 ? 50 : self.tdsOutAvg;
        //tdsOutAvg: (250, ~)
        self.tdsOutAvg = self.tdsOutAvg > 200 ? 250 : self.tdsOutAvg;
        //不低于50
        self.tdsWarnVal = self.tdsWarnVal < 50 ? 50 : self.tdsWarnVal;
        //不高于300
        self.tdsWarnVal = self.tdsWarnVal > 300 ? 300 : self.tdsWarnVal;
        
        //第一次启动机器，pTds将会是10000，那么直接跳到tdsWarnVal对应的值
        if(self.pTds >= 10000) {
            self.pTds = self.tdsWarnVal;
        }
        
    }else {
        //zcm 米一代数据模型
        self.tTds = [[strongBox valueForKey:@"0" class:[NSNumber class]] integerValue];
        self.pTds = [[strongBox valueForKey:@"1" class:[NSNumber class]] integerValue];
        
        self.oneUsedFlow = [[strongBox valueForKey:@"2" class:[NSNumber class]] integerValue];
        self.oneUsedTime = [[strongBox valueForKey:@"3" class:[NSNumber class]] integerValue];
        self.twoUsedFlow = [[strongBox valueForKey:@"4" class:[NSNumber class]] integerValue];
        self.twoUsedTime = [[strongBox valueForKey:@"5" class:[NSNumber class]] integerValue];
        self.threeUsedFlow = [[strongBox valueForKey:@"6" class:[NSNumber class]] integerValue];
        self.threeUsedTime = [[strongBox valueForKey:@"7" class:[NSNumber class]] integerValue];
        self.fourUsedFlow = [[strongBox valueForKey:@"8" class:[NSNumber class]] integerValue];
        self.fourUsedTime = [[strongBox valueForKey:@"9" class:[NSNumber class]] integerValue];
        
        self.oneTotalFlow = [[strongBox valueForKey:@"10" class:[NSNumber class]] integerValue];
        self.oneTotalTime = [[strongBox valueForKey:@"11" class:[NSNumber class]] integerValue];
        self.twoTotalFlow = [[strongBox valueForKey:@"12" class:[NSNumber class]] integerValue];
        self.twoTotalTime = [[strongBox valueForKey:@"13" class:[NSNumber class]] integerValue];
        self.threeTotalFlow = [[strongBox valueForKey:@"14" class:[NSNumber class]] integerValue];
        self.threeTotalTime = [[strongBox valueForKey:@"15" class:[NSNumber class]] integerValue];
        self.fourTotalFlow = [[strongBox valueForKey:@"16" class:[NSNumber class]] integerValue];
        self.fourTotalTime = [[strongBox valueForKey:@"17" class:[NSNumber class]] integerValue];
        
        self.status = [[strongBox valueForKey:@"18" class:[NSNumber class]] integerValue];
        
        self.apiVersion = [[strongBox valueForKey:@"21" class:[NSNumber class]] integerValue];
        
        self.rinsing = [[strongBox valueForKey:@"22" class:[NSNumber class]] integerValue];
        
    }
    
    self.exceptions = [self parseExceptionStatus:self.status];   //status 只返回1-16号信息
    
    //lsl 修改： lx4才有冲洗
    if ([self.model isEqualToString:DeviceModelWaterPuriLX4]) {
        [self getWashData];
    }
    
}

//zcm 根据status解析故障信息
- (NSDictionary *)parseExceptionStatus:(NSInteger)status
{
    NSMutableDictionary* exceptions = [NSMutableDictionary dictionary];
    
    for (int i=0; i<MHDeviceWaterpurifierException16; i++) {
        NSInteger bitMask = 1 << i;
        NSLog(@"%ld", (long)bitMask);
        if (status & bitMask) {
            [exceptions setObject:@(YES) forKey:@(i+1)];
        }
    }
    
    //zcm 米二代滤芯状态解析
    if([self.model isEqualToString:DeviceModelWaterPuriLX5]) {
        
        //zcm 米二代滤芯寿命耗尽
        CGFloat oneFilterLife = [self filterLifePercentWithUsedTime:self.oneUsedTime
                                                          totalTime:self.oneTotalTime
                                                           usedFlow:self.oneUsedFlow
                                                          totalFlow:self.oneTotalFlow];
        if (oneFilterLife == 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterOneExhausted)];
        }
        
        CGFloat twoFilterLife = [self filterLifePercentWithUsedTime:self.twoUsedTime
                                                          totalTime:self.twoTotalTime
                                                           usedFlow:self.twoUsedFlow
                                                          totalFlow:self.twoTotalFlow];
        if (twoFilterLife == 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterTwoExhausted)];
        }
        
        //zcm 米二代添加快到期提醒 时间改为15
        NSInteger days1 = (NSInteger)(self.oneTotalTime - self.oneUsedTime)/24;
        if (days1 <= 15 && days1 > 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterOneExhausteWill)];
        }
        
        NSInteger days2 = (NSInteger)(self.twoTotalTime - self.twoUsedTime)/24;
        if (days2 <= 15  && days2 > 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterTwoExhausteWill)];
        }
        
    }else {
        //zcm 米一代状态滤芯状态解析
        //zcm 米一代滤芯寿命耗尽
        CGFloat oneFilterLife = [self filterLifePercentWithUsedTime:self.oneUsedTime
                                                          totalTime:self.oneTotalTime
                                                           usedFlow:self.oneUsedFlow
                                                          totalFlow:self.oneTotalFlow];
        if (oneFilterLife == 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterOneExhausted)];
        }
        
        CGFloat twoFilterLife = [self filterLifePercentWithUsedTime:self.twoUsedTime
                                                          totalTime:self.twoTotalTime
                                                           usedFlow:self.twoUsedFlow
                                                          totalFlow:self.twoTotalFlow];
        if (twoFilterLife == 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterTwoExhausted)];
        }
        
        CGFloat threeFilterLife = [self filterLifePercentWithUsedTime:self.threeUsedTime
                                                            totalTime:self.threeTotalTime
                                                             usedFlow:self.threeUsedFlow
                                                            totalFlow:self.threeTotalFlow];
        if (threeFilterLife == 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterThreeExhausted)];
        }
        
        CGFloat fourFilterLife = [self filterLifePercentWithUsedTime:self.fourUsedTime
                                                           totalTime:self.fourTotalTime
                                                            usedFlow:self.fourUsedFlow
                                                           totalFlow:self.fourTotalFlow];
        if (fourFilterLife == 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterFourExhausted)];
        }
        
        //lsl 米一代添加快到期提醒 修改快到期时间15天
        NSInteger days1 = (NSInteger)(self.oneTotalTime - self.oneUsedTime)/24;
        if (days1 <= 15 && days1 > 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterOneExhausteWill)];
        }
        
        NSInteger days2 = (NSInteger)(self.twoTotalTime - self.twoUsedTime)/24;
        if (days2 <= 15  && days2 > 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterTwoExhausteWill)];
        }
        
        NSInteger days3 = (NSInteger)(self.threeTotalTime - self.threeUsedTime)/24;
        if (days3 <= 15  && days3 > 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterThreeExhausteWill)];
        }
        
        NSInteger days4 = (NSInteger)(self.fourTotalTime - self.fourUsedTime)/24;
        if (days4 <= 15  && days4 > 0) {
            [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierFilterFourExhausteWill)];
        }

    }
    //介绍过将不再展示~
    if (![self isTapLedUsageIntroduced]) {
        [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierTapLEDIntro)];
    }
    
    
    if(self.rinsing) {
        [exceptions setObject:@(YES) forKey:@(MHDeviceWaterpurifierRinsing)];
    }
    
    //wash
    //lx4才有冲洗
//    self.washHours = 72;
//    self.status = 0;
    if ([self.model isEqualToString:DeviceModelWaterPuriLX4]) {
        //暂时改24
        if (self.washHours >= 72 && self.status != 1) {
            NSInteger days = self.washHours/24;
            [exceptions setObject:@(days) forKey:@(MHDeviceWaterpurifierWash)];
        }
    }

    return [NSDictionary dictionaryWithDictionary:exceptions];
}

- (CGFloat)filterLifePercentWithUsedTime:(NSInteger)usedTime
                               totalTime:(NSInteger)totalTime
                                usedFlow:(NSInteger)usedFlow
                               totalFlow:(NSInteger)totalFlow
{
    CGFloat timePercent = (CGFloat)(totalTime - usedTime) / totalTime;
    CGFloat flowPercent = (CGFloat)(totalFlow - usedFlow) / totalFlow;
    if (self.apiVersion == 1 || [self.model isEqualToString:@"yunmi.waterpurifier.v3"]) {
        flowPercent = CGFLOAT_MAX;
    }
    
    //zcm add 米二代 只根据用水时间来计算滤芯寿命
    if([self.model isEqualToString:DeviceModelWaterPuriLX5]) {
        flowPercent = CGFLOAT_MAX;
    }
    
    CGFloat lifePercent = timePercent < flowPercent ? timePercent : flowPercent;
    if (lifePercent < 0) {
        lifePercent = 0;
    }
    return lifePercent;
}

#define kWaterPurifierTapLEDIntroKey @"WaterPurifierTapLEDIntroKey"
- (BOOL)isTapLedUsageIntroduced
{
//#ifdef APP_DEVELOPMENT
//    return NO;
//#endif
    NSString* introKey = [NSString stringWithFormat:@"%@_%@", self.did, kWaterPurifierTapLEDIntroKey];
    id isIntro = [[NSUserDefaults standardUserDefaults] objectForKey:introKey];
    if (isIntro) {
        return [isIntro boolValue];
    } else {
        return NO;
    }
}

- (void)setTapLedUsageIntroduced
{
    NSString* introKey = [NSString stringWithFormat:@"%@_%@", self.did, kWaterPurifierTapLEDIntroKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:introKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//zcm 特定净水记录
- (void)getOncePurifyRecordsForTime:(NSDate *)time completion:(void (^)(NSArray *))completion
{
    if (time == nil) {
        time = [NSDate date];
    }
    MHGetWaterPurifyRecordsRequest* request = [MHGetWaterPurifyRecordsRequest new];
    request.did = self.did;
    request.type = MHWaterPurifyOnceRecord;
    request.timeEnd = (NSUInteger)[time timeIntervalSince1970] + 3600*24;
    request.timeStart = (NSUInteger)[time timeIntervalSince1970] + 3600*24 - 3600 * 24 * 365;
    
    [[MHNetworkEngine sharedInstance] sendRequest:request success:^(id json) {
        //获取数据成功
        MHGetWaterPurifyRecordsResponse* response = [MHGetWaterPurifyRecordsResponse responseWithJSONObject:json];
        
        [response.records enumerateObjectsUsingBlock:^(MHDataWaterPurifyRecord* record, NSUInteger idx, BOOL *stop) {
            if (record.state == MHWaterPurifyRecordStatePurifying && idx != 0) {
                record.state = MHWaterPurifyRecordStateIdle;
            }
            //2018年 1月20号 00:00:01之前的大于80000L的数据清零
            if([record.time timeIntervalSince1970] <= 1516377601 && (record.outVolumn >= 80000000 || record.inVolumn >= 80000000)) {
                record.outVolumn = 0;
                record.inVolumn = 0;
            }
            
        }];
        if (completion) {
            completion(response.records);
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
        if (completion) {
            completion(nil);
        }
    }];
}

//zcm 所有净水记录
- (void)getPurifyRecordsForType:(MHWaterPurifyRecordType)type completion:(void (^)(NSArray *))completion
{
    NSTimeInterval now = (NSUInteger)[[NSDate date] timeIntervalSince1970];
    MHGetWaterPurifyRecordsRequest* request = [MHGetWaterPurifyRecordsRequest new];
    request.did = self.did;
    request.type = type;
//    request.timeStart = now - 30*24*3600;
    request.timeEnd = now + 3600*24;
    
    [[MHNetworkEngine sharedInstance] sendRequest:request success:^(id json) {
        MHGetWaterPurifyRecordsResponse* response = [MHGetWaterPurifyRecordsResponse responseWithJSONObject:json];
        //柱形图需要的记录按时间升序排列，须把records反转
        NSMutableArray* reversedRecords = [NSMutableArray array];
        for (id record in [response.records reverseObjectEnumerator]) {
            [reversedRecords addObject:record];
        }
        if (completion) {
            completion(reversedRecords);
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
        if (completion) {
            completion(nil);
        }
    }];
}

- (void)getSubPurifyRecordsForRecord:(MHDataWaterPurifyRecord *)record completion:(void (^)(NSArray *))completion
{
    MHWaterPurifyRecordType type = MHWaterPurifyOnceRecord;
    NSDate* startTime = nil;
    NSDate* endTime = nil;
    NSInteger limit = 0;
    if (record.type == MHWaterPurifyOnceRecord) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    else if (record.type == MHWaterPurifyDailyRecord) {
        type = MHWaterPurifyOnceRecord;
        startTime = record.time;
        endTime = [NSDate dateWithTimeInterval:3600 * 24 sinceDate:record.time]; //获取onceRecord时需要+3600 * 24，变态的接口
    }
    else if (record.type == MHWaterPurifyWeeklyRecord) {
        type = MHWaterPurifyDailyRecord;
//        startTime = [MHTimeUtils firstDayOfWeekWhichContainsDate:record.time];
//        endTime = [MHTimeUtils lastDayOfWeekWhichContainsDate:record.time];
        
        //zcm 修改 每周开始时间为周一
        startTime = [MHTimeUtils firstDayOfWeekWhichContainsDate:record.time];;  //周日
        endTime = [MHTimeUtils lastDayOfWeekWhichContainsDate:record.time];; //周六
        
        startTime = [NSDate dateWithTimeInterval:3600 * 24 sinceDate:startTime]; //改为周一
        endTime = [NSDate dateWithTimeInterval:3600 * 24 sinceDate:endTime]; //改为周日
        
        limit = 7;
    }
    else if (record.type == MHWaterPurifyMonthlyRecord) {
//        type = MHWaterPurifyWeeklyRecord;
//        //zcm 取消限制，必须要加上限制时间
//        startTime = [MHTimeUtils firstDayOfMonthWhichContainsDate:record.time]; //不能限制，会有跨月的周
//        endTime = [MHTimeUtils lastDayOfMonthWhichContainsDate:record.time];
//        limit = 4;
        
        //zcm 请求一个月的数据，自行计算，解决跨月周的问题
        type = MHWaterPurifyDailyRecord;
        startTime = [MHTimeUtils firstDayOfMonthWhichContainsDate:record.time];
        endTime = [MHTimeUtils lastDayOfMonthWhichContainsDate:record.time];
    }
    
    MHGetWaterPurifyRecordsRequest* request = [MHGetWaterPurifyRecordsRequest new];
    request.did = self.did;
    request.type = type;
    request.timeStart = (NSUInteger)[startTime timeIntervalSince1970];
//    request.timeEnd = [endTime timeIntervalSince1970] + 3600*24;
    request.timeEnd = (NSUInteger)[endTime timeIntervalSince1970];  //zcm 修改
    request.limit = limit;
    
    [[MHNetworkEngine sharedInstance] sendRequest:request success:^(id json) {
        MHGetWaterPurifyRecordsResponse* response = [MHGetWaterPurifyRecordsResponse responseWithJSONObject:json];
        //zcm 月数据将会特殊处理
        if(record.type == MHWaterPurifyMonthlyRecord) {
            response = [MHDeviceWaterpurifier handleMonthlyRecord:response];
        }
        if (completion) {
            completion(response.records);
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
        if (completion) {
            completion(nil);
        }
    }];
}

//zcm 特殊处理
+ (MHGetWaterPurifyRecordsResponse *)handleMonthlyRecord:(MHGetWaterPurifyRecordsResponse *)response
{
    if(!response.records) {
        return response;
    }
    NSArray <MHDataWaterPurifyRecord *>* oldRecords = [[[response.records reverseObjectEnumerator] allObjects] copy];  //反转数组
    
    NSMutableArray <MHDataWaterPurifyRecord *>* newRecords = [NSMutableArray array];
    
    [oldRecords enumerateObjectsUsingBlock:^(MHDataWaterPurifyRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 0) {
            //添加第一个元素
            MHDataWaterPurifyRecord *record = obj;
            record.type = MHWaterPurifyWeeklyRecord;
            [newRecords addObject:record];
        }else {
            MHDataWaterPurifyRecord *preRecord = [newRecords lastObject];
            
            NSDate *yesterDay = [MHTimeUtils yesterdayForDate:preRecord.time]; //米家以周日为开始，我们以周日为开始，这边需要减去一天才能计算到正确的周
            
            NSDate *thisWeekLastDate = [NSDate dateWithTimeInterval:3600 * 24
                                                          sinceDate:[MHTimeUtils lastDayOfWeekWhichContainsDate:yesterDay]]; //周日
            
            if([obj.time timeIntervalSince1970 ] <= [thisWeekLastDate timeIntervalSince1970]) {
                //本周
                preRecord.inVolumn += obj.inVolumn;
                preRecord.outVolumn += obj.outVolumn;
                preRecord.costTime += obj.costTime;
                preRecord.type = MHWaterPurifyWeeklyRecord;
                //更新数据
                [newRecords replaceObjectAtIndex:(newRecords.count - 1) withObject:preRecord];
            }else {
                //非本周
                MHDataWaterPurifyRecord *record = obj;
                record.type = MHWaterPurifyWeeklyRecord;
                //添加数据
                [newRecords addObject:record];
            }
        }
        
        NSLog(@"月净水详情 %@ - 出水：%d - 耗时: %d",[newRecords lastObject].time,[newRecords lastObject].outVolumn,[newRecords lastObject].costTime);
    }];
    
    response.records = [[[newRecords reverseObjectEnumerator] allObjects] copy];

    return response;
}

//zcm 异常提醒
- (void)getExcNotifySetting
{
    MHGetDeviceSceneNewRequest* request = [MHGetDeviceSceneNewRequest new];
    request.identify = self.did;
    request.stId = @"1";
    
    [[MHNetworkEngine sharedInstance] sendRequest:request success:^(id json) {
        MHGetDeviceSceneNewResponse* rsp = [MHGetDeviceSceneNewResponse responseWithJSONObject:json];
        if (rsp.code == MHNetworkErrorOk && [rsp.scenes isKindOfClass:[NSArray class]]) {
            if ([rsp.scenes count] > 0) {
                MHDataSceneNew* scene = [rsp.scenes objectAtIndex:0];
                if ([scene.setting isKindOfClass:[NSDictionary class]]) {
                    id runExc = [scene.setting objectForKey:@"enable_fail_record"];
                    if (runExc) {
                        self.runExceptionNotifyEnabled = [runExc integerValue] == 1 ? YES : NO;
                    }
                    id tdsExc = [scene.setting objectForKey:@"enable_water_quailty_worning"];
                    if (tdsExc) {
                        self.tdsExceptionNotifyEnabled = [tdsExc integerValue] == 1 ? YES : NO;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

- (void)syncExcNotifySetting:(void (^)(BOOL))result
{
    MHEditDeviceSceneNewRequest* req = [[MHEditDeviceSceneNewRequest alloc] init];
    
    MHDataSceneNew *scene = [[MHDataSceneNew alloc] init];
    scene.us_id = 123;
    scene.identify = self.did;
    scene.name = @"净水器通知";
    scene.st_id = @"1";
    scene.authed = @[self.did];
    
    NSDictionary* setting = @{@"enable_fail_record" : @(self.runExceptionNotifyEnabled ? 1 : 0),
                              @"enable_water_quailty_worning" : @(self.tdsExceptionNotifyEnabled ? 1 : 0)};
    scene.setting = setting;
    req.scene = scene;
    
    [[MHNetworkEngine sharedInstance] sendRequest:req success:^(id obj) {
        MHEditDeviceSceneNewResponse* rsp = [MHEditDeviceSceneNewResponse responseWithJSONObject:obj];
        if (result) {
            result(rsp.code == MHNetworkErrorOk);
        }
    } failure:^(NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)postTdsWarningOrangeValue:(NSInteger )value completion:(void (^)(BOOL))completion
{
    NSMutableDictionary *jason = [[NSMutableDictionary alloc] init];
    
    NSInteger PRC = [self getRPCNonce];
    
    [jason setObject:@(PRC) forKey:@"id"];
    [jason setObject:@"set_tds_warn_thd" forKey:@"method"];
    [jason setObject:@[@(value)] forKey:@"params"];
    
    [self sendPayload:jason success:^(id result) {
        NSLog(@"成功设置小米净水器2阈值为%i",value);
        
        completion(YES);
        
    } failure:^(NSError *error) {
        NSLog(@"设置小米净水器2阈值失败，原因：%@",error);
        
        completion(NO);
    }];
}

//获取冲洗数据
- (void)getWashData
{
    //"maintenance_interval" 保养间隔 单位小时，超过72小时APP才显示提醒用户保养
    //"maintenance_state" 保养状态 0 = 保养结束 1 = 保养中
    
    //@{@"id" : @(id), @"method" : @"method", @"params" : originData, @"other" : other}
    NSMutableDictionary* jason = [[NSMutableDictionary alloc] init];
    [jason setObject:@([self getRPCNonce]) forKey:@"id"];
    [jason setObject:@"get_prop" forKey:@"method"];
    [jason setObject:@[@"maintenance_interval",@"maintenance_state"] forKey:@"params"];
    [self sendPayload:jason success:^(id result) {
        NSLog(@"getWashData result:%@",result);
        NSNumber *code = [result objectForKey:@"code"];
        if (code.integerValue == 0) {
            NSArray *datas = [result objectForKey:@"result"];
            if (datas && datas.count > 0) {
                NSNumber *hours = [datas objectAtIndex:0];
                self.washHours = hours.integerValue;
                
                NSNumber *status = [datas objectAtIndex:1];
                self.washStatus = status.integerValue;

            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}


@end
