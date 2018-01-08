//
//  MHWaterFilterStatusView.h
//  MiHome
//
//  Created by wayne on 15/6/29.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHDeviceWaterpurifier.h"
#import "MHWaterFilterObject.h"
//#import "MHDeviceWaterPurifierLX.h"

@interface MHWaterFilterStatusView : UIView

- (void)reloadFilterStatus:(BOOL)deviceOnline;

@property (nonatomic, retain) MHDeviceWaterpurifier* device;
@property (nonatomic, copy) void (^filterSelectedHandler)(MHWaterFilterObject *);

@end
