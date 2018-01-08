//
//  MHDeviceWaterpurifier2.m
//  MiHome
//
//  Created by ChengMinZhang on 2017/11/16.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHDeviceListManager.h"
#import "MHDeviceWaterpurifier2.h"

@implementation MHDeviceWaterpurifier2

+ (void)load {
    [MHDeviceListManager registerDeviceModelId:DeviceModelWaterPuriLX5 className:NSStringFromClass([MHDeviceWaterpurifier2 class]) isRegisterBase:YES];
}

- (BOOL)isShownInQuickConnectList {
    return YES;
}

+ (NSString *)defaultName
{
    return [NSString stringWithFormat:@"%@2",NSLocalizedString(@"waterpurifier","小米净水器")]; //小米净水器2
}

//zcm 米二代请求json格式有所改变，参数必须自己限定，
- (NSDictionary *)getStatusRequestPayload {
    
    // LX2、LX3、LX4三款一代产品依旧使用父类的json格式
    if(![self.model isEqualToString:DeviceModelWaterPuriLX5]) {
        return  [super getStatusRequestPayload];
    }
    
    NSMutableDictionary* jason = [[NSMutableDictionary alloc] init];
    [jason setObject:@(1) forKey:@"id"];
    [jason setObject:@"get_prop" forKey:@"method"];
    
    NSArray *array = @[@"tds_out",@"temperature",
                       @"f1_totalflow",@"f1_totaltime",@"f1_usedflow",@"f1_usedtime",
                       @"f2_totalflow",@"f2_totaltime",@"f2_usedflow",@"f2_usedtime",
                       @"run_status",@"tds_warn_thd",@"tds_out_avg",@"rinse"];
    
    [jason setObject:array forKey:@"params"];
    
    return jason;
}

@end
