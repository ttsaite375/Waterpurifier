//
//  MHWaterWaveView.h
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHWaterWaveView : UIView

@property (nonatomic, assign) CGFloat amplitude;    //振幅
@property (nonatomic, assign) CGFloat frequency;    //频率 50 = 2PI
@property (nonatomic, assign) CGFloat velocity;     //速度 default:1.0
@property (nonatomic, assign) CGFloat phase;        //相位
@property (nonatomic, retain) UIColor* color;       //颜色

- (void)startWaveAnimation;
- (void)stopWaveAnimation;

@end
