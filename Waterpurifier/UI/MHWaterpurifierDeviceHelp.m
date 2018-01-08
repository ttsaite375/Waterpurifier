//
//  MHWaterpurifierUtils.m
//  MiHome
//
//  Created by liushilou on 17/1/11.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import <sys/utsname.h>

#import "MHWaterpurifierDeviceHelp.h"

@implementation MHWaterpurifierDeviceHelp

+ (BOOL)isUnderDevice:(NSString *)model
{
    //    if ([model isEqualToString:MHW_DEVICE_V3] || [model isEqualToString:MHW_DEVICE_LX3] ) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
    //zmc 修改 添加厨下 lx5
    if ([model isEqualToString:MHW_DEVICE_V3] || [model isEqualToString:MHW_DEVICE_LX3] || [model isEqualToString:MHW_DEVICE_LX5]) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isOnDevice:(NSString *)model
{
    if ([model isEqualToString:MHW_DEVICE_V1] || [model isEqualToString:MHW_DEVICE_V2] || [model isEqualToString:MHW_DEVICE_LX2]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isPhoneX
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    if([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
        //模拟器
        if([[UIApplication sharedApplication] statusBarFrame].size.height == 44) {
            return YES;
        }else {
            return NO;
        }
    }else {
        //真机
        if([code isEqualToString:@"iPhone10,3"] ||[code isEqualToString:@"iPhone10,6"] ) {
            return YES;
        }else {
            return NO;
        }
    }
}

+ (NSString *)localedStringKey:(NSString *)key comment:(NSString *)comment
{
    NSString *localedString = [[MHBundleManager shared] localizedStringForKey:key comment:comment table:@"device_waterpurifier" moduleResourceType:MHModuleResourceType_Waterpurifier];
    
    return [localedString copy];
}


@end

