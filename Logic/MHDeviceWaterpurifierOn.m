//
//  MHDeviceWaterpurifierOn.m
//  MiHome
//
//  Created by ChengMinZhang on 2017/11/16.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//
#import "MHDeviceListManager.h"
#import "MHDeviceWaterpurifierOn.h"

@implementation MHDeviceWaterpurifierOn

+ (void)load {
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPurifier className:NSStringFromClass([MHDeviceWaterpurifierOn class]) isRegisterBase:YES];
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX2 className:NSStringFromClass([MHDeviceWaterpurifierOn class]) isRegisterBase:YES];
}

- (BOOL)isShownInQuickConnectList {
    return YES;
}

+(NSString *)defaultName
{
    return WaterpurifierString(@"waterpurifier.name.on" , @"小米净水器厨上版");
//    return GetURLWith(1,@"");
}

@end
