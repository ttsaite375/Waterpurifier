//
//  MHWaterpurifierDefine.h
//  MiHome
//
//  Created by Wayne Qiao on 16/5/18.
//  Copyright © 2016年 小米移动软件. All rights reserved.
//

#ifndef MHWaterpurifierDefine_h
#define MHWaterpurifierDefine_h

//#define WaterpurifierString(key, comment) NSLocalizedStringFromTable((key), @"device_waterpurifier", (comment))

#define WaterpurifierString(key,comment) \
({\
NSBundle *templete = [NSBundle bundleForClass:[self class]];\
NSURL *url = [templete URLForResource:@"Waterpurifier" withExtension:@"bundle"];\
NSString *string = @"";\
if(!url) {\
string = key;\
}else {\
NSBundle *bundle = [NSBundle bundleWithURL:url];\
string = NSLocalizedStringFromTableInBundle(key,@"device_waterpurifier", bundle, comment);\
}\
(string);\
})\

//小米净水器厨上版
#define DeviceModelWaterPurifier @"yunmi.waterpurifier.v1"
#define DeviceModelWaterPuriLX2 @"yunmi.waterpuri.lx2"
//小米净水器厨下版
#define DeviceModelWaterPuriLX3 @"yunmi.waterpuri.lx3"
#define DeviceModelWaterPurifierV3 @"yunmi.waterpurifier.v3"
#define DeviceModelWaterPuriLX6 @"yunmi.waterpuri.lx6"
//小米净水器厨上增强版
#define DeviceModelWaterPuriLX4 @"yunmi.waterpuri.lx4"
//小米净水器2
#define DeviceModelWaterPuriLX5 @"yunmi.waterpuri.lx5"

#endif /* MHWaterpurifierDefine_h */



