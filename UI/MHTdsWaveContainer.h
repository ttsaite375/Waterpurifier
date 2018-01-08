//
//  MHTdsWaveContainer.h
//  MiHome
//
//  Created by wayne on 15/7/8.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHDeviceWaterpurifier.h"
//#import "MHDeviceWaterPurifierLX.h"

@interface MHTdsWaveContainer : UIView

@property (nonatomic, retain) MHDeviceWaterpurifier* device;
@property (nonatomic, assign) CGFloat digitalScale;
@property (nonatomic, copy) void (^tdsDetailHandler)();
@property (nonatomic, copy) void (^exceptionHandler)();
//@property (nonatomic, copy) void (^washHandler)();

- (void)reloadTdsValue:(BOOL)deviceOnline;
- (void)startWaveAnimation;
- (void)stopWaveAnimation;

- (void)startUpIndicatorAnimation;
- (void)stopUpIndicatorAnimation;

@end
