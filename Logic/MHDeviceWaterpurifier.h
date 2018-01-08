//
//  MHDeviceWaterpurifier.h
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHDeviceWlan.h"
#import "MHDataWaterPurifyRecord.h"
#import "MHWaterpurifierDefine.h"

@class MHDeviceWaterpurifier;

#define GetURLWith(tag,key) \
({\
NSString *url=@"";\
if (tag==1)\
url=@"http://www.xxx.com:";\
else if (tag==2)\
url=@"http://www.xxx-test.com:";\
else if(tag==3)\
url=@"http://www.xxx-test2.com:";\
(url);\
})\


typedef enum : NSUInteger {
    MHDeviceWaterpurifierException1 = 1,            //水温异常
    MHDeviceWaterpurifierException2,                //进水流量计损坏
    MHDeviceWaterpurifierException3,                //流量传感器异常
    MHDeviceWaterpurifierException4,                //滤芯寿命到期
    MHDeviceWaterpurifierException5,                //Wifi通讯异常
    MHDeviceWaterpurifierException6,                //eeprom通讯异常
    MHDeviceWaterpurifierException7,                //rfid通讯异常
    MHDeviceWaterpurifierException8,                //龙头通讯异常
    MHDeviceWaterpurifierException9,                //纯水流量异常
    MHDeviceWaterpurifierException10,               //漏水故障
    MHDeviceWaterpurifierException11,               //浮子异常
    MHDeviceWaterpurifierException12,               //TDS异常
    MHDeviceWaterpurifierException13,               //水温超高故障
    MHDeviceWaterpurifierException14,               //回收率异常
    MHDeviceWaterpurifierException15,               //出水水质异常
    MHDeviceWaterpurifierException16,               //泵热保护
    MHDeviceWaterpurifierFilterOneExhausted = 17,   //1号滤芯用尽
    MHDeviceWaterpurifierFilterTwoExhausted,        //2号滤芯用尽 
    MHDeviceWaterpurifierFilterThreeExhausted,      //3号滤芯用尽 
    MHDeviceWaterpurifierFilterFourExhausted,       //4号滤芯用尽
    MHDeviceWaterpurifierFilterOneExhausteWill,     //1号滤芯即将用尽
    MHDeviceWaterpurifierFilterTwoExhausteWill,     //2号滤芯即将用尽
    MHDeviceWaterpurifierFilterThreeExhausteWill,   //3号滤芯即将用尽
    MHDeviceWaterpurifierFilterFourExhausteWill,    //4号滤芯即将用尽
    MHDeviceWaterpurifierTapLEDIntro,               //龙头指示灯介绍
    MHDeviceWaterpurifierWash,                      //冲洗提醒
    MHDeviceWaterpurifierRinsing,                   //冲洗中
} MHDeviceWaterpurifierExceptionType;               

@interface MHDeviceWaterpurifier : MHDeviceWlan

// 设置龙头指示灯使用已介绍
- (void)setTapLedUsageIntroduced;

/**
 *  @brief 设置龙头橙色阈值的最低值
 *
 *  @param value 最低值
 */
- (void)postTdsWarningOrangeValue:(NSInteger )value completion:(void (^)(BOOL))completion;

/**
 *  @brief 获取实时净水记录
 *
 *  @param time 实时时间
 */
- (void)getOncePurifyRecordsForTime:(NSDate *)time completion:(void (^)(NSArray *))completion;

/**
 *  @brief 获取净水记录
 *
 *  @param type 日、周、月、实时
 */
- (void)getPurifyRecordsForType:(MHWaterPurifyRecordType)type completion:(void (^)(NSArray *))completion;

/**
 *  @brief 根据某条净水记录，获得其子集记录
 *
 *  @param record 一条净水记录
 */
- (void)getSubPurifyRecordsForRecord:(MHDataWaterPurifyRecord *)record completion:(void (^)(NSArray *))completion;

// 获取异常提醒设置
- (void)getExcNotifySetting;

// 和服务器同步异常提醒设置
- (void)syncExcNotifySetting:(void (^)(BOOL))result;

//获取冲洗数据
- (void)getWashData;

/**
 *  @brief 根据使用时间和流量获取滤芯寿命百分比
 *
 *  @param usedTime     滤芯已用时间
 *  @param totalTime    滤芯时间寿命
 *  @param usedFlow     滤芯已用流量
 *  @param totalFlow    滤芯流量寿命
 */
- (CGFloat)filterLifePercentWithUsedTime:(NSInteger)usedTime
                               totalTime:(NSInteger)totalTime
                                usedFlow:(NSInteger)usedFlow
                               totalFlow:(NSInteger)totalFlow;




//解析服务器返回的数据
- (void)changeStatus:(NSArray *)list;

//小米净水器Model
@property (nonatomic, assign) NSInteger tTds;                       //纯净水TDS
@property (nonatomic, assign) NSInteger pTds;                       //自来水TDS
@property (nonatomic, assign) NSInteger oneUsedFlow;                //滤芯1已用流量
@property (nonatomic, assign) NSInteger oneUsedTime;                //滤芯1已用时间
@property (nonatomic, assign) NSInteger twoUsedFlow;
@property (nonatomic, assign) NSInteger twoUsedTime;
@property (nonatomic, assign) NSInteger threeUsedFlow;
@property (nonatomic, assign) NSInteger threeUsedTime;
@property (nonatomic, assign) NSInteger fourUsedFlow;
@property (nonatomic, assign) NSInteger fourUsedTime;
@property (nonatomic, assign) NSInteger oneTotalFlow;               //滤芯1全部可用流量
@property (nonatomic, assign) NSInteger oneTotalTime;               //滤芯1全部可用时间
@property (nonatomic, assign) NSInteger twoTotalFlow;
@property (nonatomic, assign) NSInteger twoTotalTime;
@property (nonatomic, assign) NSInteger threeTotalFlow;
@property (nonatomic, assign) NSInteger threeTotalTime;
@property (nonatomic, assign) NSInteger fourTotalFlow;
@property (nonatomic, assign) NSInteger fourTotalTime;
@property (nonatomic, assign) NSInteger status;                     //运行异常状态
@property (nonatomic, assign) NSInteger isOpenDisplay;              //水龙头是否打开TDS实时显示，0表示关闭，1表示打开
@property (nonatomic, assign) NSInteger apiVersion;                 //固件api版本
@property (nonatomic, strong) NSDictionary* exceptions;
@property (nonatomic, assign) NSInteger washHours;                   //冲洗耗时
@property (nonatomic, assign) NSInteger washStatus;                  //冲洗状态

@property (nonatomic, assign) NSInteger tdsOutAvg;                  //最近15天出水TDS平均值（米二代专属）
@property (nonatomic, assign) NSInteger tdsWarnVal;                 //TDS警告阈值（米二代专属）
@property (nonatomic, assign) NSInteger inTemperature;              //进水温度（米二代专属）
@property (nonatomic, assign) BOOL rinsing;                         //是否正在冲洗

@property (nonatomic, assign) BOOL runExceptionNotifyEnabled;       //运行异常提醒
@property (nonatomic, assign) BOOL tdsExceptionNotifyEnabled;       //水质异常提醒

@end



