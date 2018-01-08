//
//  MHDeviceWaterpurifierOnPower.m
//  MiHome
//
//  Created by ChengMinZhang on 2017/11/16.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHDeviceListManager.h"
#import "MHDeviceWaterpurifierOnPower.h"

@implementation MHDeviceWaterpurifierOnPower

+ (void)load {
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX4 className:NSStringFromClass([MHDeviceWaterpurifierOnPower class]) isRegisterBase:YES];
}

- (BOOL)isShownInQuickConnectList {
    return YES;
}

+(NSString *)defaultName
{
    return WaterpurifierString(@"waterpurifier.name.on.power", @"小米净水器厨上增强版");
}

@end
