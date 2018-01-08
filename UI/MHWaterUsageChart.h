//
//  MHWaterUsageChart.h
//  MiHome
//
//  Created by wayne on 15/6/30.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHDeviceWaterpurifier.h"
#import "MHWaterUsagePole.h"
//#import "MHDeviceWaterPurifierLX.h"

@interface MHWaterUsageChart : UIView

- (void)refreshPurifyRecords;

@property (nonatomic, copy) void (^recordSelectedHandler)(MHWaterUsageObject *);
@property (nonatomic, retain) MHDeviceWaterpurifier* device;

@end
