//
//  MHWaterTDSCurveDiagram.h
//  MiHome
//
//  Created by wayne on 15/7/2.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHDataWaterPurifyRecord.h"

@interface MHWaterTDSDrawObject : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger inTDS;      //自来水TDS
@property (nonatomic, assign) NSInteger maxInTDS;   //最大自来水TDS
@property (nonatomic, assign) NSInteger outTDS;     //纯净水TDS
@property (nonatomic, assign) NSInteger maxOutTDS;  //最大纯净水TDS
@property (nonatomic, assign) BOOL isPurifying;     //是否正在净水
@property (nonatomic, retain) NSDate* time;

@end

@interface MHWaterTDSCurveDiagram : UIView

@property (nonatomic, retain) MHDataWaterPurifyRecord *record;

@property (nonatomic, assign) BOOL isWaterPurifyLX5;

- (void)animationCurveFadeIn;

@end
