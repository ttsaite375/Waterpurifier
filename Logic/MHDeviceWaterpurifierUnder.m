//
//  MHDeviceWaterpurifierUnder.m
//  MiHome
//
//  Created by ChengMinZhang on 2017/11/16.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHDeviceListManager.h"
#import "MHDeviceWaterpurifierUnder.h"

@implementation MHDeviceWaterpurifierUnder

+ (void)load {
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX3 className:NSStringFromClass([MHDeviceWaterpurifierUnder class]) isRegisterBase:YES];
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPurifierV3 className:NSStringFromClass([MHDeviceWaterpurifierUnder class]) isRegisterBase:YES];
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX6 className:NSStringFromClass([MHDeviceWaterpurifierUnder class]) isRegisterBase:YES];
}

- (BOOL)isShownInQuickConnectList {
    return YES;
}

+(NSString *)defaultName
{
    return WaterpurifierString(@"waterpurifier.name.under", @"小米净水器厨下版");
}

@end
