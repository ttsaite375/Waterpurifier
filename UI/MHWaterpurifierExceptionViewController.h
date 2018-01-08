//
//  MHWaterpurifierExceptionViewController.h
//  MiHome
//
//  Created by wayne on 15/7/17.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHViewController.h"
#import "MHDeviceWaterpurifier.h"
//#import "MHDeviceWaterPurifierLX.h"

@interface MHWaterpurifierExceptionViewController : MHViewController

@property (nonatomic, retain) MHDeviceWaterpurifier* device;
@property (nonatomic, assign) NSInteger exceptionSerialNo; //异常序号

//+ (NSString *)exceptionTitleForSerialNo:(NSInteger)sNo;

/**
 *  @brief 根据异常信号获取异常信息
 *  @param sNo 异常信号
 *  @param model 当前设备Model
 *  @return NSString 异常信息
 */
+ (NSString *)exceptionTitleForSerialNo:(NSInteger)sNo ofDeviceModel:(NSString *)model;

@end
