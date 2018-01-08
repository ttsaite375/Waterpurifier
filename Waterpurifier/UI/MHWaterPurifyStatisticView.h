//
//  MHWaterPurifyStatisticView.h
//  MiHome
//
//  Created by wayne on 15/6/29.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHDeviceWaterpurifier.h"
//#import "MHDeviceWaterPurifierLX.h"

@interface MHWaterPurifyStatisticView : UIView

- (void)refreshPurifyStatisticData;

@property (nonatomic, retain) MHDeviceWaterpurifier* device;

@end
