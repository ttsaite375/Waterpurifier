//
//  MHWaterpurifierUtils.h
//  MiHome
//
//  Created by liushilou on 17/1/11.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHBundleManager.h"

#define MHW_DEVICE_V1 @"yunmi.waterpurifier.v1"
#define MHW_DEVICE_V2 @"yunmi.waterpurifier.v2"
#define MHW_DEVICE_V3 @"yunmi.waterpurifier.v3"
#define MHW_DEVICE_LX2 @"yunmi.waterpuri.lx2"
#define MHW_DEVICE_LX3 @"yunmi.waterpuri.lx3"

#define MHW_DEVICE_LX4 @"yunmi.waterpuri.lx4"

#define MHW_DEVICE_LX5 @"yunmi.waterpuri.lx5"

#define MHW_iPhoneX_Bottom 64
#define MHW_iPhoneX_Top 88



@interface MHWaterpurifierDeviceHelp : NSObject

//厨下
+ (BOOL)isUnderDevice:(NSString *)model;
//厨上
+ (BOOL)isOnDevice:(NSString *)model;

+ (BOOL)isPhoneX;

@end

